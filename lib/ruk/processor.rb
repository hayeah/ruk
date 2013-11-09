module Ruk
  class Processor
    def initialize(eval,input,output,error,options={})
      @evaluator = eval
      @input = input
      @output = output
      @error = error
    end

    def process
      lineno = 1
      @evaluator.on_begin
      @input.each_line { |line|
        ln = Ruk::Line.new(line.strip!, lineno)
        result = @evaluator.process(ln)
        @output.puts result unless result.nil?
        lineno += 1
      }
      @evaluator.on_final
    end
  end
end