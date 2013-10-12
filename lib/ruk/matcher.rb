# A matcher is any object that responds to match?(line)
module Ruk::Matcher
  # Factory that builds a matcher object
  def self.build(arg=nil,&block)
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

    # @return [Ruk::Clause]
    def do(&block)
      Ruk::Clause.new(self,&block)
    end
  end
end
