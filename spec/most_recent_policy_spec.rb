require "spec_helper"
require "surrender/most_recent_policy"

describe Surrender::MostRecentPolicy do
  context "when count = 1" do
    subject { Surrender::MostRecentPolicy.new(1) }

    it { subject.name.should == "most recent" }

    it "keeps the last entry only" do
      filename1 = "/var/backups/20130801.sql.gz"
      subject.add filename1, Date.new(2013, 8, 1)
      subject.deleteable?(filename1).should == false

      filename2 = "/var/backups/20130802.sql.gz"
      subject.add filename2, Date.new(2013, 8, 2)
      subject.deleteable?(filename1).should == true # previous file is deleteable
      subject.deleteable?(filename2).should == false
    end

    it "preserves memory by only keeping N files in memory" do
      subject.add "/var/backups/20130801.sql.gz", Date.new(2013, 8, 1)
      subject.keys.size.should == 1

      subject.add "/var/backups/20130802.sql.gz", Date.new(2013, 8, 2)
      subject.keys.size.should == 1

      subject.add "/var/backups/20130803.sql.gz", Date.new(2013, 8, 3)
      subject.keys.size.should == 1
    end
  end

  context "when count = 2" do
    subject { Surrender::MostRecentPolicy.new(2) }

    it "keeps the last entry only" do
      filename1 = "/var/backups/20130801.sql.gz"
      subject.add filename1, Date.new(2013, 8, 1)
      subject.deleteable?(filename1).should == false

      filename2 = "/var/backups/20130802.sql.gz"
      subject.add filename2, Date.new(2013, 8, 2)
      subject.deleteable?(filename1).should == false
      subject.deleteable?(filename2).should == false

      filename3 = "/var/backups/20130803.sql.gz"
      subject.add filename3, Date.new(2013, 8, 3)
      subject.deleteable?(filename1).should == true
      subject.deleteable?(filename2).should == false
      subject.deleteable?(filename3).should == false
    end

    it "preserves memory by only keeping N files in memory" do
      subject.add "/var/backups/20130801.sql.gz", Date.new(2013, 8, 1)
      subject.keys.size.should == 1

      subject.add "/var/backups/20130802.sql.gz", Date.new(2013, 8, 2)
      subject.keys.size.should == 2

      subject.add "/var/backups/20130803.sql.gz", Date.new(2013, 8, 3)
      subject.keys.size.should == 2
    end
  end
end
