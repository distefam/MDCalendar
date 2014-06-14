MDCalendar
==========

`MDCalendar` is a calendar-style date picker for iOS 7 (and above) that uses `UICollectionView` to layout a calendar in the popular "month view" format.

![example_calendar](https://dl.dropboxusercontent.com/u/2362090/MDCalendar_demo.png)

## Implementation Notes

`MDCalendar` was developed with flexibility in mind and is consequently implemented as a subclass of `UIView`. This means that a calendar may be instantiated as a subview in an existing view hierarchy or pushed onto a navigation stack as the sole view of a `UIViewController`. The latter behavior is demonstrated in the `MDCalendarDemo` project.

One of the philosophies used while designing `MDCalendar` was to minimize an explicit storage-based model. As a result, the vast majority of date and geometry math is calculated on-the-fly. Caching, particularly for the geometric calculations has been implemented, and `MDCalendar` has been tested with an `endDate` of `[NSDate distantFuture]`.

## Usage Example

Suppose a view controller called `EventDetailsViewController` wants to allow users to modify the date of the event using a nice calendar picker. Hmm... let's use `MDCalendar` for that! `EventDetailsViewController` is a subclass of `UITableViewController` and selecting one of the rows should push a calendar on-screen and allow users to modify the `eventDate` property of the `EventDetailsViewController`

The advised implementation of this is to create a sparse view controller to display an `MDCalendar` (see the demo project for an example of how to do that). This view controller, let's call it `MDEventCalendarViewController` (creative, I know), will be pushed onto the navigation stack.

## Events & Delegation

In the above example, we will need to communicate calendar events back to its parent view controller. In order to do this elegantly, subclass `MDCalendarDelegate` in `MDEventCalendarViewController` and expose this protocol, `MDEventCalendarDelegate`, in the view controller's header. Now, the parent view controller, `EventDetailsViewController`, can set its delegate: `id<MDEventCalendarDelegate>delegate`
 
This delegate will essentially pass messages from `MDCalendarDelegate` onto the parent view controller. Advantages of subclassing `MDCalendarDelegate` is that if you were to re-use your sparse view controller it could contain some logic of how to interperet `MDCalendarDelegate` events.
