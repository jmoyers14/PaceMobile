//
//  PMPartType.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/16/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMPartType : NSObject
@property (nonatomic, strong, readonly) NSString *typeCode;
@property (nonatomic, strong, readonly) NSString *description;
@property (nonatomic, strong, readonly) NSArray *parts;

- (id) initWithCode:(NSString *)code description:(NSString *)description parts:(NSArray *)parts;

@end
