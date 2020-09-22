package main

import (
	"regexp"
	"testing"
	"time"
)

func TestRegexpUnderstanding(t *testing.T) {
	re := regexp.MustCompile("\\b((?:19|[2-9]\\d)\\d{2})[-_./]?(0[1-9]|1[012])[-_./]?(0[1-9]|[12][0-9]|3[01])")
	tables := []struct {
		have []string
		want []string
	}{
		{
			re.FindStringSubmatch("/Users/a/backups/19990811T081231.tar.gz"),
			[]string{"19990811", "1999", "08", "11"},
		},
		{
			re.FindStringSubmatch("a/1999.08.11.txt"),
			[]string{"1999.08.11", "1999", "08", "11"},
		},
		{
			re.FindStringSubmatch("a/2000/09/10.txt"),
			[]string{"2000/09/10", "2000", "09", "10"},
		},
		{
			re.FindStringSubmatch("a/2000-09-10.txt"),
			[]string{"2000-09-10", "2000", "09", "10"},
		},
	}

	for _, table := range tables {
		if len(table.have) == len(table.want) {
			for i := range table.have {
				if table.have[i] != table.want[i] {
					t.Errorf("%s => %s failed", table.have, table.want)
				}
			}
		} else {
			t.Errorf("%s => %s failed: bad number of matches", table.have, table.want)
		}
	}
}

func TestDateParsing(t *testing.T) {
	location, _ := time.LoadLocation("Local")

	tables := []struct {
		have string
		want time.Time
	}{
		{
			"/Users/francois/Some/Path/20200814T071248.tar.gz",
			time.Date(2020, time.August, 14, 0, 0, 0, 0, location),
		},
		{
			"/Users/francois/Some/Path/2020.08.14T071248.tar.gz",
			time.Date(2020, time.August, 14, 0, 0, 0, 0, location),
		},
		{
			"/var/backups/2009-12-31.txt",
			time.Date(2009, time.December, 31, 0, 0, 0, 0, location),
		},
		{
			"a/b/c/2000-01-01.txt",
			time.Date(2000, time.January, 1, 0, 0, 0, 0, location),
		},
	}

	for _, table := range tables {
		date := teaseDateFromString(table.have)
		if date != table.want {
			t.Errorf("Expected \"%s\" to parse as %s, got %s", table.have, table.want, date)
		}
	}
}
