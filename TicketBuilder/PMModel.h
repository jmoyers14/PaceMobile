//
//  PMModel.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMModel : NSObject
@property (nonatomic, strong, readonly) NSString *model;
@property (nonatomic, strong, readonly) NSString *modelDesc;

- (id) initWithModel:(NSString *)model modelDesc:(NSString *)modelDesc;

@end
