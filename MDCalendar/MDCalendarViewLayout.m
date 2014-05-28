//
//  MDCalendarViewLayout.m
//  MDCalendarDemo
//
//  Created by Michael Distefano on 5/24/14.
//  Copyright (c) 2014 Michael Distefano. All rights reserved.
//

#import "MDCalendarViewLayout.h"

@implementation MDCalendarViewLayout

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (indexPath.item == 1) {
        return attributes;
    }
    return attributes;
}

@end
