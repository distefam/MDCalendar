//
//  MDCalendarView.m
//  
//
//  Created by Michael Distefano on 5/23/14.
//
//

#import "MDCalendarView.h"
#import "NSDate+MDCalendar.h"

@interface MDCalendarViewCell : UICollectionViewCell
@property (nonatomic, strong) NSDate *date;
@end

@interface MDCalendarViewCell  ()
@property (nonatomic, strong) UILabel *label;
@end

static NSString * const kMDCalendarViewCellIdentifier = @"kMDCalendarViewCellIdentifier";

@implementation MDCalendarViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.text = MDCalendarDayStringFromDate(_date);
    [self.contentView addSubview:label];
    
    self.label = label;
}

NSString * MDCalendarDayStringFromDate(NSDate *date) {
    return [NSString stringWithFormat:@"%d", (int)[date day]];
}

@end

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
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[MDCalendarViewCell class] forCellWithReuseIdentifier:kMDCalendarViewCellIdentifier];
        
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

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath {
    NSDate *firstDayOfMonth = [self.startDate firstDayOfMonth];
    return [firstDayOfMonth dateByAddingDays:indexPath.item];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"Number of sections in collection view: %d", (int)[self.startDate numberOfMonthsUntilEndDate:self.endDate]);
    return [self.startDate numberOfMonthsUntilEndDate:self.endDate];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger month = [self monthForSection:section];
    NSLog(@"Number of items in month %d: %d", (int)month, (int)[NSDate numberOfDaysInMonth:month]);
    return [NSDate numberOfDaysInMonth:month];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMDCalendarViewCellIdentifier forIndexPath:indexPath];
    cell.date = [self dateForIndexPath:indexPath];
    return cell;
}

@end
