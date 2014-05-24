//
//  MDCalendarViewController.m
//  MDCalendarDemo
//
//  Created by Michael Distefano on 5/23/14.
//  Copyright (c) 2014 Michael Distefano. All rights reserved.
//

#import "MDCalendarViewController.h"
#import "MDCalendarView.h"

@interface MDCalendarViewController ()
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
        calendarView.backgroundColor = [UIColor yellowColor];
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

@end
