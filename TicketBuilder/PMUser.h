//
//  PMUserManager.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/1/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMAccount.h"
#import "PMStore.h"

@interface PMUser : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *urlPort;
@property (nonatomic, readonly, strong) NSString *url;
@property (nonatomic, strong) NSArray *stores;
@property (nonatomic, strong) PMStore *currentStore;

+ (id) sharedInstance;
+ (BOOL) sharedInstanceExists;
@end
