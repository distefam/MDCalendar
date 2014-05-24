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
+ (NSString *)monthNameForMonth:(NSInteger)month;

- (NSDate *)firstDayOfMonth;
- (NSDate *)lastDayOfMonth;

- (NSInteger)day;
- (NSInteger)month;
- (NSString *)shortMonthString;
- (NSInteger)year;

- (NSInteger)numberOfMonthsUntilEndDate:(NSDate *)endDate;
- (NSDate *)dateByAddingDays:(NSInteger)days;

@end
