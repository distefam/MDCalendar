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

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month forYear:(NSInteger)year;
+ (NSDate *)dateFromComponents:(NSDateComponents *)components;
+ (NSString *)monthNameForMonth:(NSInteger)month;
+ (NSArray *)weekdays;                                          // returns all weekdays as strings, starts with Sunday
+ (NSArray *)weekdayAbbreviations;                              // returns all weekday abbreviations as strings, starts with Sun
+ (NSArray *)monthNames;                                        // returns all months as strings, starts with zero and proceeds to January
+ (NSArray *)shortMonthNames;                                   // returns all month abbreviations as strings, starts with zero and proceeds to Jan

- (NSDate *)firstDayOfMonth;
- (NSDate *)lastDayOfMonth;

- (NSInteger)day;
- (NSInteger)weekday;
- (NSInteger)month;
- (NSString *)shortMonthString;
- (NSInteger)year;
- (NSDateComponents *)components;

- (NSInteger)numberOfDaysUntilEndDate:(NSDate *)endDate;
- (NSInteger)numberOfMonthsUntilEndDate:(NSDate *)endDate;
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateByAddingMonths:(NSInteger)months;

- (BOOL)isEqualToDateSansTime:(NSDate *)otherDate;
- (BOOL)isBeforeDate:(NSDate *)otherDate;
- (BOOL)isAfterDate:(NSDate *)otherDate;

@end
