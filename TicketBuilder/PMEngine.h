//
//  PMEngine.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMEngine : NSObject
@property (nonatomic, strong, readonly) NSString *vid;
@property (nonatomic, strong, readonly) NSString *engineDesc;

- (id) initWithVid:(NSString *)vid engineDesc:(NSString *)engineDesc;

@end
