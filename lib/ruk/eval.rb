module Ruk
  # This is the evaluator for a Ruk expression
  class Eval
    # Builds an evaluator by interpreting string expressions.
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
    # @return [Ruk::Eval]
    def self.build(*args)
      ev = self.new
      if args.length == 2 # short hand form
        at = args[0].strip
        match = ev.instance_eval("is #{at}")
        action = eval("Proc.new { #{args[1]} }")
        ev.at(match,&action)
      else
        expr = args[0].strip
        ev.instance_eval(expr)
      end
      return ev
    end

    def begin(&action)
      @begin_actions.push action
      self
    end

    def on_begin
      for action in @begin_actions do
        action.call
      end
    end

    def final(&action)
      @final_actions.push action
      self
    end

    def on_final
      for action in @final_actions do
        action.call
      end
    end

    # Evals on a line. Chooses the first matching clause.
    # @returns result of action, or nil if nothing matched.
    def process(line)
      for clause in @clauses do
        if clause.match? line
          result = clause.exec line
          return result
        end
      end
      return nil
    end

    def initialize
      @clauses = []
      @begin_actions = []
      @final_actions = []
    end

    # This binds an action to a pattern matcher.
    #
    # @return [Ruk::Clause]
    def at(arg=nil,&action)
      matcher = self.is(arg)
      clause = Ruk::Clause.new(matcher,&action)
      @clauses.push clause
      clause
    end

    # Builds a pattern matcher.
    #
    # @return [Ruk::Matcher]
    def is(arg=nil,&block)
      Ruk::Matcher.build(arg,&block)
    end
  end
end
