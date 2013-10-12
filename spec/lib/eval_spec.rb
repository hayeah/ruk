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

  # test cases
  context "short form with block matcher:" do
    subject(:clause) {
      Ruk::Eval.build("{ length > 3 }", "self")
    }

    it "matches lines longer than 3 chars" do
      this = "abcd"
      clause.process(this).should == this
    end

    it "doesn't match a line less than 3 chars" do
      this = "abc"
      clause.process(this).should be_nil
    end
  end

  def ruk(*args)
    Ruk::Eval.build(*args)
  end

  context "is {...}.do {}:" do
    subject(:clause) {
      ruk("is { self == 'cba' }.do { self }")
    }

    it "matches 'abc'" do
      this = "cba"
      clause.process(this).should == this
    end
  end

  context "at(is {...}) { ... }" do
    subject(:clause) {
      ruk("at(is { self == 'cba' }) { self }")
    }

    it "matches 'abc'" do
      this = "cba"
      clause.process(this).should == this
    end
  end

  context "at(...) { ... }.at(...) { ... }:" do
    subject { ruk("at(1) { 'a' }.at(2) { 'b' }")  }
  end
end
