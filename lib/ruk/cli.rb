class Ruk::CLI
  def run
    options.permute!
    args = ARGV
    evaluator = Ruk::Eval.build *args
    input = $stdin
    output = $stdout
    error = $stderr
    processor = Ruk::Processor.new(evaluator,input,output,error)
    processor.process
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
