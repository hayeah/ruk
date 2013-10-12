require 'spec_helper'

describe Ruk::Matcher do
  include Helpers
  alias_method :build, :matcher

  let(:line10) { line(10) }
  let(:line5) { line(5) }

  context "build(:all):" do
    subject {
      build(:all)
    }

    it "returns an AllMatch" do
      should be_a(Ruk::Matcher::AllMatch)
    end

    it "matches any line" do
      should be_match(line10)
      should be_match(line5)
    end
  end

  context "build(5):" do
    subject {
      build(5)
    }

    it "matches line5" do
      should be_match(line5)
    end

    it "doesn't match line10" do
      should_not be_match(line10)
    end
  end

  context "build(5..10):" do
    subject { build(5..10) }
    it "matches lines within range" do
      should be_match(line5)
      should be_match(line10)
    end

    it "doesn't match lines outside range" do
      should_not be_match(line(20))
    end
  end

  context "build { ... } :" do
    it "matches if block returns truthy" do
      build { true }.should be_match(line10)
      build { 10 }.should be_match(line10)
      build { [] }.should be_match(line10)
    end

    it "doesn't match if block returns falsey" do
      build { false }.should_not be_match(line10)
      build { nil }.should_not be_match(line10)
    end

    it "evals blocks in the context of a line" do
      this_line = line(100)
      build { self.should == this_line }.match?(this_line)
    end
  end
end
