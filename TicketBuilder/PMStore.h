//
//  PMStore.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/2/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMAccount.h"
@interface PMStore : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSUInteger storeId;
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) PMAccount *currentAccount;
- (id) initWithName:(NSString *)name andID:(NSUInteger)storeId;
- (BOOL) isEqualToStore:(PMStore *)store;
@end
