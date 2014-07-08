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
@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign) CGFloat itemSpacing;    /**< default is 0pt */
@property (nonatomic, assign) CGFloat lineSpacing;    /**< default is 1pt; line spacing reveals backgroundColor between lines */
@property (nonatomic, assign) CGFloat borderHeight;   /**< default is 0pt; lineSpacing and borderHeight are mutually exclusive. If set, overrides lineSpacing behavior */
@property (nonatomic, strong) UIColor *borderColor;   /**< default is textColor */
@property (nonatomic, assign) BOOL showsBottomSectionBorder; /** default is NO */


///--------------------------------
/// @name Date Range and Selection
///--------------------------------
@property (nonatomic, strong) NSDate  *startDate;     /**< Specify date to start calendar. Default is date when calendar created. */
@property (nonatomic, strong) NSDate  *endDate;       /**< Specify date to end calendar. Defaults to end of month for startDate. */
@property (nonatomic, strong) NSDate  *selectedDate;  /**< default is startDate */


///--------------------------------
/// @name Appearance
///--------------------------------
@property (nonatomic, strong) UIFont  *dayFont;                 /**< Default is system font, size 17 */
@property (nonatomic, strong) UIFont  *headerFont;              /**< Default is system font, size 20 */
@property (nonatomic, strong) UIFont  *weekdayFont;             /**< Default is system font, size 12 */

@property (nonatomic, strong) UIColor *textColor;               /**< Default is dark gray */
@property (nonatomic, strong) UIColor *headerBackgroundColor;   /**< Default is no background color (clear) */
@property (nonatomic, strong) UIColor *headerTextColor;         /**< Default is textColor */
@property (nonatomic, strong) UIColor *weekdayTextColor;        /**< Default is textColor */

@property (nonatomic, strong) UIColor *cellBackgroundColor;     /**< Default is no background color for individual cells */
@property (nonatomic, strong) UIColor *highlightColor;          /**< Default is tint color */


///--------------------------------
/// @name Selection behavior
///--------------------------------
@property (nonatomic, assign) BOOL showsDaysOutsideCurrentMonth;    /**< Default is NO */
@property (nonatomic, assign) BOOL canSelectDaysBeforeStartDate;    /**< Default is YES */

/**
 *  force scrolling to specific date; note: calendar will automatically scroll to selected date if date is not on-screen
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
- (void)calendarView:(MDCalendar *)calendarView didSelectDate:(NSDate *)date;
- (BOOL)calendarView:(MDCalendar *)calendarView shouldSelectDate:(NSDate *)date;
@end
