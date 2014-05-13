//
//  PMItemTestCase.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/13/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMItem.h"
@interface PMItemTestCase : XCTestCase

@end

@implementation PMItemTestCase

- (void)setUp
{
    [super setUp];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testDesignatedInit {
    PMPart *part = [[PMPart alloc] initWithItemRow:1234 partRow:43221 line:11 part:@"EE1146"];
    PMItem *item = [[PMItem alloc] initWithPart:part quantity:10 transType:SaleTrans];
    
    XCTAssertTrue(([item transType] == SaleTrans), @"transType is sales trans");
    XCTAssertTrue(([item qty] == 10), @"quantity is 10");
    XCTAssertTrue(([[item part] isEqualToPart:part]), @"parts are not equal");
}

- (void) testIsItemEqual {
    PMPart *part = [[PMPart alloc] initWithItemRow:1234 partRow:43221 line:11 part:@"EE1146"];
    PMItem *item = [[PMItem alloc] initWithPart:part quantity:10 transType:SaleTrans];
    
    XCTAssertTrue([item isEqualToItem:item], @"item equals itself");
}


- (void) testIsItemEqualFalse {
    PMPart *part = [[PMPart alloc] initWithItemRow:1234 partRow:43221 line:11 part:@"EE1146"];
    PMItem *item = [[PMItem alloc] initWithPart:part quantity:10 transType:SaleTrans];
    PMItem *item2 = [[PMItem alloc] initWithPart:part quantity:9 transType:ReturnTrans];
    
    
    XCTAssertFalse([item isEqualToItem:item2], @"item equals item2");
}
@end
