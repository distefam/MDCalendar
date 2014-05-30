//
//  MDCalendar.m
//
//
//  Created by Michael Distefano on 5/23/14.
//
//

#import "MDCalendar.h"

@interface MDCalendarViewCell : UICollectionViewCell
@property (nonatomic, assign) NSDate  *date;
@property (nonatomic, assign) UIFont  *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) UIColor *highlightColor;
@end

@interface MDCalendarViewCell  ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView  *highlightView;
@end

static NSString * const kMDCalendarViewCellIdentifier = @"kMDCalendarViewCellIdentifier";

@implementation MDCalendarViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        
        UIView *highlightView = [[UIView alloc] initWithFrame:CGRectZero];
        highlightView.hidden = YES;
        
        [self.contentView addSubview:highlightView];
        [self.contentView addSubview:label];
        
        self.label = label;
        self.highlightView = highlightView;
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    _label.text = MDCalendarDayStringFromDate(date);
}

- (void)setFont:(UIFont *)font {
    _label.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _label.textColor = textColor;
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    _highlightView.backgroundColor = highlightColor;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    _highlightView.hidden = !selected;
    _label.textColor = selected ? [UIColor whiteColor] : _textColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _label.frame = self.bounds;
    
    // bounds of highlight view 10% smaller than cell
    CGFloat highlightViewInset = CGRectGetHeight(self.bounds) * 0.1f;
    _highlightView.frame = CGRectInset(self.bounds, highlightViewInset, highlightViewInset);
    _highlightView.layer.cornerRadius = CGRectGetHeight(_highlightView.bounds) / 2;
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

@interface MDCalendarWeekdaysView : UIView
@property (nonatomic, strong) NSArray *dayLabels;

@property (nonatomic, assign) UIColor *textColor;
@property (nonatomic, assign) UIFont  *font;
@end

@implementation MDCalendarWeekdaysView

@synthesize font = pFont;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSArray *weekdays = [NSDate weekdays];
        NSMutableArray *dayLabels = [NSMutableArray new];
        for (NSString *day in weekdays) {
            UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            dayLabel.text = day;
            dayLabel.font = self.font;
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.adjustsFontSizeToFitWidth = YES;
            [dayLabels addObject:dayLabel];
            
            [self addSubview:dayLabel];
        }
        
        self.dayLabels = dayLabels;
    }
    return self;
}

- (CGSize)dayLabelSize {
    UILabel *label = (UILabel *)[_dayLabels firstObject];
    return [label sizeThatFits:CGSizeZero];
}

- (CGSize)sizeThatFits:(CGSize)size {
    [super sizeThatFits:size];
    
    return CGSizeMake(self.bounds.size.width, [self dayLabelSize].height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelWidth = CGRectGetWidth(self.bounds) / [_dayLabels count];
    CGRect labelFrame = CGRectMake(0, 0, labelWidth, [self dayLabelSize].height);
    for (UILabel *label in _dayLabels) {
        label.frame = labelFrame;
        labelFrame = CGRectOffset(labelFrame, labelWidth, 0);
    }
}

- (UIFont *)font {
    if (!pFont) {
        pFont = [UIFont systemFontOfSize:12];
    }
    return pFont;
}

@end

@interface MDCalendarHeaderView : UICollectionReusableView
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) UIFont  *font;
@property (nonatomic, assign) UIColor *textColor;
@end

@interface MDCalendarHeaderView ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) MDCalendarWeekdaysView *weekdaysView;
@end

static NSString * const kMDCalendarHeaderViewIdentifier = @"kMDCalendarHeaderViewIdentifier";

@implementation MDCalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        
        MDCalendarWeekdaysView *weekdaysView = [[MDCalendarWeekdaysView alloc] initWithFrame:CGRectZero];
        [self addSubview:weekdaysView];
        self.weekdaysView = weekdaysView;
        
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize viewSize = self.bounds.size;
    _label.frame = CGRectMake(0, 0, viewSize.width, viewSize.height / 3 * 2);
    _weekdaysView.frame = CGRectMake(0, CGRectGetMaxY(_label.bounds), viewSize.width, viewSize.height - CGRectGetHeight(_label.bounds));
}

- (CGSize)sizeThatFits:(CGSize)size {
    [super sizeThatFits:size];
    
    CGFloat height = [_label sizeThatFits:CGSizeZero].height + [[self weekdaysView] sizeThatFits:CGSizeZero].height;
    return CGSizeMake(self.bounds.size.width, height);
}

- (void)setMonth:(NSInteger)month {
    _label.text = [NSDate monthNameForMonth:month];
}

- (void)setFont:(UIFont *)font {
    _label.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _label.textColor = textColor;
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

@synthesize selectedDate        = pSelectedDate;
@synthesize startDate           = pStartDate;
@synthesize endDate             = pEndDate;
@synthesize dayFont             = pDayFont;
@synthesize textColor           = pTextColor;
@synthesize cellBackgroundColor = pCellBackgroundColor;
@synthesize highlightColor      = pHighlightColor;
@synthesize headerFont          = pHeaderFont;

- (instancetype)init {
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing  = kMDCalendarViewItemSpacing;
        layout.minimumLineSpacing       = kMDCalendarViewLineSpacing;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.allowsMultipleSelection = NO;
        
        [_collectionView registerClass:[MDCalendarViewCell class] forCellWithReuseIdentifier:kMDCalendarViewCellIdentifier];
        [_collectionView registerClass:[MDCalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMDCalendarHeaderViewIdentifier];
        
        
        
        [self addSubview:_collectionView];
    }
    return self;
}

- (CGSize)headerViewSize {
    MDCalendarHeaderView *headerView = [[MDCalendarHeaderView alloc] initWithFrame:CGRectZero];
    headerView.month = 12;
    return [headerView sizeThatFits:CGSizeZero];
    
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//    label.font = self.headerFont;
//    label.text = @"December";
//    [label sizeToFit];
//    return label.bounds.size;
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

- (NSDate *)selectedDate {
    if (!pSelectedDate) {
        pSelectedDate = [NSDate date];
    }
    return pSelectedDate;
}

- (NSDate *)startDate {
    if (!pStartDate) {
        pStartDate = self.selectedDate;
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

- (UIFont *)dayFont {
    if (!pDayFont) {
        pDayFont = [UIFont systemFontOfSize:17];
    }
    return pDayFont;
}

- (UIFont *)headerFont {
    if (!pHeaderFont) {
        pHeaderFont = [UIFont systemFontOfSize:20];
    }
    return pHeaderFont;
}

- (UIColor *)textColor {
    if (!pTextColor) {
        pTextColor = [UIColor blackColor];
    }
    return pTextColor;
}

- (UIColor *)cellBackgroundColor {
    if (!pCellBackgroundColor) {
        pCellBackgroundColor = nil;
    }
    return pCellBackgroundColor;
}

- (UIColor *)highlightColor {
    if (!pHighlightColor) {
        pHighlightColor = self.tintColor;
    }
    return pHighlightColor;
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
    NSDate *date = [self dateForIndexPath:indexPath];
    
    MDCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMDCalendarViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.cellBackgroundColor;
    cell.font = self.dayFont;
    cell.textColor = self.textColor;
    cell.date = date;
    cell.highlightColor = self.highlightColor;
    
    NSInteger sectionMonth = [self monthForSection:indexPath.section];
    
    if ([date month] != sectionMonth) {
        if (self.showsDaysOutsideCurrentMonth) {
            cell.backgroundColor = [self.cellBackgroundColor colorWithAlphaComponent:0.3];
            cell.textColor       = [self.textColor colorWithAlphaComponent:0.3];
        } else {
            cell.label.text = @"";
        }
    } else if ([date isEqualToDate:self.selectedDate]) {
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MDCalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMDCalendarHeaderViewIdentifier forIndexPath:indexPath];
    headerView.font = self.headerFont;
    headerView.textColor = self.textColor;
    headerView.backgroundColor = self.backgroundColor;
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
    return CGSizeMake(boundsWidth, [self headerViewSize].height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(self.bounds), kMDCalendarViewSectionSpacing);
}

@end
