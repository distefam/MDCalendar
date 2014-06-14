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

@protocol MDCalendarDelegate;

@interface MDCalendar : UIView

@property (nonatomic, assign) id<MDCalendarDelegate>delegate;

@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign) CGFloat itemSpacing;    // default is 0pt
@property (nonatomic, assign) CGFloat lineSpacing;    // default is 1pt; line spacing reveals backgroundColor between lines
@property (nonatomic, assign) CGFloat borderHeight;   // default is 0pt; lineSpacing and borderHeight are mutually exclusive. If set, overrides lineSpacing behavior
@property (nonatomic, strong) UIColor *borderColor;   // default is textColor

@property (nonatomic, strong) NSDate  *startDate;     // Specify date to start calendar. Default is date when calendar created.
@property (nonatomic, strong) NSDate  *endDate;       // Specify date to end calendar. Defaults to end of month for startDate.
@property (nonatomic, strong) NSDate  *selectedDate;  // default is startDate

@property (nonatomic, strong) UIFont  *dayFont;                 // Default is system font, size 17
@property (nonatomic, strong) UIFont  *headerFont;              // Default is system font, size 20
@property (nonatomic, strong) UIFont  *weekdayFont;             // Default is system font, size 12

@property (nonatomic, strong) UIColor *textColor;               // Default is dark gray
@property (nonatomic, strong) UIColor *headerBackgroundColor;   // Default is no background color (clear)
@property (nonatomic, strong) UIColor *headerTextColor;         // Default is textColor
@property (nonatomic, strong) UIColor *weekdayTextColor;        // Default is textColor

@property (nonatomic, strong) UIColor *cellBackgroundColor;     // Default is no background color for individual cells
@property (nonatomic, strong) UIColor *highlightColor;          // Default is tint color

@property (nonatomic, assign) BOOL showsDaysOutsideCurrentMonth;    // Default is NO
@property (nonatomic, assign) BOOL canSelectDaysBeforeStartDate;    // Default is YES

// force scrolling to specific date; note: calendar will automatically scroll to selected date if date is not on-screen
- (void)scrollCalendarToDate:(NSDate *)date animated:(BOOL)animated;

@end

@protocol MDCalendarDelegate <NSObject>
@optional
- (void)calendarView:(MDCalendar *)calendarView didSelectDate:(NSDate *)date;
- (BOOL)calendarView:(MDCalendar *)calendarView shouldSelectDate:(NSDate *)date;
@end