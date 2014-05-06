//
//  PMStoreTestCase.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/5/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMStore.h"
@interface PMStoreTestCase : XCTestCase

@end

@implementation PMStoreTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInit {
    PMStore *store = [[PMStore alloc] initWithName:@"myStore" andID:55];
    
    XCTAssertTrue([[store name] isEqualToString:@"myStore"], @"%@ should equal store name: %@", @"myStore", [store name]);
    XCTAssertTrue(([store storeId] == 55), @"%d should equal storeId: %lu", 55, (unsigned long)[store storeId]);
}

- (void) testIsEqualEqual {
    PMStore *store1 = [[PMStore alloc] initWithName:@"store" andID:1];
    PMStore *store2 = [[PMStore alloc] initWithName:@"store" andID:1];
    
    XCTAssertTrue([store1 isEqualToStore:store2], @"store1 should equal store2");
    XCTAssertTrue([store2 isEqualToStore:store1], @"store2 should equal store1");
}

- (void) testIsEqualNotEqual {
    PMStore *store1 = [[PMStore alloc] initWithName:@"notstore" andID:1];
    PMStore *store2 = [[PMStore alloc] initWithName:@"store" andID:1];
    
    XCTAssertFalse([store1 isEqualToStore:store2], @"store1 should not equal store2");
    XCTAssertFalse([store2 isEqualToStore:store1], @"store2 should not equal store1");
}

@end
