//
//  MDCalendar.h
//  
//
//  Created by Michael Distefano on 5/23/14.
//
//

#import <Foundation/Foundation.h>
#import "NSDate+MDCalendar.h"

@protocol MDCalendarDelegate;

@interface MDCalendar : UIView

@property (nonatomic, assign) id<MDCalendarDelegate>delegate;

@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign) CGFloat itemSpacing;    // default is 0pt
@property (nonatomic, assign) CGFloat lineSpacing;    // default is 1pt

@property (nonatomic, strong) NSDate  *selectedDate;  // default is current date when calendar created
@property (nonatomic, strong) NSDate  *startDate;     // Specify date to start calendar. Default is currentDate.
@property (nonatomic, strong) NSDate  *endDate;       // Specify date to end calendar. Defaults to end of month for startDate.

@property (nonatomic, strong) UIFont  *dayFont;                 // Default is system font, size 17
@property (nonatomic, strong) UIFont  *headerFont;              // Default is system font, size 20
@property (nonatomic, strong) UIFont  *weekdayFont;             // Default is system font, size 12

@property (nonatomic, strong) UIColor *textColor;               // Default is black
@property (nonatomic, strong) UIColor *headerTextColor;         // Default is textColor
@property (nonatomic, strong) UIColor *weekdayTextColor;        // Default is textColor

@property (nonatomic, strong) UIColor *cellBackgroundColor;     // Default is no background color for individual cells
@property (nonatomic, strong) UIColor *highlightColor;          // Default is tint color

@property (nonatomic, assign) BOOL showsDaysOutsideCurrentMonth;    // Default is NO
@property (nonatomic, assign) BOOL canSelectDaysBeforeStartDate;    // Default is NO, overriden if you implement calendarView:shouldSelectDate

@end

@protocol MDCalendarDelegate <NSObject>
- (void)calendarView:(MDCalendar *)calendarView didSelectDate:(NSDate *)date;
@optional
- (BOOL)calendarView:(MDCalendar *)calendarView shouldSelectDate:(NSDate *)date;
@end