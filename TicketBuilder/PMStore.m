//
//  PMStore.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/2/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMStore.h"

@implementation PMStore
@synthesize name = _name;
@synthesize storeId = _storeId;
@synthesize accounts = _accounts;


NSUInteger _currentAccountIndex;

- (id) initWithName:(NSString *)name andID:(NSUInteger)storeId {
    self = [super init];
    if (self) {
        _name = name;
        _storeId = storeId;
        _currentAccountIndex = 0;
    }
    return self;
}

- (id) init {
    return [self initWithName:@"Unnamed Store" andID:0];
}

- (BOOL) isEqualToStore:(PMStore *)store {
    
    if([_name isEqualToString:[store name]] && (_storeId == [store storeId])) {
        return YES;
    }
    return NO;
}


- (void) setAccounts:(NSArray *)accounts {
    _accounts = accounts;
    _currentAccountIndex = 0;
}


- (void) setCurrentAccount:(PMAccount *)currentAccount {
    if ([_accounts containsObject:currentAccount]) {
        _currentAccountIndex = [_accounts indexOfObject:currentAccount];
    }
}


- (PMAccount *) currentAccount {
    if (_currentAccountIndex < [_accounts count]) {
        return [_accounts objectAtIndex:_currentAccountIndex];
    } else {
        NSLog(@"currentAccount index is out of bounds");
        return nil;
    }
}

@end
