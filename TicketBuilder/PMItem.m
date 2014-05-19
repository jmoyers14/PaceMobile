//
//  PMItem.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/13/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMItem.h"

@implementation PMItem
@synthesize transType = _transType;
@synthesize qty = _qty;
@synthesize part = _part;
@synthesize itemRow = _itemRow;
//designated initializer
- (id) initWithItemRow:(NSUInteger)itemRow part:(PMPart *)part quantity:(NSUInteger)qty transType:(PMTransactionType)transType {
    self = [super init];
    if (self) {
        _itemRow = itemRow;
        _part = part;
        _transType = transType;
        _qty = qty;
    }
    
    return self;
}

- (id) init {
    //call designated i nitializer
    return [self initWithItemRow:0 part:nil quantity:0 transType:0];
}

- (BOOL) isEqualToItem:(PMItem *)item {
    if((_qty == [item qty])&&
       (_transType == [item transType])&&
       ([_part isEqualToPart:[item part]])&&
       (_itemRow == [item itemRow])) {
        return YES;
    } else {
        return NO;
    }
}
@end
