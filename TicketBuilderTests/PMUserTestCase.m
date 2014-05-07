//
//  PMUserTestCase.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/7/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMUser.h"
@interface PMUserTestCase : XCTestCase

@end

@implementation PMUserTestCase
PMUser *user;

- (void)setUp
{
    [super setUp];
    user = [PMUser sharedInstance];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    user = nil;
    [super tearDown];
}

- (void) testURL {
    NSString *ip = @"255.255.255.255";
    NSString *port = @"8081";
    [user setIp:ip];
    [user setUrlPort:port];
    
    XCTAssertTrue(([[user url] isEqualToString:[NSString stringWithFormat:@"%@:%@", ip, port]]), @"user url %@ should equal correct url", [user url]);
}

- (void) testCurerntStore {
    PMStore *curStore = [user currentStore];
    XCTAssertTrue((curStore == nil), @"curStore should equal nil");
}


- (void) testSetCurrentNoStores {
    PMStore *curStore = [[PMStore alloc] initWithName:@"temp" andID:1];
    [user setCurrentStore:curStore];
    PMStore *current = [user currentStore];
    XCTAssertTrue((current == nil), @"current store should still be nil");
}

- (void) testSetStores {
    NSMutableArray *stores = [[NSMutableArray alloc] init];
    for(int i = 0; i < 5; i++) {
        NSString *name = [NSString stringWithFormat:@"Store%d", i];
        NSUInteger storeId = i;
        [stores addObject:[[PMStore alloc] initWithName:name andID:storeId]];
    }
    
    [user setStores:stores];
    NSArray *uStores = user.stores;
    for(int i = 0; i < 5; i++) {
        PMStore *uStore = [uStores objectAtIndex:i];
        PMStore *mStore = [stores objectAtIndex:i];
        
        XCTAssertTrue([uStore isEqualToStore:mStore], @"store at index %d is not equal", i);
    }
    
}

- (void) testSetCurrentStore {
    NSMutableArray *stores = [[NSMutableArray alloc] init];
    for(int i = 0; i < 5; i++) {
        NSString *name = [NSString stringWithFormat:@"Store%d", i];
        NSUInteger storeId = i;
        [stores addObject:[[PMStore alloc] initWithName:name andID:storeId]];
    }
    [user setStores:stores];

    [user setCurrentStore:[stores objectAtIndex:3]];
    
    XCTAssertTrue([[user currentStore] isEqualToStore:[stores objectAtIndex:3]], @"curent store should be qual to get current store");
}


- (void) testSetCurrentStoreOutOfBounds {
    NSMutableArray *stores = [[NSMutableArray alloc] init];
    for(int i = 0; i < 5; i++) {
        NSString *name = [NSString stringWithFormat:@"Store%d", i];
        NSUInteger storeId = i;
        [stores addObject:[[PMStore alloc] initWithName:name andID:storeId]];
    }
    [user setStores:stores];
    
    PMStore *outsider = [[PMStore alloc] initWithName:@"loser" andID:100];
    
    [user setCurrentStore:outsider];
    
    XCTAssertTrue([[user currentStore] isEqualToStore:[stores objectAtIndex:0]], @"curentstore not set default to store at index 0");
}


@end
