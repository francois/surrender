require "spec_helper"
require "surrender/weekly_policy"

describe Surrender::WeeklyPolicy do
  context "when count = 1" do
    subject { Surrender::WeeklyPolicy.new(1) }

    it { subject.name.should == "weekly" }

    it "keeps the last filename per week" do
      subject.add "a", Date.new(2013, 8, 4)
      subject.deleteable?("a").should == false

      subject.add "b", Date.new(2013, 8, 5)
      subject.deleteable?("a").should == true
      subject.deleteable?("b").should == false

      subject.add "c", Date.new(2013, 8, 6)
      subject.deleteable?("a").should == true
      subject.deleteable?("b").should == true
      subject.deleteable?("c").should == false

      subject.add "d", Date.new(2013, 8, 10)
      subject.deleteable?("a").should == true
      subject.deleteable?("b").should == true
      subject.deleteable?("c").should == true
      subject.deleteable?("d").should == false

      subject.add "e", Date.new(2013, 8, 11)
      subject.deleteable?("a").should == true
      subject.deleteable?("b").should == true
      subject.deleteable?("c").should == true
      subject.deleteable?("d").should == true
      subject.deleteable?("e").should == false
    end
  end

  context "when count = 2" do
    subject { Surrender::WeeklyPolicy.new(2) }

    it "keeps the last filename per week" do
      subject.add "a", Date.new(2013, 8, 4)
      subject.deleteable?("a").should == false

      subject.add "b", Date.new(2013, 8, 5)
      subject.deleteable?("a").should == true
      subject.deleteable?("b").should == false

      subject.add "c", Date.new(2013, 8, 6)
      subject.deleteable?("a").should == true
      subject.deleteable?("b").should == true
      subject.deleteable?("c").should == false

      subject.add "d", Date.new(2013, 8, 10)
      subject.deleteable?("a").should == true
      subject.deleteable?("b").should == true
      subject.deleteable?("c").should == true
      subject.deleteable?("d").should == false

      subject.add "e", Date.new(2013, 8, 11)
      subject.deleteable?("a").should == true
      subject.deleteable?("b").should == true
      subject.deleteable?("c").should == true
      subject.deleteable?("d").should == false
      subject.deleteable?("e").should == false
    end
  end
end
