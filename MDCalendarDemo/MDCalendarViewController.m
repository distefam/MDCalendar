//
//  MDCalendarViewController.m
//  MDCalendarDemo
//
//  Created by Michael Distefano on 5/23/14.
//  Copyright (c) 2014 Michael Distefano. All rights reserved.
//

#import "MDCalendarViewController.h"
#import "MDCalendarView.h"
#import "NSDate+MDCalendar.h"

@interface MDCalendarViewController () <MDCalendarViewDelegate>
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) NSDate *firstDayOfStartMonth;
@property (nonatomic, strong) MDCalendarView *calendarView;
@end

@implementation MDCalendarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        MDCalendarView *calendarView = [[MDCalendarView alloc] init];
        calendarView.backgroundColor = [UIColor lightGrayColor];
        
        NSDate *startDate = [NSDate date];
        startDate = [startDate dateByAddingDays:-90];
        NSDate *endDate = [startDate dateByAddingDays:90];
        
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

- (void)calendarView:(MDCalendarView *)calendarView didSelectDate:(NSDate *)date {
    NSLog(@"Selected Date: %@", date);
}

@end
