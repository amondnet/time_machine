// https://github.com/nodatime/nodatime/blob/master/src/NodaTime.Test/YearMonthDayCalendarTest.cs
// cae7975  on Aug 24, 2017

import 'dart:async';
import 'dart:math' as math;

import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_calendars.dart';
import 'package:time_machine/time_machine_utilities.dart';

import 'package:test/test.dart';
import 'package:matcher/matcher.dart';
import 'package:time_machine/time_machine_timezones.dart';

import 'time_machine_testing.dart';

Future main() async {
  await runTests();
}

@Test()
void AllYears()
{
  // Range of years we actually care about. We support more, but that's okay.
  for (int year = -9999; year <= 9999; year++)
  {
    var ymdc = new YearMonthDayCalendar(year, 5, 20, new CalendarOrdinal(0));
    expect(year, ymdc.year);
    expect(5, ymdc.month);
    expect(20, ymdc.day);
    expect(CalendarOrdinal.Iso, ymdc.calendarOrdinal);
  }
}

@Test()
void AllMonths()
{
  // We'll never actually need 32 months, but we support that many...
  for (int month = 1; month <= 32; month++)
  {
    var ymdc = new YearMonthDayCalendar(-123, month, 20, CalendarOrdinal.HebrewCivil);
    expect(-123, ymdc.year);
    expect(month, ymdc.month);
    expect(20, ymdc.day);
    expect(CalendarOrdinal.HebrewCivil, ymdc.calendarOrdinal);
  }
}

@Test()
void AllDays()
{
  // We'll never actually need 64 days, but we support that many...
  for (int day = 1; day <= 64; day++)
  {
    var ymdc = new YearMonthDayCalendar(-123, 12, day, CalendarOrdinal.IslamicAstronomicalBase15);
    expect(-123, ymdc.year);
    expect(12, ymdc.month);
    expect(day, ymdc.day);
    expect(CalendarOrdinal.IslamicAstronomicalBase15, ymdc.calendarOrdinal);
  }
}

@Test()
void AllCalendars()
{
  for (int ordinal = 0; ordinal < 64; ordinal++)
  {
    CalendarOrdinal calendar = new CalendarOrdinal(ordinal); //(CalendarOrdinal) ordinal;
    var ymdc = new YearMonthDayCalendar(-123, 30, 64, calendar);
    expect(-123, ymdc.year);
    expect(30, ymdc.month);
    expect(64, ymdc.day);
    expect(calendar, ymdc.calendarOrdinal);
  }
}

@Test()
void Equality()
{
  var original = new YearMonthDayCalendar(1000, 12, 20, CalendarOrdinal.Coptic);
  var original2 = new YearMonthDayCalendar(1000, 12, 20, CalendarOrdinal.Coptic);
  TestHelper.TestEqualsStruct(original, new YearMonthDayCalendar(1000, 12, 20, CalendarOrdinal.Coptic),
      [new YearMonthDayCalendar(original.year + 1, original.month, original.day, original.calendarOrdinal),
      new YearMonthDayCalendar(original.year, original.month + 1, original.day, original.calendarOrdinal),
      new YearMonthDayCalendar(original.year, original.month, original.day + 1, original.calendarOrdinal),
      new YearMonthDayCalendar(original.year, original.month, original.day, CalendarOrdinal.Gregorian)]);
  // Just test the first one again with operators.
  TestHelper.TestOperatorEquality(original, original2, new YearMonthDayCalendar(original.year + 1, original.month, original.day, original.calendarOrdinal));
}

@Test()
@TestCase(const ["2017-08-21-Julian", 2017, 8, 21, CalendarOrdinal.Julian])
@TestCase(const ["-0005-08-21-Iso", -5, 8, 21, CalendarOrdinal.Iso])
void Parse(String text, int year, int month, int day, CalendarOrdinal calendar)
{
  var value = YearMonthDayCalendar.Parse(text);
  expect(year, value.year);
  expect(month, value.month);
  expect(day, value.day);
  // expect((CalendarOrdinal) calendar, value.CalendarOrdinal);
  expect(calendar, value.calendarOrdinal);
  expect(text, value.toString());
}
