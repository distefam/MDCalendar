//
//  NSDate+MDCalendar.m
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

#import "NSDate+MDCalendar.h"

@implementation NSDate (MDCalendar)

+ (NSInteger)MD_numberOfDaysInMonth:(NSInteger)month forYear:(NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [NSDateComponents new];
    [components setMonth:month];
    [components setYear:year];
    NSDate *date = [calendar dateFromComponents:components];
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return range.length;
}

+ (NSDate *)MD_dateFromComponents:(NSDateComponents *)components {
    return MDCalendarDateFromComponents(components);
}

+ (NSString *)MD_monthNameForMonth:(NSInteger)month {
    return [NSDate MD_monthNames][month];
}

+ (NSArray *)MD_weekdays {
    return @[@"Sunday",
             @"Monday",
             @"Tuesday",
             @"Wednesday",
             @"Thursday",
             @"Friday",
             @"Saturday"];
}

+ (NSArray *)MD_weekdayAbbreviations {
    return @[@"SUN",
             @"MON",
             @"TUE",
             @"WED",
             @"THU",
             @"FRI",
             @"SAT"];
}

+ (NSString *)MD_ordinalStringForDay:(NSInteger)day {
    NSString *suffix;
    int ones = day % 10;
    int tens = (int) floor(day / 10.0) % 10;
    
    if (tens == 1) {
        suffix = @"th";
    } else if (ones == 1) {
        suffix = @"st";
    } else if (ones == 2) {
        suffix = @"nd";
    } else if (ones == 3) {
        suffix = @"rd";
    } else {
        suffix = @"th";
    }
    return [NSString stringWithFormat:@"%li%@", (long)day, suffix];
}

+ (NSArray *)MD_monthNames {
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

+ (NSArray *)MD_shortMonthNames {
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

- (NSDate *)MD_firstDayOfMonth {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    [components setDay:1];
    return MDCalendarDateFromComponents(components);
}

- (NSDate *)MD_lastDayOfMonth {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    
    NSInteger month = [components month];
    [components setMonth:month+1];
    [components setDay:0];
    
    return MDCalendarDateFromComponents(components);
}

- (NSInteger)MD_day {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components day];
}

- (NSString *)MD_weekdayString {
    return [NSDate MD_weekdays][self.MD_weekday - 1];
}

- (NSInteger)MD_weekday {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components weekday];
}

- (NSInteger)MD_month {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components month];
}

- (NSString *)MD_shortMonthString {
    return [NSDate MD_shortMonthNames][[self MD_month]];
}

- (NSString *)MD_monthString {
    return [NSDate MD_monthNameForMonth:self.MD_month];
}

- (NSInteger)MD_year {
    NSDateComponents *components = MDCalendarDateComponentsFromDate(self);
    return [components year];
}

- (NSDateComponents *)MD_components {
    return MDCalendarDateComponentsFromDate(self);
}

- (NSInteger)numberOfDaysInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *firstDayOfMonth = [self MD_firstDayOfMonth];
    NSDate *lastDayOfMonth  = [self MD_lastDayOfMonth];
    
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:firstDayOfMonth toDate:lastDayOfMonth options:0];
    return [components day];
}

- (NSInteger)MD_numberOfMonthsUntilEndDate:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self toDate:endDate options:0];

    return [components month];
}

- (NSInteger)MD_numberOfDaysUntilEndDate:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self toDate:endDate options:0];
    return [components day];
}

- (NSDate *)MD_dateByAddingDays:(NSInteger)days {
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = days;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)MD_dateByAddingMonths:(NSInteger)months {
    NSDateComponents *components = [NSDateComponents new];
    components.month = months;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (BOOL)MD_isEqualToDateSansTime:(NSDate *)otherDate {
    if (self.MD_day == otherDate.MD_day &&
        self.MD_month == otherDate.MD_month &&
        self.MD_year == otherDate.MD_year) {
        return YES;
    }
    return NO;
}

- (BOOL)MD_isBeforeDate:(NSDate *)otherDate {
    return [self compare:otherDate] == NSOrderedAscending;
}

- (BOOL)MD_isAfterDate:(NSDate *)otherDate {
    return [self compare:otherDate] == NSOrderedDescending;
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
