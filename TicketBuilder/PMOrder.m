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

//designated initializer
- (id) initWithRow:(NSUInteger)row Date:(NSString *)date orderNum:(NSUInteger)ordNum comment:(NSString *)ordComment {
    
    self = [super init];
    if (self) {
        _ordRow = row;
        _ordNum = ordNum;
        _date = date;
        self.comment = ordComment;
    }
    return self;
}

- (id) init {
    //call designated initializer
    return [self initWithRow:0 Date:@"" orderNum:0 comment:@""];
}

@end
