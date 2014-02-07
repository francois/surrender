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

    $ find /var/backup/database -type f | sort | surrender --most-recent=7 --weekly=5 --monthly=12 --yearly=2 | xargs rm --verbose

Would keep the most recent 7 files, irrespective of their dates, the 5 most recent
weekly backups, the 12 most recent monthly backups, and the 2 most recent yearly
backups. Backup dates are determined from the file's path, which must match the
following regular expression:

    /\b((?:19|2\d)\d{2})(.)?(0\d|1[012])\2?([012]\d|3[01])(?:T|\b)/

This regular expression matches schemes like this:

* /var/backup/database/contacts-20130811T130914.sql.gz
* /var/backup/database/contacts-2013-08-11.13-09-14.sql.gz
* /var/backup/database/contacts/2013/08/11.sql.gz

which seems to be common enough.

Anything that does not match the regular expression is reported as a warning on STDERR, and filtered from
STDOUT, implying the file must be kept.

Incidentally, all parameters to surrender are optional. The default values are the ones expressed above.
surrender uses a constant amount of memory, related to the total number of files in the input stream.

## Viewing the inner workings

If you pass the `--verbose` option, Surrender will tell you how it arrived at it's decision:

    $ for DATE in 2013-12-{10..20} ; do echo "backup.${DATE}.tar.gz" ; done | RUBYOPT=-Ilib bin/surrender --verbose
    "backup.2013-12-10.tar.gz": most recent=delete, weekly=delete, monthly=delete, yearly=delete
    "backup.2013-12-11.tar.gz": most recent=delete, weekly=delete, monthly=delete, yearly=delete
    "backup.2013-12-12.tar.gz": most recent=delete, weekly=delete, monthly=delete, yearly=delete
    "backup.2013-12-13.tar.gz": most recent=delete, weekly=delete, monthly=delete, yearly=delete
    "backup.2013-12-14.tar.gz": most recent=keep, weekly=keep, monthly=delete, yearly=delete
    "backup.2013-12-15.tar.gz": most recent=keep, weekly=delete, monthly=delete, yearly=delete
    "backup.2013-12-16.tar.gz": most recent=keep, weekly=delete, monthly=delete, yearly=delete
    "backup.2013-12-17.tar.gz": most recent=keep, weekly=delete, monthly=delete, yearly=delete
    "backup.2013-12-18.tar.gz": most recent=keep, weekly=delete, monthly=delete, yearly=delete
    "backup.2013-12-19.tar.gz": most recent=keep, weekly=delete, monthly=delete, yearly=delete
    "backup.2013-12-20.tar.gz": most recent=keep, weekly=keep, monthly=keep, yearly=keep
    backup.2013-12-10.tar.gz
    backup.2013-12-11.tar.gz
    backup.2013-12-12.tar.gz
    backup.2013-12-13.tar.gz

In this example, you can see that the `backup.2013-12-10.tar.gz` file was voted to be deleted by all
policies, while `backup.2013-12-14.tar.gz` was voted to be kept by the most recent and weekly policies.

The `--verbose` flag outputs to STDERR, keeping STDOUT clean.

## Common pipelines

### Clean up your Amazon S3 bucket

    $ s3cmd ls s3://mybucket | awk '{ print $NF }' | surrender | xargs s3cmd del

First, we list the contents of `mybucket`. After that, we extract just our file's name from the list.
Next we surrender any names which should be deleted, and pass each line to `s3cmd del`, which results
in a certain number of files being deleted. `s3cmd` will be called once per line of the input. In the
normal case, you should not be deleting many files at once, and there should not be any performance
problems.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
