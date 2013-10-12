require 'spec_helper'

describe Ruk::Line do
  let(:str) { "abc" }
  let(:line) {
    Ruk::Line.new(str,1)
  }

  subject { line }
  its(:lineno) { should == 1 }
  its(:line) { should == str }
  its(:l) { should == str }
end

