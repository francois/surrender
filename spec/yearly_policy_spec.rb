require "spec_helper"
require "surrender/yearly_policy"

describe Surrender::YearlyPolicy do
  context "when count = 2" do
    subject { Surrender::YearlyPolicy.new(2) }

    it { subject.name.should == "yearly" }

    it "keeps the most recent filename of the last two years" do
      subject.add "a", Date.new(2011,  8, 9)
      subject.add "b", Date.new(2011,  9, 9)
      subject.add "c", Date.new(2011, 10, 9)

      subject.add "d", Date.new(2012,  8, 9)
      subject.add "e", Date.new(2012,  9, 9)
      subject.add "f", Date.new(2012, 10, 9)

      subject.add "g", Date.new(2013,  8, 9)
      subject.add "h", Date.new(2013,  9, 9)
      subject.add "i", Date.new(2013, 10, 9)

      subject.deleteable?("a").should == true
      subject.deleteable?("b").should == true
      subject.deleteable?("c").should == true

      subject.deleteable?("d").should == true
      subject.deleteable?("e").should == true
      subject.deleteable?("f").should == false

      subject.deleteable?("g").should == true
      subject.deleteable?("h").should == true
      subject.deleteable?("i").should == false
    end
  end
end
