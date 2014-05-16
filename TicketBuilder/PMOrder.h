//
//  PMOrder.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/9/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMItem.h"
@interface PMOrder : NSObject

@property (nonatomic, readonly, assign) NSUInteger ordRow;
@property (nonatomic, readonly, strong) NSString *date;
@property (nonatomic, readonly, assign) NSUInteger ordNum;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) PMItem *currentItem;

- (id) initWithRow:(NSUInteger)row Date:(NSString *)date orderNum:(NSUInteger)ordNum comment:(NSString *)ordComment;

- (BOOL) isEqualToOrder:(PMOrder *)order;
+ (NSArray *) dictionaryKeys;
@end
