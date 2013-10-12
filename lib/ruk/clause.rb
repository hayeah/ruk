module Ruk
  # A clause executes an action on a line when its matcher matches the line.
  class Clause
    def initialize(matcher,&block)
      @matcher = matcher
      @action = block
    end

    def process(line)
      if @matcher.match?(line)
        line.instance_eval &@action
      end
    end
  end
end
