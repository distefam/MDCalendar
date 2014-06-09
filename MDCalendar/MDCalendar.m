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

- (void)setTextColor:(UIColor *)textColor {
    for (UILabel *label in _dayLabels) {
        label.textColor = textColor;
    }
}

- (void)setFont:(UIFont *)font {
    for (UILabel *label in _dayLabels) {
        label.font = font;
    }
}

@end

@interface MDCalendarHeaderView : UICollectionReusableView
@property (nonatomic, assign) NSDate  *firstDayOfMonth;
@property (nonatomic, assign) BOOL     shouldShowYear;

@property (nonatomic, assign) UIFont  *font;
@property (nonatomic, assign) UIColor *textColor;

@property (nonatomic, assign) UIFont  *weekdayFont;
@property (nonatomic, assign) UIColor *weekdayTextColor;
@end

@interface MDCalendarHeaderView ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) MDCalendarWeekdaysView *weekdaysView;
@end

static NSString * const kMDCalendarHeaderViewIdentifier = @"kMDCalendarHeaderViewIdentifier";
static CGFloat const kMDCalendarHeaderViewMonthBottomMargin     = 10.f;
static CGFloat const kMDCalendarHeaderViewWeekdayBottomMoargin  = 5.f;


@implementation MDCalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
    _label.frame = CGRectMake(0, 0, viewSize.width, (viewSize.height / 3 * 2) - kMDCalendarHeaderViewMonthBottomMargin);
    _weekdaysView.frame = CGRectMake(0, CGRectGetMaxY(_label.bounds) + kMDCalendarHeaderViewMonthBottomMargin, viewSize.width, viewSize.height - CGRectGetHeight(_label.bounds) - kMDCalendarHeaderViewWeekdayBottomMoargin);
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat monthLabelHeight = [_label sizeThatFits:CGSizeZero].height;
    CGFloat weekdaysViewHeight = [[self weekdaysView] sizeThatFits:CGSizeZero].height;
    CGFloat marginHeights = kMDCalendarHeaderViewMonthBottomMargin + kMDCalendarHeaderViewWeekdayBottomMoargin;
    
    CGFloat height = monthLabelHeight + weekdaysViewHeight + marginHeights;
    return CGSizeMake([super sizeThatFits:size].width, height);
}

- (void)setFirstDayOfMonth:(NSDate *)firstDayOfMonth {
    _firstDayOfMonth = firstDayOfMonth;
    NSString *monthString = [NSDate monthNameForMonth:[firstDayOfMonth month]];
    NSString *yearString = [NSString stringWithFormat:@" %d", (int)[firstDayOfMonth year]];
    _label.text = self.shouldShowYear ? [monthString stringByAppendingString:yearString] : monthString;
}

- (void)setFont:(UIFont *)font {
    _label.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _label.textColor = textColor;
}

- (void)setWeekdayFont:(UIFont *)weekdayFont {
    _weekdaysView.font = weekdayFont;
}

- (void)setWeekdayTextColor:(UIColor *)weekdayTextColor {
    _weekdaysView.textColor = weekdayTextColor;
}


@end

@interface MDCalendar () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, assign) NSDate *currentDate;
@end

#define DAYS_IN_WEEK 7
#define MONTHS_IN_YEAR 12

// Default spacing
static CGFloat const kMDCalendarViewItemSpacing    = 0.f;
static CGFloat const kMDCalendarViewLineSpacing    = 1.f;
static CGFloat const kMDCalendarViewSectionSpacing = 10.f;

@implementation MDCalendar

@synthesize selectedDate        = pSelectedDate;
@synthesize startDate           = pStartDate;
@synthesize endDate             = pEndDate;

@synthesize dayFont             = pDayFont;
@synthesize headerFont          = pHeaderFont;
@synthesize weekdayFont         = pWeekdayFont;

@synthesize cellBackgroundColor = pCellBackgroundColor;
@synthesize highlightColor      = pHighlightColor;

@synthesize textColor           = pTextColor;
@synthesize headerTextColor     = pHeaderTextColor;
@synthesize weekdayTextColor    = pWeekdayTextColor;

- (instancetype)init {
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing  = kMDCalendarViewItemSpacing;
        layout.minimumLineSpacing       = kMDCalendarViewLineSpacing;
        self.layout = layout;
        
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
    headerView.firstDayOfMonth = [self startDate];
    return [headerView sizeThatFits:CGSizeZero];
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

- (void)setItemSpacing:(CGFloat)itemSpacing {
    _layout.minimumInteritemSpacing = itemSpacing;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _layout.minimumLineSpacing = lineSpacing;
}

- (NSDate *)currentDate {
    return [NSDate date];
}

- (NSDate *)selectedDate {
    if (!pSelectedDate) {
        pSelectedDate = self.startDate;
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

- (UIFont *)weekdayFont {
    if (!pWeekdayFont) {
        pWeekdayFont = [UIFont systemFontOfSize:12];
    }
    return pWeekdayFont;
}

- (UIColor *)textColor {
    if (!pTextColor) {
        pTextColor = [UIColor blackColor];
    }
    return pTextColor;
}

- (UIColor *)headerTextColor {
    if (!pHeaderTextColor) {
        pHeaderTextColor = [self textColor];
    }
    return pHeaderTextColor;
}

- (UIColor *)weekdayTextColor {
    if (!pWeekdayTextColor) {
        pWeekdayTextColor = [self textColor];
    }
    return pWeekdayTextColor;
}

- (void)setWeekdayTextColor:(UIColor *)weekdayTextColor {
    pWeekdayTextColor = weekdayTextColor;
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
    cell.textColor = [date isEqualToDateSansTime:[self currentDate]] ? self.highlightColor : self.textColor;
    cell.date = date;
    cell.highlightColor = self.highlightColor;
    
    NSInteger sectionMonth = [self monthForSection:indexPath.section];
    
    cell.userInteractionEnabled = [self collectionView:collectionView shouldSelectItemAtIndexPath:indexPath] ? YES : NO;
    
    // Disable non-selectable cells
    if (![self collectionView:collectionView shouldSelectItemAtIndexPath:indexPath]) {
        cell.textColor = [cell.textColor colorWithAlphaComponent:0.2];
        cell.userInteractionEnabled = NO;
    }
    
    // Handle showing cells outside of current month
    if ([date month] != sectionMonth) {
        if (self.showsDaysOutsideCurrentMonth) {
            cell.backgroundColor = [cell.backgroundColor colorWithAlphaComponent:0.2];
        } else {
            cell.label.text = @"";
        }
        cell.userInteractionEnabled = NO;
    }
    
    // Handle cell highlighting
    if ([date isEqualToDateSansTime:self.selectedDate]) {
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MDCalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMDCalendarHeaderViewIdentifier forIndexPath:indexPath];

    headerView.backgroundColor = self.backgroundColor;
    headerView.font = self.headerFont;
    headerView.weekdayFont = self.weekdayFont;
    headerView.textColor = self.headerTextColor;
    headerView.weekdayTextColor = self.weekdayTextColor;

    NSDate *date = [self dateForFirstDayOfSection:indexPath.section];
    headerView.shouldShowYear = [date year] != [self.startDate year];
    headerView.firstDayOfMonth = date;

    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate calendarView:self didSelectDate:[self dateForIndexPath:indexPath]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [self dateForIndexPath:indexPath];
    BOOL isBeforeStartDate = [date isBeforeDate:self.startDate];
    
    if ([_delegate respondsToSelector:@selector(calendarView:shouldSelectDate:)]) {
        return [_delegate calendarView:self shouldSelectDate:date];
    } else if (!self.canSelectDaysBeforeStartDate && isBeforeStartDate) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = [self cellWidth];
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat boundsWidth = collectionView.bounds.size.width;
    CGFloat remainingPoints = boundsWidth - ([self cellWidth] * DAYS_IN_WEEK);
    return UIEdgeInsetsMake(0, remainingPoints / 2, 0, remainingPoints / 2);
}

// Helpers

- (CGFloat)cellWidth {
    CGFloat boundsWidth = _collectionView.bounds.size.width;
    return floor(boundsWidth / DAYS_IN_WEEK) - kMDCalendarViewItemSpacing;
}

@end
