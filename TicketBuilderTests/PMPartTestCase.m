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
    smallPart = [[PMPart alloc] initWithItemRow:123 partRow:1234 line:4321 part:@"EFT112"];
    bigPart = [[PMPart alloc] initWithItemRow:1234
                                      partRow:4321
                                         line:5432
                                         part:@"ETGG54"
                                  description:@"a good part"
                               longDesciption:@"A good part for the car that you have"
                                        manuf:@"Suq Madiq"
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
    XCTAssertTrue(([smallPart itemRow] == 123), @"item row not equal");
    XCTAssertTrue(([smallPart partRow] == 1234), @"part row not equal");
    XCTAssertTrue(([smallPart line] == 4321), @"line not equal");
    XCTAssertTrue([[smallPart part] isEqualToString:@"EFT112"], @"part not equal");
}

- (void) testIsEqualToPart {
    XCTAssertTrue([smallPart isEqualToPart:smallPart], @"part not equal to aprt");
    XCTAssertTrue([bigPart isEqualToPart:bigPart], @"big parts not eqaul");
}

- (void) testIsEqualToPartFail {
    PMPart *badpart = [[PMPart alloc] initWithItemRow:43 partRow:33 line:222 part:@"MMDDEF33"];
    XCTAssertFalse([badpart isEqualToPart:smallPart], @"parts are equal");
}

@end
