require "spec_helper"
require "surrender/monthly_policy"

describe Surrender::MonthlyPolicy do
  context "when count = 3" do
    subject { Surrender::MonthlyPolicy.new(3) }

    it "keeps the latest backup of the last three months" do
      subject.add "a", Date.new(2013, 3, 1)
      subject.add "b", Date.new(2013, 3, 15)

      subject.add "c", Date.new(2013, 4, 1)
      subject.add "d", Date.new(2013, 4, 15)

      subject.add "e", Date.new(2013, 5, 1)
      subject.add "f", Date.new(2013, 5, 15)

      subject.add "g", Date.new(2013, 6, 1)
      subject.add "h", Date.new(2013, 6, 15)

      subject.deleteable?("a").should == true
      subject.deleteable?("b").should == true
      subject.deleteable?("c").should == true
      subject.deleteable?("d").should == false
      subject.deleteable?("e").should == true
      subject.deleteable?("f").should == false
      subject.deleteable?("g").should == true
      subject.deleteable?("h").should == false
    end
  end
end
