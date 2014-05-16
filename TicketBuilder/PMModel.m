//
//  PMModel.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMModel.h"

@implementation PMModel
@synthesize model = _model;
@synthesize modelDesc = _modelDesc;

- (id) initWithModel:(NSString *)model modelDesc:(NSString *)modelDesc {
    self = [super init];
    if (self) {
        _model = model;
        _modelDesc = modelDesc;
    }
    return self;
}

- (id) init {
    return [self initWithModel:@"" modelDesc:@""];
}

@end
