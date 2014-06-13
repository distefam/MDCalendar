//
//  MDCalendarViewController.m
//  MDCalendarDemo
//
//  Created by Michael Distefano on 5/23/14.
//  Copyright (c) 2014 Michael Distefano. All rights reserved.
//

#import "MDCalendarViewController.h"
#import "MDCalendar.h"
#import "NSDate+MDCalendar.h"

@interface MDCalendarViewController () <MDCalendarDelegate>
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) NSDate *firstDayOfStartMonth;
@property (nonatomic, strong) MDCalendar *calendarView;
@end

@implementation MDCalendarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        MDCalendar *calendarView = [[MDCalendar alloc] init];
        
        calendarView.backgroundColor = [UIColor whiteColor];
        
        calendarView.lineSpacing = 0.f;
        calendarView.itemSpacing = 0.0f;
        calendarView.borderColor = [UIColor darkGrayColor];
        calendarView.borderHeight = 1.f;
        
        calendarView.textColor = [UIColor blackColor];
        calendarView.headerTextColor = [UIColor blueColor];
        calendarView.weekdayTextColor = [UIColor redColor];
        calendarView.cellBackgroundColor = [UIColor whiteColor];
        
        calendarView.highlightColor = [UIColor lightGrayColor];
        
        NSDate *startDate = [[NSDate date] dateByAddingDays:4];
        NSDate *endDate = [startDate dateByAddingMonths:6];
        
        calendarView.startDate = startDate;
        calendarView.endDate = endDate;
        calendarView.delegate = self;
        
        [self.view addSubview:calendarView];
        self.calendarView = calendarView;
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _calendarView.frame = self.view.bounds;
    _calendarView.contentInset = UIEdgeInsetsMake([self.topLayoutGuide length], 0, [self.bottomLayoutGuide length], 0);
}

#pragma mark - MDCalendarViewDelegate

- (void)calendarView:(MDCalendar *)calendarView didSelectDate:(NSDate *)date {
    NSLog(@"Selected Date: %@", date);
}

@end
