require 'spec_helper'

describe Ruk::Clause do
  include Helpers
  let(:match5) {
    matcher(5)
  }

  context "process:" do
    def clause(&action)
      Ruk::Clause.new(match5,&action)
    end

    it "calls action if line matches" do
      dummy = double("dummy")
      dummy.should_receive(:hit)
      clause { dummy.hit }.process(line(5))
    end

    it "doesn't call action if line doesn't match" do
      dummy = double("dummy")
      clause { dummy.hit }.process(line(10))
    end

    it "evals action in the context of the line" do
      this = line(5)
      clause {
        self.should == this
      }.process(this)
    end
  end
end
