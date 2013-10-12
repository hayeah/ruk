module Ruk
  # A clause executes an action on a line when its matcher matches the line.
  class Clause
    def initialize(matcher,&block)
      @matcher = matcher
      @action = block
    end

    def process(line)
      if self.match?(line)
        self.exec(line)
      end
    end

    def match?(line)
      @matcher.match?(line)
    end

    def exec(line)
      line.instance_eval &@action
    end
  end
end
