//
//  PMOrderTestCase.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/9/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMOrder.h"
@interface PMOrderTestCase : XCTestCase {
    PMOrder *order;
}

@end

@implementation PMOrderTestCase

- (void)setUp
{
    [super setUp];
    order = [[PMOrder alloc] initWithRow:123 Date:@"12/12/12" orderNum:4321 comment:@"This order has a comment"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testInit {
    XCTAssertTrue([[order date] isEqualToString:@"12/12/12"], @"dates are equal");
    XCTAssertTrue(([order ordRow] == 123), @"order rows are not equal");
    XCTAssertTrue(([order ordNum] == 4321), @"order nums are not equal");
    XCTAssertTrue([[order comment] isEqualToString:@"This order has a comment"], @"Order comments do not match");
}

- (void) testIsEqualToOrder {
    XCTAssertTrue([order isEqualToOrder:order], @"orders are not equal");
}

- (void) testIsEqualToOrderFail {
    PMOrder *order1 = [[PMOrder alloc] initWithRow:1235 Date:@"12/34/12" orderNum:123 comment:@"This comment is bad"];
    XCTAssertFalse([order isEqualToOrder:order1], @"the orders are equal");
}

@end
