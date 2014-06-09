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

+ (NSDate *)dateFromComponents:(NSDateComponents *)components {
    return MDCalendarDateFromComponents(components);
}

+ (NSString *)monthNameForMonth:(NSInteger)month {
    return [NSDate monthNames][month];
}

+ (NSArray *)weekdays {
    return @[@"SUN",
             @"MON",
             @"TUE",
             @"WED",
             @"THU",
             @"FRI",
             @"SAT"];
}

+ (NSArray *)monthNames {
    return @[@"Zero",
             @"January",
             @"February",
             @"March",
             @"April",
             @"May",
             @"June",
             @"July",
             @"August",
             @"September",
             @"October",
             @"November",
             @"December"];
}

+ (NSArray *)shortMonthNames {
    return @[@"Zero",
             @"Jan",
             @"Feb",
             @"Mar",
             @"Apr",
             @"May",
             @"Jun",
             @"Jul",
             @"Aug",
             @"Sep",
             @"Oct",
             @"Nov",
             @"Dec"];
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

- (NSInteger)weekday {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components weekday];
}

- (NSInteger)month {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components month];
}

- (NSString *)shortMonthString {
    return [NSDate shortMonthNames][[self month]];
}

- (NSInteger)year {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components year];
}

- (NSDateComponents *)components {
    return MDCalendarDateComponentsFromDate(self);
}

- (NSInteger)numberOfDaysInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *firstDayOfMonth = [self firstDayOfMonth];
    NSDate *lastDayOfMonth  = [self lastDayOfMonth];
    
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:firstDayOfMonth toDate:lastDayOfMonth options:0];
    return [components day];
}

- (NSInteger)numberOfMonthsUntilEndDate:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self toDate:endDate options:0];
    NSInteger month = [components month];

    NSAssert(month >= 0, @"Please enter an end date that is after the specified start date.");

    return [components month];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = days;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSDateComponents *components = [NSDateComponents new];
    components.month = months;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (BOOL)isEqualToDate:(NSDate *)otherDate {
    if (self.day == otherDate.day &&
        self.month == otherDate.month &&
        self.year == otherDate.year) {
        return YES;
    }
    return NO;
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
