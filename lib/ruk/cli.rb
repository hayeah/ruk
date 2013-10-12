class Ruk::CLI
  def run
    options.permute!
    args = ARGV
    matcher = Ruk::Eval.build *args
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
