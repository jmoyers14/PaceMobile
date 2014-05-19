//
//  PMPartType.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/16/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMPartType.h"

@implementation PMPartType
@synthesize typeCode = _typeCode;
@synthesize description = _description;
@synthesize parts = _parts;

//designated initializer
- (id) initWithCode:(NSString *)code description:(NSString *)description parts:(NSArray *)parts {
    self = [super init];
    if (self) {
        _typeCode = code;
        _description = description;
        _parts = parts;
    }
    
    return self;
}

- (id) init {
    //call the designated initializer
    return [self initWithCode:@"" description:@"" parts:[[NSArray alloc] init]];
}

@end
