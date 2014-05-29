//
//  NSDate+MDCalendar.h
//  MDCalendarDemo
//
//  Created by Michael Distefano on 5/23/14.
//  Copyright (c) 2014 Michael Distefano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MDCalendar)

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month;
+ (NSDate *)dateFromComponents:(NSDateComponents *)components;
+ (NSString *)monthNameForMonth:(NSInteger)month;

- (NSDate *)firstDayOfMonth;
- (NSDate *)lastDayOfMonth;

- (NSInteger)day;
- (NSInteger)weekday;
- (NSInteger)month;
- (NSString *)shortMonthString;
- (NSInteger)year;
- (NSDateComponents *)components;

- (NSInteger)numberOfMonthsUntilEndDate:(NSDate *)endDate;
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateByAddingMonths:(NSInteger)months;

- (BOOL)isEqualToDate:(NSDate *)otherDate;

@end
