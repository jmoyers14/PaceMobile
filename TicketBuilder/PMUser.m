//
//  PMUserManager.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/1/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

//
// The PMUser class represents the bluesage customer who uses PaceMobile
//
// The PMUser class is implemented as a singleton meaning it can only be created
// once throughout the lifetime of the application

#import "PMUser.h"

@implementation PMUser
@synthesize username = _username;
@synthesize password = _password;
@synthesize storeNum = _storeNum;
@synthesize currAccount = _currAccount;
@synthesize ip = _ip;
@synthesize urlPort = _urlPort;

static PMUser *myInstance = nil;

+ (PMUser *) sharedInstance {
    if(!myInstance) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            myInstance = [[[self class] alloc] init];
        });
    }
    return myInstance;
}

+ (BOOL) sharedInstanceExists {
    return (nil != myInstance);
}

- (NSString *) url {
    if([_ip length] > 0 && [_urlPort length] > 0) {
        return [NSString stringWithFormat:@"%@:%@", _ip, _urlPort];
    } else {
        return nil;
    }
}




@end
