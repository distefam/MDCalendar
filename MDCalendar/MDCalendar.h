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

@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, strong) NSDate *selectedDate;  // default is current date when calendar created
@property (nonatomic, strong) NSDate *startDate;    // Specify date to start calendar. Default is currentDate.
@property (nonatomic, strong) NSDate *endDate;      // Specify date to end calendar. Defaults to end of month for startDate.

@property (nonatomic, assign) id<MDCalendarDelegate>delegate;

@property (nonatomic, strong) UIFont  *dayFont;                 // Default is system font, size 17
@property (nonatomic, strong) UIFont  *headerFont;              // Default is system font, size 20
@property (nonatomic, strong) UIColor *textColor;               // Default is black
@property (nonatomic, strong) UIColor *cellBackgroundColor;     // Default is no background color for individual cells
@property (nonatomic, strong) UIColor *highlightColor;          // Default is tint color

@property (nonatomic, assign) BOOL showsDaysOutsideCurrentMonth;    // Default is NO

@end

@protocol MDCalendarDelegate <NSObject>
- (void)calendarView:(MDCalendar *)calendarView didSelectDate:(NSDate *)date;
@optional
- (BOOL)calendarView:(MDCalendar *)calendarView shouldSelectDate:(NSDate *)date;
@end