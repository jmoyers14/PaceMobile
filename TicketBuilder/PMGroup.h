//
//  PMGroup.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMGroup : NSObject
@property (nonatomic, strong, readonly) NSString *group;
@property (nonatomic, strong, readonly) NSString *groupDesc;

- (id) initWithGroup:(NSString *)group groupDesc:(NSString *)groupDesc;

@end
