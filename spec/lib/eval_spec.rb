require "spec_helper"

describe Ruk::Eval do
  include Helpers
  def ruk(*args)
    Ruk::Eval.build(*args)
  end

  def process(line)
    subject.process(line)
  end

  context "build(match,action) # shorthand form:" do
    subject(:clause) {
      ruk("10","self")
    }

    it { should be_a(Ruk::Eval) }
    it "matches and returns the 10th line" do
      this = line(10)
      clause.process(this).should == this
    end
  end

  context "build(matcher) # explicit form:" do
    subject(:clause) {
      ruk("at(10) { self }")
    }

    it { should be_a(Ruk::Eval) }
    it "matches and returns the 10th line" do
      this = line(10)
      process(this).should == this
    end
  end

  # test cases
  context "short form with block matcher:" do
    subject {
      ruk("{ length > 3 }", "self")
    }

    it "matches lines longer than 3 chars" do
      this = "abcd"
      process(this).should == this
    end

    it "doesn't match a line less than 3 chars" do
      this = "abc"
      process(this).should be_nil
    end
  end

  context "at(is {...}) { ... }" do
    subject(:clause) {
      ruk("at(is { self == 'cba' }) { self }")
    }

    it "matches 'abc'" do
      this = "cba"
      process(this).should == this
    end
  end

  context "at(...) { ... } ; at(...) { ... }:" do
    subject { ruk("at(1) { 'a' } ; at(2) { 'b' }")  }
    it "matches line 2" do 
      process(line(2)).should == "b"
    end

    it "matches line 1" do
      process(line(1)).should == "a"
    end

    it "doesn't match line 3" do
      process(line(3)).should be_nil
    end

    it "chooses the first matching clause" do
      e = ruk("at(1..2) { 'range' } ; at(3) { 'c' }; at(1) { 'b' }")
      e.process(line(1)).should == "range"
      e.process(line(2)).should == "range"
      e.process(line(3)).should == "c"
    end
  end

  context "begin { ... }:" do
    let(:dummy) { double("dummy") }
    subject {
      ev = Ruk::Eval.new
      # ev.begin { dummy.hit2 }
    }

    it "runs begin callback" do
      dummy.should_receive :hit
      subject.begin { dummy.hit }
      subject.on_begin
    end

    it "runs callbacks in order" do
      dummy.should_receive(:hit).ordered
      dummy.should_receive(:hit2).ordered
      subject.begin { dummy.hit }
      subject.begin { dummy.hit2 }
      subject.on_begin
    end
  end
end
