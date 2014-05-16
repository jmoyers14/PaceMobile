//
//  PMOrder.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/9/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMOrder.h"

@implementation PMOrder
@synthesize ordNum  = _ordNum;
@synthesize ordRow  = _ordRow;
@synthesize date    = _date;
@synthesize comment = _comment;
@synthesize items = _items;
@synthesize currentItem = _currentItem;

NSUInteger _currentItemIndex;

//designated initializer
- (id) initWithRow:(NSUInteger)row Date:(NSString *)date orderNum:(NSUInteger)ordNum comment:(NSString *)ordComment {
    
    self = [super init];
    if (self) {
        _ordRow = row;
        _ordNum = ordNum;
        _date = date;
        _currentItemIndex = 0;
        _items = [[NSMutableArray alloc] init];
        self.comment = ordComment;
    }
    return self;
}

- (id) init {
    //call designated initializer
    return [self initWithRow:0 Date:@"" orderNum:0 comment:@""];
}


- (void) setItems:(NSArray *)items {
    _currentItemIndex = 0;
    _items = items;
}

- (void) setCurrentItem:(PMItem *)currentItem {
    if([_items containsObject:currentItem]) {
        _currentItemIndex = [_items indexOfObject:currentItem];
    } else {
        NSLog(@"%i currentItemIndex out of bounds", _currentItemIndex);
    }
}

- (PMItem *) currentItem {
    if(_currentItemIndex < [_items count]) {
        return [_items objectAtIndex:_currentItemIndex];
    } else {
        NSLog(@"%i currentItemIndex out of bounds", _currentItemIndex);
        return nil;
    }
}

+ (NSArray *) dictionaryKeys {
    return [NSArray arrayWithObjects:@"ordNum", @"ordRow", @"date", @"comment", nil];
}

//WARNING equals only checks designated initializer values
// row, num, date, comment
- (BOOL) isEqualToOrder:(PMOrder *)order {
    
    if((_ordRow == [order ordRow]) &&
       (_ordNum == [order ordNum]) &&
       ([_date isEqualToString:[order date]]) &&
       [_comment isEqualToString:[order comment]]) {
        return  YES;
    } else {
        return NO;
    }
    
}

@end
