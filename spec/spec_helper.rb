require 'ruk'

module Helpers
  def matcher(*args,&block)
    Ruk::Matcher.build(*args,&block)
  end

  def line(n)
    Ruk::Line.new("line #{n}",n)
  end
end
