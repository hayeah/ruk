module Ruk
  # This is the evaluator for a Ruk expression
  class Eval
    # Builds a clause by interpreting string expressions.
    #
    # The expressions should eval to a clause.
    #
    # Shorthand Form
    #
    # ruk <matcher> <action>
    #
    # Explicit Form
    #
    # ruk <clause>
    #
    # @return [Ruk::Clause]
    def self.build(*args)
      e = self.new
      if args.length == 2 # short hand form
        at = args[0].strip
        match = e.when(eval(at))
        action = eval("Proc.new { #{args[1]} }")
        Ruk::Clause.new(match,&action)
      else
        expr = args[0].strip
        # Explicitly prefixing with object allows the "when" method to be syntatically correct
        expr = "self.#{expr}"
        e.instance_eval(expr)
      end
    end

    # This binds an action to a pattern matcher.
    #
    # @return [Ruk::Clause]
    def at(arg,&action)
      matcher = self.when(arg)
      Ruk::Clause.new(matcher,&action)
    end

    # Builds a pattern matcher.
    # 
    # @return [Ruk::Matcher]
    def when(arg,&block)
      Ruk::Matcher.build(arg,&block)
    end
  end
end
