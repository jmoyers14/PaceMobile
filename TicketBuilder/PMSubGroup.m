//
//  PMSubGroup.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMSubGroup.h"

@implementation PMSubGroup
@synthesize subGroup     = _subGroup;
@synthesize subGroupDesc = _subGroupDesc;



- (id) initWithSubGroup:(NSString *)subgroup subGroupDesc:(NSString *)subGroupDesc {
    self = [super init];
    if (self) {
        _subGroup = subgroup;
        _subGroupDesc = subGroupDesc;
    }
    return self;
}

- (id) init {
    return [self initWithSubGroup:@"" subGroupDesc:@""];
}

@end
