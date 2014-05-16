//
//  PMSubGroup.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMSubGroup : NSObject
@property (nonatomic, strong, readonly) NSString *subGroup;
@property (nonatomic, strong, readonly) NSString *subGroupDesc;

- (id) initWithSubGroup:(NSString *)subgroup subGroupDesc:(NSString *)subGroupDesc;

@end
