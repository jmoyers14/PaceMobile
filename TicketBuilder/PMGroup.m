//
//  PMGroup.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMGroup.h"

@implementation PMGroup
@synthesize group = _group;
@synthesize groupDesc = _groupDesc;

- (id) initWithGroup:(NSString *)group groupDesc:(NSString *)groupDesc {
    self = [super init];
    if (self) {
        _group = group;
        _groupDesc = groupDesc;
    }
    return self;
}

- (id) init {
    return [self initWithGroup:@"" groupDesc:@""];
}


@end
