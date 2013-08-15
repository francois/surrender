# Surrender

[![Build Status](https://travis-ci.org/francois/surrender.png?branch=master)](https://travis-ci.org/francois/surrender)

Returns the list of files which should be surrendered to the ether.

## Installation

Add this line to your application's Gemfile:

    gem 'surrender'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install surrender

## Usage

Acts as a filter, returning files which should be removed from a backup scheme:

    $ find /var/backup/database -type f | sort | surrender --minimum-files=7 --most-recent=2 --weekly=2 --monthly=12 --yearly=2 | xargs rm

Would keep at a minimum 4 files, but only 2 weekly (the 2 most recent weekly backups),
the 12 most recent monthly backups and the 2 most recent yearly backups. Backup dates
are determined from the file's path, which must match the following regular
expression: `/\b(?:19|2\d)\d{2}(.)?(?:0\d|1[012])\1(?:[012]\d|3[01])(?:T|\b)`.

This regular expression matches schemes like this:

* /var/backup/database/contacts-20130811T130914.sql.gz
* /var/backup/database/contacts-2013-08-11.13-09-14.sql.gz
* /var/backup/database/contacts/2013/08/11.sql.gz

which seems to be common enough.

No attempt is made to validate the date: 2013-02-31 is a perfectly valid date for surrender.

Anything that does not match the regular expression is reported as a warning on STDERR, and filtered from
STDOUT, implying the file must be kept.

Incidentally, all parameters to surrender are optional. The default values are the ones expressed above.
surrender uses a constant amount of memory, related to the total number of files in the input stream.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
