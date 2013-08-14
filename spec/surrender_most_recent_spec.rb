require "spec_helper"

describe Surrender, "most_recent" do
  let(:options) { {weekly: 0, monthly: 0, yearly: 0} }

  context "when no input filenames" do
    subject { Surrender.reject([], {}) }

    it { should == [[], []] }
  end

  context "when 1 input filename" do
    subject { Surrender.reject(["/var/backup/database/base-20130810.sql.gz"], options) }
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
      subject { Surrender.reject(filenames, options.merge(most_recent: 1)) }
      it { should == [[], filenames[-2..-2]] }
    end

    context "and most_recent = 2" do
      subject { Surrender.reject(filenames, options.merge(most_recent: 2)) }
      it { should == [[], []] }
    end

    context "and most_recent = 3" do
      subject { Surrender.reject(filenames, options.merge(most_recent: 3)) }
      it { should == [[], []] }
    end
  end

  context "when 6 input filenames" do
    let(:filenames) do
      %w(
        /var/backup/database/base-20130805.sql.gz
        /var/backup/database/base-20130806.sql.gz
        /var/backup/database/base-20130807.sql.gz
        /var/backup/database/base-20130808.sql.gz
        /var/backup/database/base-20130809.sql.gz
        /var/backup/database/base-20130810.sql.gz
      )
    end

    context "and most_recent = 1" do
      subject { Surrender.reject(filenames, options.merge(most_recent: 1)) }
      it { should == [[], filenames.sort - filenames.sort[-1..-1]] }
    end

    context "and most_recent = 2" do
      subject { Surrender.reject(filenames, options.merge(most_recent: 2)) }
      it { should == [[], filenames.sort - filenames.sort[-2..-1]] }
    end

    context "and most_recent = 3" do
      subject { Surrender.reject(filenames, options.merge(most_recent: 3)) }
      it { should == [[], filenames.sort - filenames.sort[-3..-1]] }
    end
  end
end
