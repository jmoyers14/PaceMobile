//
//  PMOrder.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/9/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMOrder : NSObject

@property (nonatomic, readonly, assign) NSUInteger ordRow;
@property (nonatomic, readonly, strong) NSString *date;
@property (nonatomic, readonly, assign) NSUInteger ordNum;
@property (nonatomic, strong) NSString *comment;

- (id) initWithRow:(NSUInteger)row Date:(NSString *)date orderNum:(NSUInteger)ordNum comment:(NSString *)ordComment;
@end
