//
//  TBXMLBuilderTestCase.m
//  TicketBuilder
//
//  Created by Jeremy Moyers on 4/29/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMXMLBuilder.h"

@interface PMXMLBuilderTestCase : XCTestCase

@end

@implementation PMXMLBuilderTestCase
NSString *xmlHead = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
NSString *username;
NSString *password;

- (void)setUp
{
    [super setUp];
    username = @"username";
    password = @"password";

}

- (void)tearDown
{
    username = nil;
    password = nil;
    
    [super tearDown];
}

#pragma mark - Login

- (void) testLoginXML {
    NSString *xml = [PMXMLBuilder loginXMLWithUsername:@"test" andPassword:@"password"];
    NSString *xmlString = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><login><user>test</user><password>password</password></login>";
    XCTAssertTrue([xml isEqualToString:xmlString], @"XML should be equal");
}

- (void) testLoginXMLInvalidUser {
    NSString *xml = [PMXMLBuilder loginXMLWithUsername:@"" andPassword:@"password"];
    XCTAssertTrue((xml == nil), @"XML should return nil");
    
    xml = [PMXMLBuilder loginXMLWithUsername:nil andPassword:@"password"];
    XCTAssertTrue((xml == nil), @"XML shoudl return nil");
}

- (void) testLoginXMLInvalidPassword {
    NSString *xml = [PMXMLBuilder loginXMLWithUsername:@"test" andPassword:@""];
    XCTAssertTrue((xml == nil), @"XML chould be nil");
    xml = [PMXMLBuilder loginXMLWithUsername:@"test" andPassword:nil];
    XCTAssertTrue((xml == nil), @"XML chould be nil");
}



#pragma mark - findacct

- (void) testFindAcctXML {
    NSUInteger anum = 5;
    NSUInteger storeId = 1234;
    NSString *name = @"CRAZY GO NUTS AUTO";
    NSString *correctXML = [NSString stringWithFormat:
                           @"%@<findacct><user>%@</user><password>%@</password><storeId>%d</storeId><anum>%d</anum><name>%@</name></findacct>",xmlHead, username, password, storeId, anum, name];
    
    NSString *xml = [PMXMLBuilder findacctXMLWithUsername:username password:password storeID:storeId accountNumber:anum storeName:name];
    
    XCTAssertTrue([xml isEqualToString:correctXML], @"xml %@\n should qeual\n %@", xml, correctXML);
}

- (void) testFindAcctXMLAccountParams {
    NSUInteger anum = 0;
    NSUInteger storeId = 1234;
    NSString *name = @"";
    NSString *correctXML = nil;
    
    //Test store name empty
    NSString *xml = [PMXMLBuilder findacctXMLWithUsername:username password:password storeID:storeId accountNumber:anum storeName:name];
    XCTAssertTrue((xml == correctXML), @"findacct XML return nil with storeId 0 and storeName blank");
    
    //Test store name nil
    name = nil;
    xml = [PMXMLBuilder findacctXMLWithUsername:username password:password storeID:storeId accountNumber:anum storeName:name];
    XCTAssertTrue((xml == correctXML), @"findacct XML return nil with storeId 0 and storeName nil");
}

- (void) testFindAcctXLMblankName {
    NSUInteger anum = 5;
    NSUInteger storeId = 1234;
    NSString *name = @"";
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<findacct><user>%@</user><password>%@</password><storeId>%d</storeId><anum>%d</anum><name>%@</name></findacct>", xmlHead, username, password, storeId, anum, name];
    
    //Test name empty
    NSString *xml = [PMXMLBuilder findacctXMLWithUsername:username password:password storeID:storeId accountNumber:anum storeName:name];
    XCTAssertTrue([xml isEqualToString:correctXML], @"findacct XML should be correct format");
    
    //Test name nil
    name = nil;
    xml = [PMXMLBuilder findacctXMLWithUsername:username password:password storeID:storeId accountNumber:anum storeName:name];
    correctXML = [NSString stringWithFormat:
                            @"%@<findacct><user>%@</user><password>%@</password><storeId>%d</storeId><anum>%d</anum><name></name></findacct>", xmlHead, username, password, storeId, anum];
    XCTAssertTrue([xml isEqualToString:correctXML],@"xml %@\n should qeual\n %@", xml, correctXML);
}


#pragma mark - confcust

- (void) testCheckCustXML {
    NSUInteger storeID = 5;
    NSUInteger anum = 1234;
    NSUInteger cnum = 13;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<checkcust><user>%@</user><password>%@</password><storeId>%d</storeId><anum>%d</anum><cnum>%d</cnum></checkcust>", xmlHead, username, password, storeID, anum, cnum];
    
    NSString *xml = [PMXMLBuilder checkcustXMLWithUsername:username password:password storeID:storeID accountNumber:anum customerNumber:cnum];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"check cust xml shoudl equal correct format");
}

- (void) testCheckCustXMLNoCustomer {
    NSUInteger storeID = 5;
    NSUInteger anum = 1234;
    NSUInteger cnum = 0;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<checkcust><user>%@</user><password>%@</password><storeId>%d</storeId><anum>%d</anum><cnum></cnum></checkcust>", xmlHead, username, password, storeID, anum];
    
    NSString *xml = [PMXMLBuilder checkcustXMLWithUsername:username password:password storeID:storeID accountNumber:anum customerNumber:cnum];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"cnum 0, return blank cnum tag");
}

#pragma mark - confacct

- (void) testConfAcctXML {
    NSUInteger acctRow = 5;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<confacct><user>%@</user><password>%@</password><acctRow>%d</acctRow></confacct>", xmlHead, username, password, acctRow];
    
    NSString *xml = [PMXMLBuilder confacctXMLWithUsername:username password:password accountRow:acctRow];
    
    XCTAssertTrue([xml isEqualToString:correctXML], @"confacct xml with all parameters");
}

#pragma mark - confcust

- (void) testConfCustXML {
    NSUInteger custRow = 5;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<confcust><user>%@</user><password>%@</password><custRow>%d</custRow></confcust>", xmlHead, username, password, custRow];
    
    NSString *xml = [PMXMLBuilder confcustXMLWithUsername:username password:password customerRow:custRow];
    
    XCTAssertTrue([xml isEqualToString:correctXML], @"confCust with all correct params");
}

#pragma mark - findpart
- (void) testFindPartXML {
    NSUInteger acctRow = 1243;
    NSUInteger line = 134;
    NSUInteger part = 88765;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<user>%@</user><password>%@</password><acctRow>%d</acctRow><line>%d</line><part>%d</part>", xmlHead, username, password, acctRow, line, part];
    
    NSString *xml = [PMXMLBuilder findpartXMLWithUsername:username password:password accountRow:acctRow lineNumber:line partNumber:part];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

- (void) testFindPartXMLBlankAccount {
    NSUInteger acctRow = 0;
    NSUInteger line = 134;
    NSUInteger part = 88765;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<user>%@</user><password>%@</password><acctRow></acctRow><line>%d</line><part>%d</part>", xmlHead, username, password, line, part];
    
    NSString *xml = [PMXMLBuilder findpartXMLWithUsername:username password:password accountRow:acctRow lineNumber:line partNumber:part];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

- (void) testFindPartXMLBlankLine {
    NSUInteger acctRow = 1243;
    NSUInteger line = 0;
    NSUInteger part = 88765;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<user>%@</user><password>%@</password><acctRow>%d</acctRow><line></line><part>%d</part>", xmlHead, username, password, acctRow, part];
    
    NSString *xml = [PMXMLBuilder findpartXMLWithUsername:username password:password accountRow:acctRow lineNumber:line partNumber:part];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

#pragma mark - inqpart
- (void) testInqPartXML {
    NSUInteger acctRow = 1234;
    NSUInteger partRow = 4321;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<user>%@</user><password>%@</password><acctRow>%d</acctRow><part>%d</part>", xmlHead, username, password, acctRow, partRow];
    
    NSString *xml = [PMXMLBuilder inqpartXMLWithUsername:username password:password accountRow:acctRow partRow:partRow];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

#pragma mark - checkord
- (void) checkOrdXML {
    NSUInteger acctRow = 1234;
    NSUInteger custRow = 4321;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<user>%@</user><password>%@</password><acctRow>%d</acctRow><custRow>%d</custRow>", xmlHead, username, password, acctRow, custRow];
    
    NSString *xml = [PMXMLBuilder checkordXMLWithUsername:username password:password accountRow:acctRow customerRow:custRow];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

- (void) checkOrdXMLBlankCustRow {
    NSUInteger acctRow = 1234;
    NSUInteger custRow = 0;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<user>%@</user><password>%@</password><acctRow>%d</acctRow><custRow></custRow>", xmlHead, username, password, acctRow];
    
    NSString *xml = [PMXMLBuilder checkordXMLWithUsername:username password:password accountRow:acctRow customerRow:custRow];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

#pragma mark - createord
- (void) createOrderXML {
    NSUInteger acctRow = 1234;
    NSUInteger custRow = 4321;
    NSString *ordComment = @"This is a comment";
    NSUInteger custPoNum = 8776543;
    NSArray *shipText = [NSArray arrayWithObjects:@"1134 old town rd", @"San Diego", @"Ca 93401", @"Another line", @"Another line 2", nil];
    NSArray *messageText = [NSArray arrayWithObjects:@"message1", @"message2", @"message3", @"message4", @"message5", @"message6", nil];
    
    NSString *correctXML = [NSString stringWithFormat:@"%@<user>%@</user><password>%@</password><acctRow>%d</acctRow><custRow>%d</custRow><ordComment>%@</ordComment><custPoNum>%d</custPoNum><shipInfo><shipText>%@</shipText><shipText>%@</shipText><shipText>%@</shipText><shipText>%@</shipText></shipInfo><messageInfo><messageText>%@</messageText><messageText>%@</messageText><messageText>%@</messageText><messageText>%@</messageText><messageText>%@</messageText><messageText>%@</messageText></messageInfo>", xmlHead, username, password, acctRow, custRow, ordComment, custPoNum, [shipText objectAtIndex:0], [shipText objectAtIndex:1], [shipText objectAtIndex:2], [shipText objectAtIndex:3], [messageText objectAtIndex:0], [messageText objectAtIndex:1], [messageText objectAtIndex:2], [messageText objectAtIndex:3], [messageText objectAtIndex:4], [messageText objectAtIndex:5]];
    
    NSString *xml = [PMXMLBuilder createordXMLWithUsername:username password:password accountRow:acctRow customerRow:custRow orderComment:ordComment customerPONumber:custPoNum shipText:shipText messageText:messageText];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

@end
