//
//  MDCalendar.h
//
//
//  Copyright (c) 2014 Michael DiStefano
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <Foundation/Foundation.h>
#import "NSDate+MDCalendar.h"

/**
 *  `MDCalendar` is a calendar-style date picker for iOS 7 (and above) that uses `UICollectionView`
 *  to layout a calendar in the popular "month view" format.
 *
 *  ## Implementation Notes
 *
 *  `MDCalendar` was developed with flexibility in mind and is consequently implemented as a
 *  subclass of `UIView`. This means that a calendar may be instantiated as a subview in an existing
 *  view hierarchy or pushed onto a navigation stack as the sole view of a `UIViewController`. 
 *  The latter behavior is demonstrated in the `MDCalendarDemo` project.
 *
 *  One of the philosophies used while designing `MDCalendar` was to minimize an explicit storage-based
 *  model. As a result, the vast majority of date and geometry math is calculated on-the-fly. Caching,
 *  particularly for the geometric calculations has been implemented, and `MDCalendar` has been tested
 *  with an `endDate` of `[NSDate distantFuture]`.
 *
 *  ## Usage Example
 *  
 *  Suppose a view controller called `EventDetailsViewController` wants to allow
 *  users to modify the date of the event using a nice calendar picker. Hmm... let's
 *  use `MDCalendar` for that! `EventDetailsViewController` is a subclass of
 *  `UITableViewController` and selecting one of the rows should push a calendar
 *  on-screen and allow users to modify the `eventDate` property of the `EventDetailsViewController`
 *
 *  The advised implementation of this is to create a sparse view controller to display an
 *  `MDCalendar` (see the demo project for an example of how to do that). This view controller,
 *  let's call it `MDEventCalendarViewController` (creative, I know), will be pushed onto the navigation
 *  stack.
 *
 *  @see MDCalendarDelegate class below for information on how to pass events back to the parent view controller.
 *
 */


@protocol MDCalendarDelegate;

@interface MDCalendar : UIView

@property (nonatomic, assign) id<MDCalendarDelegate>delegate; /** A delegate that responds to calendar events. */

///--------------------------------
/// @name Layout
///--------------------------------

/**
 * Sets the `contentInset` on the underlying collection view
 *
 * Default is `UIEdgeInsetsNone`
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 * Horizontal spacing between days of the week. Will reveal the background
 * color of your view.
 *
 * Default is 0pt.
 */
@property (nonatomic, assign) CGFloat itemSpacing;

/**
 * Vertical spacing between weeks. Will reveal the background color
 * of your view.
 *
 * Default is 1pt. 
 */
@property (nonatomic, assign) CGFloat lineSpacing;

/**
 * Set `borderHeight` to manually provide a border color. 
 *
 * Default is 0pt.
 *
 * @warning `borderHeight` and `lineSpacing` are mutually exclusive. 
 * If `borderHeight` is set it will override lineSpacing.
 */
@property (nonatomic, assign) CGFloat borderHeight;

/**
 * Border color of vertical border.
 *
 * Default is @see textColor
 *
 * @warning this will only apply if @see borderHeight is set
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 * Set to `YES` to display a border at the bottom of each month.
 *
 * Default is `NO`
 */
@property (nonatomic, assign) BOOL showsBottomSectionBorder;


///--------------------------------
/// @name Date Range and Selection
///--------------------------------

/**
 * Specify a date on which to start your calendar.
 * If no date is specified it will default to the current system date.
 */
@property (nonatomic, strong) NSDate  *startDate;

/**
 * Specify a date to end the calendar. 
 * If no value is set it will default to three months out from the @see startDate
 */
@property (nonatomic, strong) NSDate  *endDate;

/**
 * Allows you to manually specify a date to be selected when the calendar is set-up.
 * Defaults to @see startDate
 */
@property (nonatomic, strong) NSDate  *selectedDate;  /**< default is startDate */


///--------------------------------
/// @name Appearance : Fonts
///--------------------------------

/**
 * Font for numbers on day cells.
 * Default is system font, size 17
 */
@property (nonatomic, strong) UIFont  *dayFont;

/**
 * Font for month name headers.
 * Default is system font, size 20
 */
@property (nonatomic, strong) UIFont  *headerFont;

/**
 * Font for weekday abbreviations.
 * Default is system font, size 12
 *
 * @warning this will be displayed in all caps
 */
@property (nonatomic, strong) UIFont  *weekdayFont;

///--------------------------------
/// @name Appearance : Text Colors
///--------------------------------

/**
 * Text color for @see dayFont
 * Default is dark gray
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 * Text color for @see headerFont
 * Default is @see textColor
 */
@property (nonatomic, strong) UIColor *headerTextColor;

/**
 * Text color for @see weekdayFont
 * Default is @see textColor
 */
@property (nonatomic, strong) UIColor *weekdayTextColor;

///------------------------------------------------
/// @name Appearance : Background & Element Colors
///------------------------------------------------

/**
 * Background color for month name headers.
 * Default is `[UIColor clearColor]`
 */
@property (nonatomic, strong) UIColor *headerBackgroundColor;

/**
 * Background color for day cells.
 * Deafault is `nil`
 */
@property (nonatomic, strong) UIColor *cellBackgroundColor;

/**
 * Color for day indicator (dots)
 * Default is light gray
 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**
 * Color for highlight view (circle that displays when cell is selected).
 * Default is @see tintColor
 */
@property (nonatomic, strong) UIColor *highlightColor;


///--------------------------------
/// @name Selection behavior
///--------------------------------

/**
 * By default, each month is displayed in a rectangle. If a given month starts on a Thursday
 * the first number in that rectangle, 1, will be under TH. If the last day is on a Wednesday
 * the last number, 31, will be on Wednesday. Only the numbers 1-31 will be displayed.
 *
 * Setting this to `YES` will show days not in the current month in that month's rectangle.
 * Using the example above, before Thursday the 1st you would see Su 28, Mo 29, Tu 30, We 31.
 * If set to `YES` these cells will show with a 20% opacity of the @see cellBackgroundColor
 */
@property (nonatomic, assign) BOOL showsDaysOutsideCurrentMonth;

/**
 * Setting the start date to a date in the middle of the month still shows every day before it
 * for that month. By default, it is possible to select these days. Set to `NO` to disallow
 * this behavior.
 */
@property (nonatomic, assign) BOOL canSelectDaysBeforeStartDate;    /**< Default is YES */

/**
 * Scroll calendar to a specific date.
 *
 * @warning The calendar will automatically scroll to @see selectedDate upon selection
 * if that date is not on-screen
 */
- (void)scrollCalendarToDate:(NSDate *)date animated:(BOOL)animated;

@end


/**
 * A delegate that responds to calendar events.
 *
 * Note: if a calendar view is pushed onto the navigation stack as the sole view of
 * a sparse view controller, then it is advised to subclass `MDCalendarDelegate` and 
 * implement the subclassed delegate in your parent view controller. 
 *
 * ## Example
 *
 * Suppose a view controller called `EventDetailsViewController` wants to allow
 * users to modify the date of the event using a nice calendar picker. Hmm... let's 
 * use `MDCalendar` for that! `EventDetailsViewController` is a subclass of 
 * `UITableViewController` and selecting one of the rows should push a calendar
 * on-screen and allow users to modify the `eventDate` property of the `EventDetailsViewController`
 * 
 * The advised implementation of this is to create a sparse view controller to display an
 * `MDCalendar` (see the demo project for an example of how to do that). This view controller, 
 * let's call it `MDEventCalendarViewController` (creative, I know), will be pushed onto the navigation
 * stack and will need to communicate calendar events back to its parent view controller.
 * In order to do this elegantly, subclass `MDCalendarDelegate` in `MDEventCalendarViewController` and
 * expose this protocol, `MDEventCalendarDelegate`, in the view controller's header.
 * Now, the parent view controller, `EventDetailsViewController`, can set its delegate.
 *
 * `id<MDEventCalendarDelegate>delegate`
 *
 * This delegate will essentially pass messages from `MDCalendarDelegate` onto the parent view controller.
 * Advantages of subclassing `MDCalendarDelegate` is that if you were to re-use your sparse view controller
 * it could contain some logic of how to interperet `MDCalendarDelegate` events.
 *
 */

@protocol MDCalendarDelegate <NSObject>
@optional

/**
 * Reports the selected date.
 */
- (void)calendarView:(MDCalendar *)calendarView didSelectDate:(NSDate *)date;

/**
 * Implement this delegate method to specify which dates should be selectable.
 * Non-selectable dates' cells are shown with 20% background opacity.
 * @see canSelectDaysBeforeStartDate
 */
- (BOOL)calendarView:(MDCalendar *)calendarView shouldSelectDate:(NSDate *)date;

/**
 * Shows an indicator view (dot) for a given date.
 * @see indicatorColor
 */
- (BOOL)calendarView:(MDCalendar *)calendarView shouldShowIndicatorForDate:(NSDate *)date;
@end
