//
//  MDCalendarView.h
//  
//
//  Created by Michael Distefano on 5/23/14.
//
//

#import <Foundation/Foundation.h>

@protocol MDCalendarViewDelegate;

@interface MDCalendarView : UIView

@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, strong) NSLocale   *locale;   // default is [NSLocale currentLocale]
@property (nonatomic, copy)   NSCalendar *calendar; // default is [NSCalendar currentCalendar];
@property (nonatomic, strong) NSTimeZone *timeZone; // default is nil. use current time zone or time zone from calendar

@property (nonatomic, strong) NSDate *currentDate;  // default is current date when calendar created
@property (nonatomic, strong) NSDate *startDate;    // Specify date to start calendar. Default is currentDate.
@property (nonatomic, strong) NSDate *endDate;      // Specify date to end calendar. Defaults to end of month for startDate.

@property (nonatomic, assign) id<MDCalendarViewDelegate>delegate;

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;    // Designated Initializer

@end

@protocol MDCalendarViewDelegate <NSObject>
- (void)calendarView:(MDCalendarView *)calendarView didSelectDate:(NSDate *)date;
@optional
- (BOOL)calendarView:(MDCalendarView *)calendarView shouldSelectDate:(NSDate *)date;
@end