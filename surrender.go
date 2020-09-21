package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"time"
)

type MostRecentVoter struct {
	Dates map[time.Time]int
}

type DailyVoter struct {
	Dates map[time.Time]int
}

type WeeklyVoter struct {
	Dates map[time.Time]int
}

type MonthlyVoter struct {
	Dates map[time.Time]int
}

// Returns true to keep, false to delete
func voteMostRecent(date time.Time, voter *MostRecentVoter) bool {
	voter.Dates[time.Unix(0, 0)] += 1
	return voter.Dates[time.Unix(0, 0)] <= 5
}

// Returns true to keep, false to delete
func voteDaily(date time.Time, voter *DailyVoter) bool {
	voter.Dates[date] += 1
	return voter.Dates[date] <= 1
}

// Returns true to keep, false to delete
func voteWeekly(date time.Time, voter *WeeklyVoter) bool {
	for date.Weekday() != time.Sunday {
		date = date.AddDate(0, 0, -1)
	}

	voter.Dates[date] += 1
	return voter.Dates[date] <= 1
}

// Returns true to keep, false to delete
func voteMonthly(date time.Time, voter *MonthlyVoter) bool {
	date = date.AddDate(0, 0, -1*date.Day()+1)

	voter.Dates[date] += 1
	return voter.Dates[date] <= 1
}

func main() {
	re := regexp.MustCompile("\\b(19|2\\d\\d{2})[-._/]?(0[1-9]|1[012])[-._/]?(0[1-9]|[12][0-9]|3[01])")
	location, _ := time.LoadLocation("Local")

	voter0 := MostRecentVoter{make(map[time.Time]int)}
	voter1 := DailyVoter{make(map[time.Time]int)}
	voter2 := WeeklyVoter{make(map[time.Time]int)}
	voter3 := MonthlyVoter{make(map[time.Time]int)}

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		matches := re.FindStringSubmatch(scanner.Text())
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

		date := time.Date(int(year), month, int(day), 0, 0, 0, 0, location)

		result0 := voteMostRecent(date, &voter0)
		result1 := voteDaily(date, &voter1)
		result2 := voteWeekly(date, &voter2)
		result3 := voteMonthly(date, &voter3)
		fmt.Fprintf(os.Stderr, "%s => recent %t, daily %t, weekly %t, monthly %t\n",
			scanner.Text(),
			result0,
			result1,
			result2,
			result3)
		if result0 || result1 || result2 || result3 {
			// NO OP: keep
		} else {
			fmt.Println(scanner.Text())
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "reading standard input:", err)
	}
}
