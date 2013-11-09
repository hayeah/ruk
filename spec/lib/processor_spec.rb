require 'spec_helper'

require "stringio"

describe Ruk::Processor do
  include Helpers

  let(:input) {
    StringIO.new <<-HERE
line 1
line 2
line 3
HERE
  }

  let(:output) {
    StringIO.new ""
  }

  let(:evaluator) {
    ev = Ruk::Eval.new
  }

  let(:processor) {
    Ruk::Processor.new(evaluator,input,output,nil,nil)
  }

  def ruk(matcher,&action)
    evaluator.at(matcher,&action)
    processor.process
  end

  context "iterating lines:" do
    it "strips the line before passing it to evaluator" do
      ruk(:all) { strip.should == self }
    end

    it "iterates through all the lines" do
      acc = []
      ruk(:all) { acc.push(self) }
      acc.should have(3).lines
    end

    it "wraps each line as a Ruk::Line delegate" do
      ruk(1) { self.class.should == Ruk::Line }
    end

    it "tracks the line number for each line" do
      acc = []
      ruk(:all) { acc.push self.lineno }
      acc.should == [1,2,3]
    end
  end

  context "output:" do
    it "writes non-nil result" do
      ruk(:all) { self }
      output.seek(0)
      output.read.should == <<-HERE
line 1
line 2
line 3
HERE
    end

    it "skips printing nil values" do
      ruk(:all) {
        if lineno == 2
          nil
        else
          self
        end
      }
      output.seek(0)
      output.read.should == <<-HERE
line 1
line 3
HERE
    end
  end

  context "before and after:" do
    it "invokes before actions before all the lines" do
      acc = []
      evaluator.begin {
        acc.push 0
      }
      ruk(:all) { acc.push lineno }
      acc.should == [0,1,2,3]
    end

    it "invokes final actions after all the lines" do
      acc = []
      evaluator.final {
        acc.push 0
      }
      ruk(:all) { acc.push lineno }
      acc.should == [1,2,3,0]
    end
  end
end