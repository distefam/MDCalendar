//
//  NSDate+MDCalendar.h
//  MDCalendarDemo
//
//  Created by Michael Distefano on 5/23/14.
//  Copyright (c) 2014 Michael DiStefano
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <Foundation/Foundation.h>

@interface NSDate (MDCalendar)

+ (NSInteger)MD_numberOfDaysInMonth:(NSInteger)month forYear:(NSInteger)year;
+ (NSDate *)MD_dateFromComponents:(NSDateComponents *)components;
+ (NSString *)MD_monthNameForMonth:(NSInteger)month;
+ (NSArray *)MD_weekdays;                                          // returns all weekdays as strings, starts with Sunday
+ (NSArray *)MD_weekdayAbbreviations;                              // returns all weekday abbreviations as strings, starts with Sun
+ (NSArray *)MD_monthNames;                                        // returns all months as strings, starts with zero and proceeds to January
+ (NSArray *)MD_shortMonthNames;                                   // returns all month abbreviations as strings, starts with zero and proceeds to Jan

- (NSDate *)MD_firstDayOfMonth;
- (NSDate *)MD_lastDayOfMonth;

- (NSInteger)MD_day;
- (NSInteger)MD_weekday;
- (NSInteger)MD_month;
- (NSString *)MD_shortMonthString;
- (NSInteger)MD_year;
- (NSDateComponents *)MD_components;

- (NSInteger)MD_numberOfDaysUntilEndDate:(NSDate *)endDate;
- (NSInteger)MD_numberOfMonthsUntilEndDate:(NSDate *)endDate;
- (NSDate *)MD_dateByAddingDays:(NSInteger)days;
- (NSDate *)MD_dateByAddingMonths:(NSInteger)months;

- (BOOL)MD_isEqualToDateSansTime:(NSDate *)otherDate;
- (BOOL)MD_isBeforeDate:(NSDate *)otherDate;
- (BOOL)MD_isAfterDate:(NSDate *)otherDate;

@end
