require "ruk/version"
require 'pp'

module Ruk
end

require "ruk/line"
require "ruk/matcher"
require "ruk/clause"

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

class Ruk::EvalJunk
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
