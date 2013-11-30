class Ruk::CLI
  def self.options
    opts = {}
    OptionParser.new do |o|
      o.banner = "Ruk #{Ruk::VERSION}"
      o.separator "ruk [addr] expr"
      o.on "-v", "--invert", "Invert the default matcher" do
        opts[:invert] = true
      end
      o.on_tail "-h","--help","Show Help" do
        puts o
        exit
      end
    end
  end

  def self.run
    opts = options.permute!
    self.new(ARGV,opts).run
  end

  def initialize(args,opts={})
    @options = opts
  end

  def run
    # Ruk::CLI.options.permute!
    args = ARGV
    if args.empty?
      puts "no expression given"
      exit 99
    end
    evaluator = Ruk::Eval.build *args
    input = $stdin
    output = $stdout
    error = $stderr
    processor = Ruk::Processor.new(evaluator,input,output,error)
    processor.process
  end

end
