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

//designated initializer
- (id) initWithPart:(PMPart *)part quantity:(NSUInteger)qty transType:(PMTransactionType)transType {
    self = [super init];
    if (self) {
        _part = part;
        _transType = transType;
        _qty = qty;
    }
    
    return self;
}

- (id) init {
    //call designated i nitializer
    return [self initWithPart:nil quantity:0 transType:0];
}

- (BOOL) isEqualToItem:(PMItem *)item {
    if((_qty == [item qty])&&
       (_transType == [item transType])&&
       ([_part isEqualToPart:[item part]])) {
        return YES;
    } else {
        return NO;
    }
}
@end
