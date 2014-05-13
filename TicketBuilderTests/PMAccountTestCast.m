//
//  PMAccountTestCast.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/9/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMAccount.h"
@interface PMAccountTestCast : XCTestCase

@end

@implementation PMAccountTestCast

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
    NSString *name = @"BOOYAH";
    NSUInteger row = 1234;
    NSUInteger num = 4321;
    PMAccount *account = [[PMAccount alloc] initWithName:name row:row num:num];
    
    XCTAssertTrue([[account name] isEqualToString:name], @"names are not equal");
    XCTAssertTrue((row == [account acctRow]), @"account rows are not equal");
    XCTAssertTrue((num == [account anum]), @"account numbers are not equal");
}

- (void) testIsEqualToAccount {
    NSString *name = @"BOOYAH";
    NSUInteger row = 1234;
    NSUInteger num = 4321;
    PMAccount *account = [[PMAccount alloc] initWithName:name row:row num:num];
    
    XCTAssertTrue([account isEqualToAccount:account], @"account shoudl equal self");
}

- (void) testIsEqualToAccountFail {
    NSString *name = @"BOOYAH";
    NSUInteger row = 1234;
    NSUInteger num = 4321;
    PMAccount *account = [[PMAccount alloc] initWithName:name row:row num:num];
    PMAccount *account2 = [[PMAccount alloc] initWithName:@"HOOWAH" row:5 num:6];
    
    XCTAssertFalse([account isEqualToAccount:account2], @"accounts shoudl bot be equal");
}

- (void) testAddOrder {
    PMOrder *order = [[PMOrder alloc] initWithRow:1234 Date:@"12/14/15" orderNum:43221 comment:@"This order sucks"];
    PMAccount *account = [[PMAccount alloc] initWithName:@"Name" row:1 num:2];
    
    [account addOrder:order];
    
    XCTAssertTrue(([[account orders] count] == 1), @"order cound should be 1");
    XCTAssertTrue([[[account orders] objectAtIndex:0] isEqualToOrder:order], @"order should be order");
}


@end
