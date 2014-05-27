//
//  NSDate+MDCalendar.m
//  MDCalendarDemo
//
//  Created by Michael Distefano on 5/23/14.
//  Copyright (c) 2014 Michael Distefano. All rights reserved.
//

#import "NSDate+MDCalendar.h"

#define SECONDS_IN_DAY 86400

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
    return [components month];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    
    NSInteger monthsToAdd = floor(([self day] + days) / [self numberOfDaysInMonth]);
    NSInteger daysToAdd = days % [self numberOfDaysInMonth];
    
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    components.day = [self day] + daysToAdd;
    NSDate *date = MDCalendarDateFromComponents(components);
    
    return [date dateByAddingMonths:monthsToAdd];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSInteger yearsToAdd = floor(([self month] + months) / 12);
    NSInteger monthsToAdd = months % 12;
    
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    components.month = [self month] + monthsToAdd;
    components.year = [self year] + yearsToAdd;
    
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
