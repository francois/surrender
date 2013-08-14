require "spec_helper"

describe Surrender, "weekly" do
  context "when 2 files present, weekly=1" do
    let(:filenames) do
      %w(
        /var/backup/database/base-20130809.sql.gz
        /var/backup/database/base-20130810.sql.gz
      )
    end

    subject { Surrender.reject(filenames, most_recent: 0, weekly: 1) }

    it { should == [[], filenames.sort[-2..-2]] }
  end

  context "when 3 files present over 2 weeks, weekly=2" do
    let(:filenames) do
      %w(
        /var/backup/database/base-20130801.sql.gz
        /var/backup/database/base-20130809.sql.gz
        /var/backup/database/base-20130810.sql.gz
      )
    end

    subject { Surrender.reject(filenames, most_recent: 0, weekly: 2) }

    it { should == [[], filenames[-2..-2]] }
  end
end
