//
//  MDCalendar.m
//
//
//  Created by Michael Distefano on 5/23/14.
//
//

#import "MDCalendar.h"

@interface MDCalendarViewCell : UICollectionViewCell
@property (nonatomic, assign) NSDate *date;
@property (nonatomic, assign) UIFont *font;
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
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:label];
        
        self.label = label;
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    _label.text = MDCalendarDayStringFromDate(date);
}

- (void)setFont:(UIFont *)font {
    _label.font = font;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _label.frame = self.bounds;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.contentView.backgroundColor = nil;
    _label.text = @"";
}

NSString * MDCalendarDayStringFromDate(NSDate *date) {
    return [NSString stringWithFormat:@"%d", (int)[date day]];
}

@end

@interface MDCalendarHeaderView : UICollectionReusableView
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) UIFont *font;
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
    
    _label.frame = self.bounds;
}

- (void)setMonth:(NSInteger)month {
    _label.text = [NSDate monthNameForMonth:month];
}

- (void)setFont:(UIFont *)font {
    _label.font = font;
}

@end

@interface MDCalendar () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

#define DAYS_IN_WEEK 7
#define MONTHS_IN_YEAR 12

static CGFloat const kMDCalendarViewItemSpacing    = 2.f;
static CGFloat const kMDCalendarViewLineSpacing    = 2.f;
static CGFloat const kMDCalendarViewSectionSpacing = 10.f;

@implementation MDCalendar

@synthesize currentDate = pCurrentDate;
@synthesize startDate   = pStartDate;
@synthesize endDate     = pEndDate;
@synthesize font        = pFont;

- (instancetype)init {
    self = [super init];
    if (self) {
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

- (NSDate *)currentDate {
    if (!pCurrentDate) {
        pCurrentDate = [NSDate date];
    }
    return pCurrentDate;
}

- (NSDate *)startDate {
    if (!pStartDate) {
        pStartDate = self.currentDate;
    }
    return pStartDate;
}

- (void)setStartDate:(NSDate *)startDate {
    pStartDate = startDate;
}

- (NSDate *)endDate {
    if (!pEndDate) {
        pEndDate = [self.startDate lastDayOfMonth];
    }
    return pEndDate;
}

- (void)setEndDate:(NSDate *)endDate {
    pEndDate = endDate;
}

- (UIFont *)font {
    if (!pFont) {
        pFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    return pFont;
}

#pragma mark - Private Methods & Helper Functions

- (NSInteger)monthForSection:(NSInteger)section {
    NSDate *firstDayOfMonth = [[self.startDate firstDayOfMonth] dateByAddingMonths:section];
    return [firstDayOfMonth month];
}

- (NSDate *)dateForFirstDayOfSection:(NSInteger)section {
    return [[self.startDate firstDayOfMonth] dateByAddingMonths:section];
}

- (NSDate *)dateForLastDayOfSection:(NSInteger)section {
    NSDate *firstDayOfMonth = [self dateForFirstDayOfSection:section];
    return [firstDayOfMonth lastDayOfMonth];
}

- (NSInteger)offsetForSection:(NSInteger)section {
    NSDate *firstDayOfMonth = [self dateForFirstDayOfSection:section];
    return [firstDayOfMonth weekday] - 1;
}

- (NSInteger)remainderForSection:(NSInteger)section {
    NSDate *lastDayOfMonth = [self dateForLastDayOfSection:section];
    NSInteger weekday = [lastDayOfMonth weekday];
    return DAYS_IN_WEEK - weekday;
}

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [self.startDate dateByAddingMonths:indexPath.section];
    NSDateComponents *components = [date components];
    components.day = indexPath.item + 1;
    date = [NSDate dateFromComponents:components];
    
    NSInteger offset = [self offsetForSection:indexPath.section];
    if (offset) {
        date = [date dateByAddingDays:-offset];
    }
    
    return date;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.startDate numberOfMonthsUntilEndDate:self.endDate];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger month = [self monthForSection:section];
    return [NSDate numberOfDaysInMonth:month] + [self offsetForSection:section] + [self remainderForSection:section];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMDCalendarViewCellIdentifier forIndexPath:indexPath];
    cell.font = self.font;
    
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
    headerView.font = self.font;
    headerView.month = [self monthForSection:indexPath.section];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate calendarView:self didSelectDate:[self dateForIndexPath:indexPath]];
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat boundsWidth = collectionView.bounds.size.width;
    CGFloat cellWidth = (boundsWidth / DAYS_IN_WEEK) - kMDCalendarViewItemSpacing;
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
