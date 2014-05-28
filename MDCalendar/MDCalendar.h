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

@property (nonatomic, strong) NSDate *currentDate;  // default is current date when calendar created
@property (nonatomic, strong) NSDate *startDate;    // Specify date to start calendar. Default is currentDate.
@property (nonatomic, strong) NSDate *endDate;      // Specify date to end calendar. Defaults to end of month for startDate.

@property (nonatomic, assign) id<MDCalendarDelegate>delegate;

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;    // Designated Initializer

@end

@protocol MDCalendarDelegate <NSObject>
- (void)calendarView:(MDCalendar *)calendarView didSelectDate:(NSDate *)date;
@optional
- (BOOL)calendarView:(MDCalendar *)calendarView shouldSelectDate:(NSDate *)date;
@end