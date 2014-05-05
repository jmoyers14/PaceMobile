//
//  PMNetworkTestCase.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/3/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PMNetworkTestCase : XCTestCase

@end

@implementation PMNetworkTestCase

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

- (void)testParseLoginReplyFiveStores {
    NSString *error = @"00";
    NSUInteger storeCnt = 5;
    
    NSString *store1Name = @"Store One";
    NSUInteger storeId1 = 1;
    
    NSString *store2Name = @"Store Two";
    NSUInteger storeId2 = 2;
    
    NSString *store3Name = @"Store Three";
    NSUInteger storeId3 = 3;
    
    NSString *store4Name = @"Store Four";
    NSUInteger storeId4 = 4;
    
    NSString *store5Name = @"Store Five";
    NSUInteger storeId5 = 5;
    

    
    

    
    
}

@end
