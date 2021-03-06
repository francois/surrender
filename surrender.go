package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"time"
)

const keep = "keep"
const discard = "discard"

type VoterMemory struct {
	Dates map[time.Time]int
}

func vote(date time.Time, threshold int, voter *VoterMemory) string {
	if voter.Dates[date] > 0 || len(voter.Dates) >= threshold {
		return discard
	} else {
		voter.Dates[date] += 1
		if voter.Dates[date] > 1 {
			panic("There should only be one keep per date")
		}

		return keep
	}
}

func voteMostRecent(date time.Time, voter *VoterMemory) string {
	voter.Dates[time.Unix(0, 0)] += 1
	if voter.Dates[time.Unix(0, 0)] <= keepMostRecent {
		return keep
	} else {
		return discard
	}
}

func voteDaily(date time.Time, voter *VoterMemory) string {
	return vote(date, keepDaily, voter)
}

func voteWeekly(date time.Time, voter *VoterMemory) string {
	for date.Weekday() != time.Sunday {
		date = date.AddDate(0, 0, -1)
	}

	return vote(date, keepWeekly, voter)
}

func voteMonthly(date time.Time, voter *VoterMemory) string {
	date = date.AddDate(0, 0, -1*date.Day()+1)
	return vote(date, keepMonthly, voter)
}

func voteYearly(date time.Time, voter *VoterMemory) string {
	date = date.AddDate(0, 0, -1*date.YearDay()+1)
	return vote(date, keepYearly, voter)
}

func teaseDateFromString(text string) time.Time {
	if re == nil {
		re = regexp.MustCompile("\\b((?:19|[2-9]\\d)\\d{2})[-_./]?(0[1-9]|1[012])[-_./]?(0[1-9]|[12][0-9]|3[01])")
	}

	if location == nil {
		location, _ = time.LoadLocation("Local")
	}

	matches := re.FindStringSubmatch(text)
	if matches == nil {
		return time.Unix(0, 0)
	}

	year, _ := strconv.ParseInt(matches[1], 10, 32)
	monthnum, _ := strconv.ParseInt(matches[2], 10, 32)
	day, _ := strconv.ParseInt(matches[3], 10, 32)

	var month time.Month
	switch monthnum {
	case 1:
		month = time.January
	case 2:
		month = time.February
	case 3:
		month = time.March
	case 4:
		month = time.April
	case 5:
		month = time.May
	case 6:
		month = time.June
	case 7:
		month = time.July
	case 8:
		month = time.August
	case 9:
		month = time.September
	case 10:
		month = time.October
	case 11:
		month = time.November
	case 12:
		month = time.December
	}

	return time.Date(int(year), month, int(day), 0, 0, 0, 0, location)
}

// Command-line options
var verbose bool
var keepMostRecent int
var keepDaily int
var keepWeekly int
var keepMonthly int
var keepYearly int

var re *regexp.Regexp
var location *time.Location

func main() {
	help := flag.Bool("help", false, "Show this help message")
	flag.BoolVar(&verbose, "verbose", false, "Returns, on STDERR, the decision tree for each input line")
	flag.IntVar(&keepMostRecent, "most-recent", 7, "keeps a minimum of N most recent files")
	flag.IntVar(&keepDaily, "daily", 7, "keeps the most recent N daily backups")
	flag.IntVar(&keepWeekly, "weekly", 4, "keeps the most recent N weekly backups, where a week starts on Sunday")
	flag.IntVar(&keepMonthly, "monthly", 12, "keeps the most recent N monthly backups")
	flag.IntVar(&keepYearly, "yearly", 2, "keeps the most recent N yearly backups")
	flag.Parse()

	if *help {
		flag.PrintDefaults()
		os.Exit(1)
	}

	voter0 := VoterMemory{make(map[time.Time]int)}
	voter1 := VoterMemory{make(map[time.Time]int)}
	voter2 := VoterMemory{make(map[time.Time]int)}
	voter3 := VoterMemory{make(map[time.Time]int)}
	voter4 := VoterMemory{make(map[time.Time]int)}

	lastSeenDate := time.Now().AddDate(999, 0, 0)
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		date := teaseDateFromString(scanner.Text())
		if date == time.Unix(0, 0) {
			fmt.Fprintf(os.Stderr, "\"%s\": failed to discover YYYY-MM-DD within the filename\n", scanner.Text())
			continue
		}

		if date.After(lastSeenDate) {
			fmt.Fprintf(os.Stderr, "last = %v, date = %v\n", lastSeenDate, date)
			panic("Input must be reverse sorted list of dates; found an earlier date")
		} else {
			lastSeenDate = date
		}

		result0 := voteMostRecent(date, &voter0)
		result1 := voteDaily(date, &voter1)
		result2 := voteWeekly(date, &voter2)
		result3 := voteMonthly(date, &voter3)
		result4 := voteYearly(date, &voter4)
		if verbose {
			fmt.Fprintf(os.Stderr, "%s\t=>\trecent %s\tdaily %s\tweekly %s\tmonthly %s\tyearly %s\n",
				scanner.Text(),
				result0,
				result1,
				result2,
				result3,
				result4,
			)
		}

		if result0 == discard && result1 == discard && result2 == discard && result3 == discard && result4 == discard {
			fmt.Println(scanner.Text())
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "reading standard input:", err)
	}
}
