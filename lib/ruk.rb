require "ruk/version"
require 'pp'

module Ruk
end

require "ruk/line"
require "ruk/matcher"
require "ruk/clause"
require "ruk/eval"
require "ruk/cli"

class Ruk::Processor
  def initialize(matcher,opts={})
    @matcher = matcher
  end

  def process(input,output,error)
    lineno = 1
    input.each_line { |line|
      ln = Ruk::Line.new(line.strip!, lineno)
      result = @matcher.process ln
      output.puts result if result # TODO option to disable default print
      lineno += 1
    }
  end
end
