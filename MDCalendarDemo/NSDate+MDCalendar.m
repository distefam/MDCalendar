//
//  NSDate+MDCalendar.m
//  MDCalendarDemo
//
//  Created by Michael Distefano on 5/23/14.
//  Copyright (c) 2014 Michael Distefano. All rights reserved.
//

#import "NSDate+MDCalendar.h"

@implementation NSDate (MDCalendar)

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [NSDateComponents new];
    [components setMonth:month];
    NSDate *monthDate = [calendar dateFromComponents:components];
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:monthDate];
    return range.length;
}

- (NSDate *)firstDayOfMonth {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    [components setDay:1];
    return MDCalendarDateFromComponents(components);
}

- (NSDate *)lastDayOfMonth {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    
    NSInteger month = [components month];
    [components setMonth:month+1];
    [components setDay:0];
    
    return MDCalendarDateFromComponents(components);
}

- (NSInteger)day {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components day];
}

- (NSInteger)month {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components month];
}

- (NSInteger)year {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components year];
}

- (NSInteger)numberOfDaysInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *firstDayOfMonth = [self firstDayOfMonth];
    NSDate *lastDayOfMonth  = [self lastDayOfMonth];
    
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:firstDayOfMonth toDate:lastDayOfMonth options:0];
    return [components day];
}

- (NSInteger)numberOfMonthsUntilEndDate:(NSDate *)endDate {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    NSInteger startMonth = [components month];
    
    components = MDCalendarDateComponentsFromDate(endDate);
    NSInteger endMonth = [components month];
    
    if (endMonth == startMonth) {
        return 1;   // always at least one month
    }
    
    return endMonth - startMonth;
}

- (NSDate *)dateFromAddingDays:(NSInteger)days {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    NSInteger currentDay = [components day];
    [components setDay:currentDay + days];
    return MDCalendarDateFromComponents(components);
}

#pragma mark - Helpers
                  
NSDateComponents * MDCalendarDateComponentsFromDate(NSDate *date) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSYearCalendarUnit|NSCalendarUnitMonth|NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:date];
}

NSDate * MDCalendarDateFromComponents(NSDateComponents *components) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateFromComponents:components];
}

@end
