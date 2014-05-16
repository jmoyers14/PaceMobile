//
//  PMMake.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMMake.h"

@implementation PMMake
@synthesize make = _make;
@synthesize makeDesc = _makeDesc;

- (id) initWithMake:(NSString *)make makeDesc:(NSString *)makeDesc {
    if (self) {
        _make = make;
        _makeDesc = makeDesc;
    }
    return self;
}

- (id) init {
    return [self initWithMake:@"" makeDesc:@""];
}

@end
