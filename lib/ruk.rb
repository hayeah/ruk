require "ruk/version"
require 'pp'

module Ruk
end

class Ruk::Processor
  def initialize(matcher,opts={})
    @matcher = matcher
  end

  def process(input,output,error)
    lineno = 1
    input.each_line { |line|
      ln = Ruk::Line.new(line.strip!, lineno)
      result = @matcher.process ln
      output.puts result if result # TODO option to disable default print
      lineno += 1
    }
  end
end

class Ruk::Matcher
  class << self
    # build a matacher object from string
    def build(*args)
      if args.length == 2 # short hand form
        at = args[0].strip
        match = eval("Ruk::Matcher.when #{at}")
        processor = eval("Proc.new { #{args[1]} }")
        self.new(match,&processor)
      else
        expr = args[0]
        # Explicitly prefixing the class allows the "when" class method to work
        expr = "Ruk::Matcher.#{expr.strip}"
        self.instance_eval(expr)
      end
    end

    def at(arg,&block)
      matcher = self.when(arg)
      Ruk::Matcher.new(matcher,&block)
    end

    def when(arg=nil,&block)
      if block
        BlockMatch.new(&block)
      else
        case arg
        when :all
          AllMatch.new
        when Integer
          LineMatch.new(arg)
        when Range
          RangeMatch.new(arg)
        else # should respond to match?
          if arg.respond_to?(:match?)
            arg
          else
            raise "Invalid line matcher: #{arg}"
          end
        end

      end
    end
  end

  class AllMatch
    def match?(line)
      true
    end
  end

  class RangeMatch
    def initialize(range)
      @range = range
    end

    def match?(line)
      @range.member? line.lineno
    end
  end

  class LineMatch
    def initialize(n)
      @lineno = n
    end

    def match?(line)
      line.lineno == @lineno
    end
  end

  class BlockMatch
    def initialize(&block)
      @block = block
    end

    def match?(line)
      line.instance_eval &@block
    end

    def do(&block)
      Ruk::Matcher.new(self,&block)
    end
  end

  def initialize(matcher,&block)
    @matcher = matcher
    @processor = block
  end

  def process(line)
    if @matcher.match?(line)
      block = @processor
      line.instance_eval &block
    end
  end
end

class Ruk::CLI
  def run
    options.permute!
    args = ARGV
    matcher = Ruk::Matcher.build *args
    @input = $stdin
    @output = $stdout
    @error = $stderr
    ruk = Ruk::Processor.new(matcher)
    ruk.process(@input,@output,@error)
  end

  def options
    OptionParser.new do |o|
      o.banner = "Ruk #{Ruk::VERSION}"
      o.separator "ruk [addr] expr"
      o.on "-v", "--invert", "Invert the default matcher" do
        @invert = true
      end
      o.on_tail "-h","--help","Show Help" do 
        puts o
        exit
      end
    end
  end
end
