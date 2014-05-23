//
//  MDCalendarView.m
//  
//
//  Created by Michael Distefano on 5/23/14.
//
//

#import "MDCalendarView.h"
#import "NSDate+MDCalendar.h"

@interface MDCalendarView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MDCalendarView

- (instancetype)init {
    return [self initWithStartDate:self.startDate endDate:self.endDate];
}

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    self = [super init];
    if (self) {
        self.startDate = startDate;
        self.endDate = endDate;
        
        // TODO: make a custom layout
        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}


#pragma mark - Custom Accessors

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _collectionView.backgroundColor = backgroundColor;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[NSCalendar currentCalendar] copy];
    }
    return _calendar;
}

- (NSDate *)currentDate {
    if (!_currentDate) {
        _currentDate = [NSDate date];
    }
    return _currentDate;
}

- (NSDate *)startDate {
    if (!_startDate) {
        _startDate = self.currentDate;
    }
    return _startDate;
}

- (NSDate *)endDate {
    if (!_endDate) {
        _endDate = [self.startDate lastDayOfMonth];
    }
    return _endDate;
}

#pragma mark - Private Methods & Helper Functions

- (NSInteger)monthForSection:(NSInteger)section {
    return [self.startDate month] + section;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.startDate numberOfMonthsUntilEndDate:self.endDate];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger month = [self monthForSection:section];
    return [NSDate numberOfDaysInMonth:month];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
