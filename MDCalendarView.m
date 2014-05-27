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
    NSString *dayString = MDCalendarDayStringFromDate(_date);

//    if ([_date day] == 1) {
//        dayString = [NSString stringWithFormat:@"%@\n%@", [_date shortMonthString], MDCalendarDayStringFromDate(_date)];
//    }
    
    label.text = dayString;
    [self.contentView addSubview:label];
    
    self.label = label;
}

NSString * MDCalendarDayStringFromDate(NSDate *date) {
    return [NSString stringWithFormat:@"%d", (int)[date day]];
}

@end

@interface MDCalendarHeaderView : UICollectionReusableView
@property (nonatomic, assign) NSInteger month;
@end

@interface MDCalendarHeaderView ()
@property (nonatomic, strong) UILabel *label;
@end

static NSString * const kMDCalendarHeaderViewIdentifier = @"kMDCalendarHeaderViewIdentifier";

@implementation MDCalendarHeaderView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.text = [NSDate monthNameForMonth:_month];
    [self addSubview:label];
    self.label = label;
}

@end

@interface MDCalendarView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

static CGFloat const kMDCalendarViewItemSpacing    = 2.f;
static CGFloat const kMDCalendarViewLineSpacing    = 2.f;
static CGFloat const kMDCalendarViewSectionSpacing = 10.f;

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
        layout.minimumInteritemSpacing  = kMDCalendarViewItemSpacing;
        layout.minimumLineSpacing       = kMDCalendarViewLineSpacing;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[MDCalendarViewCell class] forCellWithReuseIdentifier:kMDCalendarViewCellIdentifier];
        [_collectionView registerClass:[MDCalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMDCalendarHeaderViewIdentifier];
        
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

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _collectionView.contentInset = contentInset;
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
    return [self.startDate numberOfMonthsUntilEndDate:self.endDate];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger month = [self monthForSection:section];
    return [NSDate numberOfDaysInMonth:month];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMDCalendarViewCellIdentifier forIndexPath:indexPath];
    cell.date = [self dateForIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MDCalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMDCalendarHeaderViewIdentifier forIndexPath:indexPath];
    headerView.month = [self monthForSection:indexPath.section];
    return headerView;
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat boundsWidth = collectionView.bounds.size.width;
    CGFloat cellWidth = (boundsWidth / 7) - kMDCalendarViewItemSpacing;
    CGFloat cellHeight = cellWidth;
    return CGSizeMake(cellWidth, cellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat boundsWidth = collectionView.bounds.size.width;
    return CGSizeMake(boundsWidth, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(self.bounds), kMDCalendarViewSectionSpacing);
}

@end
