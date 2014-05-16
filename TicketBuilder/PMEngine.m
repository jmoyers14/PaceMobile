//
//  PMEngine.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMEngine.h"

@implementation PMEngine
@synthesize vid = _vid;
@synthesize engineDesc = _engineDesc;

- (id) initWithVid:(NSString *)vid engineDesc:(NSString *)engineDesc {
    self = [super init];
    if (self) {
        _vid = vid;
        _engineDesc = engineDesc;
    }
    return self;
}

- (id) init {
    return [self initWithVid:@"" engineDesc:@""];
}

@end
