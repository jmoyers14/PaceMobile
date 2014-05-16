//
//  PMMake.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMMake : NSObject
@property (nonatomic, strong, readonly) NSString *make;
@property (nonatomic, strong, readonly) NSString *makeDesc;

- (id) initWithMake:(NSString *)make makeDesc:(NSString *)makeDesc;

@end
