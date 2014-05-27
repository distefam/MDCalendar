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
@property (nonatomic, assign) NSDate *date;
@end

@interface MDCalendarViewCell  ()
@property (nonatomic, strong) UILabel *label;
@end

static NSString * const kMDCalendarViewCellIdentifier = @"kMDCalendarViewCellIdentifier";

@implementation MDCalendarViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        
//    if ([_date day] == 1) {
//        dayString = [NSString stringWithFormat:@"%@\n%@", [_date shortMonthString], MDCalendarDayStringFromDate(_date)];
//    }
        
        [self.contentView addSubview:label];
        
        self.label = label;
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    self.label.text = MDCalendarDayStringFromDate(date);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
}

- (void)setMonth:(NSInteger)month {
    self.label.text = [NSDate monthNameForMonth:month];
}

@end

@interface MDCalendarView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

static CGFloat const kMDCalendarViewItemSpacing    = 2.f;
static CGFloat const kMDCalendarViewLineSpacing    = 2.f;
static CGFloat const kMDCalendarViewSectionSpacing = 10.f;

static NSInteger const kMDCalendarViewNumberOfItems = 35;

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

- (NSDate *)dateForFirstDayOfMonth:(NSInteger)month {
    NSDateComponents *components = [[self.startDate firstDayOfMonth] components];
    components.month = month;
    components.day = 1;
    return [NSDate dateFromComponents:components];
}

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath {
    NSDateComponents *components = [[self.startDate firstDayOfMonth] components];
    components.month = [self monthForSection:indexPath.section];
    components.day = indexPath.item + 1;
    NSDate *date = [NSDate dateFromComponents:components];
    
    // Calculate the offset
    NSDate *firstDayOfMonth = [self dateForFirstDayOfMonth:[self monthForSection:indexPath.section]];
    NSInteger offset = [firstDayOfMonth weekday] - 1;
    date = [date dateByAddingDays:-offset];
    
    return date;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.startDate numberOfMonthsUntilEndDate:self.endDate];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kMDCalendarViewNumberOfItems;
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMDCalendarViewCellIdentifier forIndexPath:indexPath];
    
    NSDate *date = [self dateForIndexPath:indexPath];
    NSInteger sectionMonth = [self monthForSection:indexPath.section];
    if ([date month] != sectionMonth) {
        cell.backgroundColor = [UIColor yellowColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.date = date;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MDCalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMDCalendarHeaderViewIdentifier forIndexPath:indexPath];
    headerView.month = [self monthForSection:indexPath.section];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate calendarView:self didSelectDate:[self dateForIndexPath:indexPath]];
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
