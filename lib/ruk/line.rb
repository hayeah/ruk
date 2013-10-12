require 'delegate'
class Ruk::Line < DelegateClass(String)
  attr_reader :lineno
  def initialize(line,lineno)
    @lineno = lineno
    super(line)
  end

  def l
    self.__getobj__
  end

  alias_method :line, :l
end


