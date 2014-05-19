//
//  PMPartTestCase.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/13/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMPart.h"

@interface PMPartTestCase : XCTestCase {
    PMPart *smallPart;
    PMPart *bigPart;
}

@end

@implementation PMPartTestCase

- (void)setUp
{
    [super setUp];
    smallPart = [[PMPart alloc] initWithPartRow:1234 line:@"DUP" part:@"EFT112"];
    bigPart = [[PMPart alloc] initWithPartRow:4321
                                         line:@"DUP"
                                         part:@"ETGG54"
                                  description:@"a good part"
                               longDesciption:@"A good part for the car that you have"
                                        manuf:@"Suq Madiq"
                                         list:1
                                        price:[NSDecimalNumber decimalNumberWithString:@"55.55"]
                                         core:[NSDecimalNumber decimalNumberWithString:@"23.52"]
                                      instock:20];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testDesignatedInit {
    XCTAssertTrue(([smallPart partRow] == 1234), @"part row not equal");
    XCTAssertTrue(([[smallPart line] isEqualToString:@"DUP"]), @"line not equal");
    XCTAssertTrue([[smallPart part] isEqualToString:@"EFT112"], @"part not equal");
}

- (void) testIsEqualToPart {
    XCTAssertTrue([smallPart isEqualToPart:smallPart], @"part not equal to aprt");
    XCTAssertTrue([bigPart isEqualToPart:bigPart], @"big parts not eqaul");
}

- (void) testIsEqualToPartFail {
    PMPart *badpart = [[PMPart alloc] initWithPartRow:33 line:@"DUP" part:@"MMDDEF33"];
    XCTAssertFalse([badpart isEqualToPart:smallPart], @"parts are equal");
}

@end
