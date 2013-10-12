require "spec_helper"

describe Ruk::Eval do
  include Helpers
  context "build(match,action) # shorthand form:" do
    subject(:clause) {
      Ruk::Eval.build("10","self")
    }

    it { should be_a(Ruk::Clause) }
    it "matches and returns the 10th line" do
      this = line(10)
      clause.process(this).should == this
    end
  end

  context "build(matcher) # explicit form:" do
    subject(:clause) {
      Ruk::Eval.build("at(10) { self }")
    }

    it { should be_a(Ruk::Clause) }
    it "matches and returns the 10th line" do
      this = line(10)
      clause.process(this).should == this
    end
  end
end
