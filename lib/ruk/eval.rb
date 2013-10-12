module Ruk
  # This is the evaluator for a Ruk expression
  module Eval
    extend self
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
    def build(*args)
      if args.length == 2 # short hand form
        at = args[0].strip
        match = eval("is #{at}")
        action = eval("Proc.new { #{args[1]} }")
        Ruk::Clause.new(match,&action)
      else
        expr = args[0].strip
        eval(expr)
      end
    end

    # This binds an action to a pattern matcher.
    #
    # @return [Ruk::Clause]
    def at(arg=nil,&action)
      matcher = self.is(arg)
      Ruk::Clause.new(matcher,&action)
    end

    # Builds a pattern matcher.
    # 
    # @return [Ruk::Matcher]
    def is(arg=nil,&block)
      Ruk::Matcher.build(arg,&block)
    end
  end
end
