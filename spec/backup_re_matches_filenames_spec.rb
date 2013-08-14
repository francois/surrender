require "spec_helper"

describe Surrender, "BACKUP_RE" do
  subject { Surrender::BACKUP_RE }

  it { subject.match("/var/backup/database/base-20130809.sql.gz").inspect.should == "#<MatchData \"20130809\" 1:\"2013\" 2:nil 3:\"08\" 4:\"09\">" }
  it { subject.match("/var/backup/database/base-20130810.sql.gz").inspect.should == "#<MatchData \"20130810\" 1:\"2013\" 2:nil 3:\"08\" 4:\"10\">" }
end
