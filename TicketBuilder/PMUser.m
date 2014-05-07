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
//
// The users current store defaults to the store at index 0


#import "PMUser.h"

@implementation PMUser
@synthesize username    = _username;
@synthesize password    = _password;
@synthesize ip          = _ip;
@synthesize urlPort     = _urlPort;
@synthesize stores      = _stores;

static PMUser *myInstance = nil;
NSUInteger _currentStoreIndex;

+ (PMUser *) sharedInstance {
    if(!myInstance) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            myInstance = [[[self class] alloc] init];
            _currentStoreIndex = 0;
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

- (PMStore *) currentStore {
    if (_currentStoreIndex > [_stores count]) {
        return [_stores objectAtIndex:_currentStoreIndex];
    } else {
        NSLog(@"user has no stores");
        return nil;
    }
}

- (void) setCurrentStore:(PMStore *)currentStore {
    if([_stores containsObject:currentStore]) {
        _currentStoreIndex = [_stores indexOfObject:currentStore];
    } else {
        NSLog(@"Store %@ does not exist for user", [currentStore name]);
    }
}

- (void) setStores:(NSArray *)stores {
    _stores = stores;
    _currentStoreIndex = 0;
}


@end
