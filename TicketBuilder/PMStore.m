//
//  PMStore.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/2/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMStore.h"

@implementation PMStore
@synthesize name = _name;
@synthesize storeId = _storeId;


- (id) initWithName:(NSString *)name andID:(NSUInteger)storeId {
    self = [super init];
    if (self) {
        _name = name;
        _storeId = storeId;
    }
    return self;
}

- (id) init {
    return [self initWithName:@"Unnamed Store" andID:0];
}

@end
