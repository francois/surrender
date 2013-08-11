require "spec_helper"

describe Surrender, "keeps at minimum N most recent" do
  context "when no input filenames" do
    subject { Surrender.reject([], {}) }

    it { should == [[], []] }
  end

  context "when 1 input filename" do
    subject { Surrender.reject(["/var/backup/database/base-20130810.sql.gz"], {}) }
    it { should == [[], []] }
  end

  context "when 2 input filenames" do
    let(:filenames) do
      %w(
        /var/backup/database/base-20130809.sql.gz
        /var/backup/database/base-20130810.sql.gz
      )
    end

    context "and most_recent = 1" do
      subject { Surrender.reject(filenames, most_recent: 1) }
      it { should == [[], Array(filenames.sort.first)] }
    end

    context "and most_recent = 2" do
      subject { Surrender.reject(["/var/backup/database/base-20130810.sql.gz"], most_recent: 2) }
      it { should == [[], []] }
    end

    context "and most_recent = 3" do
      subject { Surrender.reject(["/var/backup/database/base-20130810.sql.gz"], most_recent: 3) }
      it { should == [[], []] }
    end
  end
end
