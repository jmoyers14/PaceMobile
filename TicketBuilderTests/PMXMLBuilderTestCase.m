//
//  TBXMLBuilderTestCase.m
//  TicketBuilder
//
//  Created by Jeremy Moyers on 4/29/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMXMLBuilder.h"
#import <XCTest/XCTest.h>

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
                            @"%@<findacct><user>%@</user><password>%@</password><storeId>%lu</storeId><anum>%lu</anum><name>%@</name></findacct>",xmlHead, username, password, (unsigned long)storeId, (unsigned long)anum, name];
    
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
                            @"%@<findacct><user>%@</user><password>%@</password><storeId>%lu</storeId><anum>%lu</anum><name>%@</name></findacct>", xmlHead, username, password, (unsigned long)storeId, (unsigned long)anum, name];
    
    //Test name empty
    NSString *xml = [PMXMLBuilder findacctXMLWithUsername:username password:password storeID:storeId accountNumber:anum storeName:name];
    XCTAssertTrue([xml isEqualToString:correctXML], @"findacct XML should be correct format");
    
    //Test name nil
    name = nil;
    xml = [PMXMLBuilder findacctXMLWithUsername:username password:password storeID:storeId accountNumber:anum storeName:name];
    correctXML = [NSString stringWithFormat:
                  @"%@<findacct><user>%@</user><password>%@</password><storeId>%lu</storeId><anum>%lu</anum><name></name></findacct>", xmlHead, username, password, (unsigned long)storeId, (unsigned long)anum];
    XCTAssertTrue([xml isEqualToString:correctXML],@"xml %@\n should qeual\n %@", xml, correctXML);
}


#pragma mark - confcust

- (void) testCheckCustXML {
    NSUInteger storeID = 5;
    NSUInteger anum = 1234;
    NSUInteger cnum = 13;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<checkcust><user>%@</user><password>%@</password><storeId>%lu</storeId><anum>%lu</anum><cnum>%lu</cnum></checkcust>", xmlHead, username, password, (unsigned long)storeID, (unsigned long)anum, (unsigned long)cnum];
    
    NSString *xml = [PMXMLBuilder checkcustXMLWithUsername:username password:password storeID:storeID accountNumber:anum customerNumber:cnum];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"check cust xml shoudl equal correct format");
}

- (void) testCheckCustXMLNoCustomer {
    NSUInteger storeID = 5;
    NSUInteger anum = 1234;
    NSUInteger cnum = 0;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<checkcust><user>%@</user><password>%@</password><storeId>%lu</storeId><anum>%lu</anum><cnum></cnum></checkcust>", xmlHead, username, password, (unsigned long)storeID, (unsigned long)anum];
    
    NSString *xml = [PMXMLBuilder checkcustXMLWithUsername:username password:password storeID:storeID accountNumber:anum customerNumber:cnum];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"cnum 0, return blank cnum tag");
}

#pragma mark - confacct

- (void) testConfAcctXML {
    NSUInteger acctRow = 5;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<confacct><user>%@</user><password>%@</password><acctRow>%lu</acctRow></confacct>", xmlHead, username, password, (unsigned long)acctRow];
    
    NSString *xml = [PMXMLBuilder confacctXMLWithUsername:username password:password accountRow:acctRow];
    
    XCTAssertTrue([xml isEqualToString:correctXML], @"confacct xml with all parameters");
}

#pragma mark - confcust

- (void) testConfCustXML {
    NSUInteger custRow = 5;
    
    NSString *correctXML = [NSString stringWithFormat:
                            @"%@<confcust><user>%@</user><password>%@</password><custRow>%lu</custRow></confcust>", xmlHead, username, password, (unsigned long)custRow];
    
    NSString *xml = [PMXMLBuilder confcustXMLWithUsername:username password:password customerRow:custRow];
    
    XCTAssertTrue([xml isEqualToString:correctXML], @"confCust with all correct params");
}

#pragma mark - findpart
- (void) testFindPartXML {
    NSUInteger acctRow = 1243;
    NSString *line = @"DOW";
    NSString *part = @"44532";
    
    id<XMLStreamWriter> xmlWriter = [[XMLWriter alloc] init];
    
    [xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [xmlWriter writeStartElement:@"findpart"];
    [xmlWriter writeStartElement:@"user"];
    [xmlWriter writeCharacters:username];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"password"];
    [xmlWriter writeCharacters:password];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"acctRow"];
    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)acctRow]];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"line"];
    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@", line]];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"part"];
    [xmlWriter writeCharacters:@"44532"];
    [xmlWriter writeEndElement];
    [xmlWriter writeEndElement];
    [xmlWriter writeEndDocument];
    
    
    
    NSString *correctXML = [xmlWriter toString];
    
    NSString *xml = [PMXMLBuilder findpartXMLWithUsername:username password:password accountRow:acctRow lineNumber:line partNumber:part];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

- (void) testFindPartXMLBlankAccount {
    NSUInteger acctRow = 0;
    NSString *line = @"ROW";
    NSString *part = @"55e5";
    
    id<XMLStreamWriter> xmlWriter = [[XMLWriter alloc] init];
    
    [xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [xmlWriter writeStartElement:@"findpart"];
    [xmlWriter writeStartElement:@"user"];
    [xmlWriter writeCharacters:username];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"password"];
    [xmlWriter writeCharacters:password];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"acctRow"];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"line"];
    [xmlWriter writeCharacters:line];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"part"];
    [xmlWriter writeCharacters:part];
    [xmlWriter writeEndElement];
    [xmlWriter writeEndElement];
    [xmlWriter writeEndDocument];
    
    NSString *correctXML = [xmlWriter toString];
    
    NSString *xml = [PMXMLBuilder findpartXMLWithUsername:username password:password accountRow:acctRow lineNumber:line partNumber:part];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

- (void) testFindPartXMLBlankLine {
    NSUInteger acctRow = 1243;
    //NSString *line = @"ROW";
    NSString *part = @"55e5";
    
    id<XMLStreamWriter> xmlWriter = [[XMLWriter alloc] init];
    
    [xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [xmlWriter writeStartElement:@"findpart"];
    [xmlWriter writeStartElement:@"user"];
    [xmlWriter writeCharacters:username];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"password"];
    [xmlWriter writeCharacters:password];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"acctRow"];
    [xmlWriter writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)acctRow]];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"line"];
    [xmlWriter writeEndElement];
    [xmlWriter writeStartElement:@"part"];
    [xmlWriter writeCharacters:part];
    [xmlWriter writeEndElement];
    [xmlWriter writeEndElement];
    [xmlWriter writeEndDocument];
    
    NSString *correctXML = [xmlWriter toString];
    
    NSString *xml = [PMXMLBuilder findpartXMLWithUsername:username password:password accountRow:acctRow lineNumber:nil partNumber:part];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

#pragma mark - inqpart
- (void) testInqPartXML {
    NSUInteger acctRow = 1234;
    NSUInteger partRow = 4321;
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    
    [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [writer writeStartElement:@"inqpart"];
    [writer writeStartElement:@"user"];
    [writer writeCharacters:username];
    [writer writeEndElement];
    [writer writeStartElement:@"password"];
    [writer writeCharacters:password];
    [writer writeEndElement];
    [writer writeStartElement:@"acctRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)acctRow]];
    [writer writeEndElement];
    [writer writeStartElement:@"partRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)partRow]];
    [writer writeEndElement];
    [writer writeEndElement];
    [writer writeEndDocument];
    
    NSString *correctXML = [writer toString];
    NSString *xml = [PMXMLBuilder inqpartXMLWithUsername:username password:password accountRow:acctRow partRow:partRow];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

#pragma mark - checkord
- (void) testCheckOrdXML {
    NSUInteger acctRow = 1234;
    NSUInteger custRow = 4321;
    
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [writer writeStartElement:@"checkord"];
    [writer writeStartElement:@"user"];
    [writer writeCharacters:username];
    [writer writeEndElement];
    [writer writeStartElement:@"password"];
    [writer writeCharacters:password];
    [writer writeEndElement];
    [writer writeStartElement:@"acctRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long) acctRow]];
    [writer writeEndElement];
    [writer writeStartElement:@"custRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long) custRow]];
    [writer writeEndElement];
    [writer writeEndElement];
    [writer writeEndDocument];
    
    
    NSString *correctXML = [writer toString];
    
    NSString *xml = [PMXMLBuilder checkordXMLWithUsername:username password:password accountRow:acctRow customerRow:custRow];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

- (void) testCheckOrdXMLBlankCustRow {
    NSUInteger acctRow = 1234;
    NSUInteger custRow = 0;
    
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [writer writeStartElement:@"checkord"];
    [writer writeStartElement:@"user"];
    [writer writeCharacters:username];
    [writer writeEndElement];
    [writer writeStartElement:@"password"];
    [writer writeCharacters:password];
    [writer writeEndElement];
    [writer writeStartElement:@"acctRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long) acctRow]];
    [writer writeEndElement];
    [writer writeStartElement:@"custRow"];
    [writer writeEndElement];
    [writer writeEndElement];
    [writer writeEndDocument];
    
    
    NSString *correctXML = [writer toString];
    
    NSString *xml = [PMXMLBuilder checkordXMLWithUsername:username password:password accountRow:acctRow customerRow:custRow];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

#pragma mark - createord
- (void) testCreateOrderXML {
    NSUInteger acctRow = 1234;
    NSUInteger custRow = 4321;
    NSString *ordComment = @"This is a comment";
    NSUInteger custPoNum = 8776543;
    NSArray *shipText = [NSArray arrayWithObjects:@"1134 old town rd", @"San Diego", @"Ca 93401", @"Another line", @"Another line 2", nil];
    NSArray *messageText = [NSArray arrayWithObjects:@"message1", @"message2", @"message3", @"message4", @"message5", @"message6", nil];
    
    
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [writer writeStartElement:@"createord"];
    
    [writer writeStartElement:@"user"];
    [writer writeCharacters:username];
    [writer writeEndElement];
    [writer writeStartElement:@"password"];
    [writer writeCharacters:password];
    [writer writeEndElement];
    [writer writeStartElement:@"acctRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long) acctRow]];
    [writer writeEndElement];
    [writer writeStartElement:@"custRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long) custRow]];
    [writer writeEndElement];
    [writer writeStartElement:@"ordComment"];
    [writer writeCharacters:ordComment];
    [writer writeEndElement];
    [writer writeStartElement:@"custPoNum"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)custPoNum]];
    [writer writeEndElement];
    [writer writeStartElement:@"shipInfo"];
    for(NSString *s in shipText) {
        [writer writeStartElement:@"shipText"];
        [writer writeCharacters:s];
        [writer writeEndElement];
    }
    [writer writeEndElement];
    [writer writeStartElement:@"messageInfo"];
    for(NSString *s in messageText) {
        [writer writeStartElement:@"messageText"];
        [writer writeCharacters:s];
        [writer writeEndElement];
    }
    [writer writeEndElement];
    [writer writeEndElement];
    [writer writeEndDocument];
    
    NSString *correctXML = [writer toString];
    
    NSString *xml = [PMXMLBuilder createordXMLWithUsername:username password:password accountRow:acctRow customerRow:custRow orderComment:ordComment customerPONumber:custPoNum shipText:shipText messageText:messageText];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

- (void) testCreatOrdXMLOutOfBounds {
    NSUInteger acctRow = 1234;
    NSUInteger custRow = 4321;
    NSString *ordComment = @"This is a comment";
    NSUInteger custPoNum = 8776543;
    NSArray *messageText = [NSArray arrayWithObjects:@"message1", @"message2", @"message3", @"message4", @"message5", @"message6", nil];
    NSMutableArray *shipText = [[NSMutableArray alloc] init];
    for(int i = 0; i < 15; i++) {
        [shipText addObject:[NSString stringWithFormat:@"Line%d", i]];
    }
    
    NSString *xml = [PMXMLBuilder createordXMLWithUsername:username password:password accountRow:acctRow customerRow:custRow orderComment:ordComment customerPONumber:custPoNum shipText:shipText messageText:messageText];
    
    XCTAssertTrue((xml == nil), @"createord out of bounds should return nil");
}

- (void) testCreateOrderXMLNoArrays {
    NSUInteger acctRow = 1234;
    NSUInteger custRow = 4321;
    NSString *ordComment = @"This is a comment";
    NSUInteger custPoNum = 8776543;

    
    
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [writer writeStartElement:@"createord"];
    
    [writer writeStartElement:@"user"];
    [writer writeCharacters:username];
    [writer writeEndElement];
    [writer writeStartElement:@"password"];
    [writer writeCharacters:password];
    [writer writeEndElement];
    [writer writeStartElement:@"acctRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long) acctRow]];
    [writer writeEndElement];
    [writer writeStartElement:@"custRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long) custRow]];
    [writer writeEndElement];
    [writer writeStartElement:@"ordComment"];
    [writer writeCharacters:ordComment];
    [writer writeEndElement];
    [writer writeStartElement:@"custPoNum"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)custPoNum]];
    [writer writeEndElement];
    [writer writeStartElement:@"shipInfo"];
    [writer writeEndElement];
    [writer writeStartElement:@"messageInfo"];
    [writer writeEndElement];
    [writer writeEndElement];
    [writer writeEndDocument];
    
    NSString *correctXML = [writer toString];
    
    NSString *xml = [PMXMLBuilder createordXMLWithUsername:username password:password accountRow:acctRow customerRow:custRow orderComment:ordComment customerPONumber:custPoNum shipText:nil messageText:nil];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}

- (void) testCreateOrderXMLNoComment {
    NSUInteger acctRow = 1234;
    NSUInteger custRow = 4321;
    NSUInteger custPoNum = 8776543;
    
    
    
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [writer writeStartElement:@"createord"];
    
    [writer writeStartElement:@"user"];
    [writer writeCharacters:username];
    [writer writeEndElement];
    [writer writeStartElement:@"password"];
    [writer writeCharacters:password];
    [writer writeEndElement];
    [writer writeStartElement:@"acctRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long) acctRow]];
    [writer writeEndElement];
    [writer writeStartElement:@"custRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long) custRow]];
    [writer writeEndElement];
    [writer writeStartElement:@"ordComment"];
    [writer writeEndElement];
    [writer writeStartElement:@"custPoNum"];
    [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)custPoNum]];
    [writer writeEndElement];
    [writer writeStartElement:@"shipInfo"];
    [writer writeEndElement];
    [writer writeStartElement:@"messageInfo"];
    [writer writeEndElement];
    [writer writeEndElement];
    [writer writeEndDocument];
    
    NSString *correctXML = [writer toString];
    
    NSString *xml = [PMXMLBuilder createordXMLWithUsername:username password:password accountRow:acctRow customerRow:custRow orderComment:nil customerPONumber:custPoNum shipText:nil messageText:nil];
    
    XCTAssertTrue([correctXML isEqualToString:xml], @"xml:%@ shoudl equal correctxml: %@", xml,correctXML);
}


#pragma mark -delete ord
- (void) testDeleteOrdXML {

    NSNumber *ordRow = [NSNumber numberWithInteger:1234];
    
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [writer writeStartElement:@"deleteord"];
    [writer writeStartElement:@"user"];
    [writer writeCharacters:username];
    [writer writeEndElement];
    [writer writeStartElement:@"password"];
    [writer writeCharacters:password];
    [writer writeEndElement];
    [writer writeStartElement:@"ordRow"];
    [writer writeCharacters:[NSString stringWithFormat:@"%@", ordRow]];
    [writer writeEndElement];
    [writer writeEndDocument];
    
    NSString *xml = [PMXMLBuilder deleteordXMLWithUsername:username password:password orderRow:[ordRow integerValue]];
    
    XCTAssertTrue([xml isEqualToString:[writer toString]], @"response xml %@ does not equal xml %@", xml, [writer toString]);
}

#pragma mark - additem
- (void) testAddItemSaleXML {
    
    NSNumber *acctRow = [NSNumber numberWithInteger:1234];
    NSNumber *ordRow  = [NSNumber numberWithInteger:4321];
    NSNumber *partRow = [NSNumber numberWithInteger:5678];
    NSNumber *qty     = [NSNumber numberWithInteger:876];
    
    
    id<XMLStreamWriter> cwriter = [[XMLWriter alloc] init];
    
    [cwriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cwriter writeStartElement:@"additem"];
    [cwriter writeStartElement:@"user"];
    [cwriter writeCharacters:username];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"password"];
    [cwriter writeCharacters:password];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"acctRow"];
    [cwriter writeCharacters:[acctRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"ordRow"];
    [cwriter writeCharacters:[ordRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"partRow"];
    [cwriter writeCharacters:[partRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"qty"];
    [cwriter writeCharacters:[qty stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"tranType"];
    [cwriter writeCharacters:@"S"];
    [cwriter writeEndElement];
    [cwriter writeEndElement];
    [cwriter writeEndDocument];
    
    NSString *xml = [PMXMLBuilder additemXMLWithUsername:username password:password accountRow:[acctRow integerValue] orderRow:[ordRow integerValue] partRow:[partRow integerValue] quantity:[qty integerValue] tranType:SaleTrans];
    
    XCTAssertTrue([xml isEqualToString:[cwriter toString]], @"response xml %@ does not equal xml %@", xml, [cwriter toString]);
}

- (void) testAddItemReturnXML {
    
    NSNumber *acctRow = [NSNumber numberWithInteger:1234];
    NSNumber *ordRow  = [NSNumber numberWithInteger:4321];
    NSNumber *partRow = [NSNumber numberWithInteger:5678];
    NSNumber *qty     = [NSNumber numberWithInteger:876];
    
    id<XMLStreamWriter> cwriter = [[XMLWriter alloc] init];
    
    [cwriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cwriter writeStartElement:@"additem"];
    [cwriter writeStartElement:@"user"];
    [cwriter writeCharacters:username];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"password"];
    [cwriter writeCharacters:password];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"acctRow"];
    [cwriter writeCharacters:[acctRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"ordRow"];
    [cwriter writeCharacters:[ordRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"partRow"];
    [cwriter writeCharacters:[partRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"qty"];
    [cwriter writeCharacters:[qty stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"tranType"];
    [cwriter writeCharacters:@"R"];
    [cwriter writeEndElement];
    [cwriter writeEndElement];
    [cwriter writeEndDocument];
    
    NSString *xml = [PMXMLBuilder additemXMLWithUsername:username password:password accountRow:[acctRow integerValue] orderRow:[ordRow integerValue] partRow:[partRow integerValue] quantity:[qty integerValue] tranType:ReturnTrans];
    
    XCTAssertTrue([xml isEqualToString:[cwriter toString]], @"response xml %@ does not equal xml %@", xml, [cwriter toString]);
}

- (void) testAddItemCoreReturnXML {
    
    NSNumber *acctRow = [NSNumber numberWithInteger:1234];
    NSNumber *ordRow  = [NSNumber numberWithInteger:4321];
    NSNumber *partRow = [NSNumber numberWithInteger:5678];
    NSNumber *qty     = [NSNumber numberWithInteger:876];
    
    id<XMLStreamWriter> cwriter = [[XMLWriter alloc] init];
    
    [cwriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cwriter writeStartElement:@"additem"];
    [cwriter writeStartElement:@"user"];
    [cwriter writeCharacters:username];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"password"];
    [cwriter writeCharacters:password];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"acctRow"];
    [cwriter writeCharacters:[acctRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"ordRow"];
    [cwriter writeCharacters:[ordRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"partRow"];
    [cwriter writeCharacters:[partRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"qty"];
    [cwriter writeCharacters:[qty stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"tranType"];
    [cwriter writeCharacters:@"C"];
    [cwriter writeEndElement];
    [cwriter writeEndElement];
    [cwriter writeEndDocument];
    
    NSString *xml = [PMXMLBuilder additemXMLWithUsername:username password:password accountRow:[acctRow integerValue] orderRow:[ordRow integerValue] partRow:[partRow integerValue] quantity:[qty integerValue] tranType:CoreTrans];
    
    XCTAssertTrue([xml isEqualToString:[cwriter toString]], @"response xml %@ does not equal xml %@", xml, [cwriter toString]);
}

- (void) testAddItemDefectiveReturnXML {
    
    NSNumber *acctRow = [NSNumber numberWithInteger:1234];
    NSNumber *ordRow  = [NSNumber numberWithInteger:4321];
    NSNumber *partRow = [NSNumber numberWithInteger:5678];
    NSNumber *qty     = [NSNumber numberWithInteger:876];
    
    id<XMLStreamWriter> cwriter = [[XMLWriter alloc] init];
    
    [cwriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cwriter writeStartElement:@"additem"];
    [cwriter writeStartElement:@"user"];
    [cwriter writeCharacters:username];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"password"];
    [cwriter writeCharacters:password];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"acctRow"];
    [cwriter writeCharacters:[acctRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"ordRow"];
    [cwriter writeCharacters:[ordRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"partRow"];
    [cwriter writeCharacters:[partRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"qty"];
    [cwriter writeCharacters:[qty stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"tranType"];
    [cwriter writeCharacters:@"D"];
    [cwriter writeEndElement];
    [cwriter writeEndElement];
    [cwriter writeEndDocument];
    
    NSString *xml = [PMXMLBuilder additemXMLWithUsername:username password:password accountRow:[acctRow integerValue] orderRow:[ordRow integerValue] partRow:[partRow integerValue] quantity:[qty integerValue] tranType:DefectTrans];
    
    XCTAssertTrue([xml isEqualToString:[cwriter toString]], @"response xml %@ does not equal xml %@", xml, [cwriter toString]);
}



#pragma mark - edititem

- (void) testEditItemXML {
    
    NSNumber *acctRow = [NSNumber numberWithInteger:1234];
    NSNumber *ordRow  = [NSNumber numberWithInteger:4321];
    NSNumber *itemRow = [NSNumber numberWithInteger:5678];
    NSNumber *qty     = [NSNumber numberWithInteger:876];
    
    id<XMLStreamWriter> cwriter = [[XMLWriter alloc] init];
    
    [cwriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cwriter writeStartElement:@"edititem"];
    [cwriter writeStartElement:@"user"];
    [cwriter writeCharacters:username];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"password"];
    [cwriter writeCharacters:password];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"acctRow"];
    [cwriter writeCharacters:[acctRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"ordRow"];
    [cwriter writeCharacters:[ordRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"itemRow"];
    [cwriter writeCharacters:[itemRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"qty"];
    [cwriter writeCharacters:[qty stringValue]];
    [cwriter writeEndElement];
    [cwriter writeEndElement];
    [cwriter writeEndDocument];
    
    NSString *xml = [PMXMLBuilder edititemXMLWithUsername:username password:password accountRow:[acctRow integerValue] orderRow:[ordRow integerValue] itemRow:[itemRow integerValue] quantity:[qty integerValue]];
    
    XCTAssertTrue([xml isEqualToString:[cwriter toString]], @"response xml %@ does not equal xml %@", xml, [cwriter toString]);
}

#pragma mark - deleteitem 

- (void) testDeleteItem {
    
    NSNumber *acctRow = [NSNumber numberWithInteger:1234];
    NSNumber *ordRow  = [NSNumber numberWithInteger:4321];
    NSNumber *itemRow = [NSNumber numberWithInteger:5678];
    
    id<XMLStreamWriter> cwriter = [[XMLWriter alloc] init];
    
    [cwriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cwriter writeStartElement:@"deleteitem"];
    [cwriter writeStartElement:@"user"];
    [cwriter writeCharacters:username];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"password"];
    [cwriter writeCharacters:password];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"acctRow"];
    [cwriter writeCharacters:[acctRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"ordRow"];
    [cwriter writeCharacters:[ordRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"itemRow"];
    [cwriter writeCharacters:[itemRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeEndElement];
    [cwriter writeEndDocument];
    
    NSString *xml = [PMXMLBuilder deleteitemXMLWithUsername:username password:password accountRow:[acctRow integerValue] orderRow:[ordRow integerValue] itemRow:[itemRow integerValue]];
    
    XCTAssertTrue([xml isEqualToString:[cwriter toString]], @"response xml %@ does not equal xml %@", xml, [cwriter toString]);
}

#pragma mark - listitems

- (void) testListItemsXML {
    NSNumber *ordRow = [NSNumber numberWithInteger:1234];
    
    id<XMLStreamWriter> cwriter = [[XMLWriter alloc] init];
    
    [cwriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cwriter writeStartElement:@"listitems"];
    [cwriter writeStartElement:@"user"];
    [cwriter writeCharacters:username];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"password"];
    [cwriter writeCharacters:password];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"ordRow"];
    [cwriter writeCharacters:[ordRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeEndElement];
    [cwriter writeEndDocument];
    
    NSString *xml = [PMXMLBuilder listitemsXMLWithUsername:username password:password orderRow:[ordRow integerValue]];
    
    XCTAssertTrue([xml isEqualToString:[cwriter toString]], @"response xml %@ does not equal xml %@", xml, [cwriter toString]);
}

#pragma mark - inqacct

- (void) testInqAcct {
    NSNumber *acctRow = [NSNumber numberWithInteger:10];
    
    id<XMLStreamWriter> cwriter = [[XMLWriter alloc] init];
    
    [cwriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cwriter writeStartElement:@"inqacct"];
    [cwriter writeStartElement:@"user"];
    [cwriter writeCharacters:username];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"password"];
    [cwriter writeCharacters:password];
    [cwriter writeEndElement];
    [cwriter writeStartElement:@"acctRow"];
    [cwriter writeCharacters:[acctRow stringValue]];
    [cwriter writeEndElement];
    [cwriter writeEndElement];
    [cwriter writeEndDocument];
    
    NSString *xml = [PMXMLBuilder inqacctXMLWithUsername:username password:password acctRow:[acctRow integerValue]];
    
    XCTAssertTrue([xml isEqualToString:[cwriter toString]], @"response xml %@ does not equal xml %@", xml, [cwriter toString]);

}


#pragma mark - catalog tests

- (void) yearsTest {
    
}

- (void) makesTest {
    
}

- (void) modelsTest {
    
}

- (void) enginesTest {
    
}

- (void) groupsTest {
    
}

- (void) subgroupsTest {
    
}

- (void) partsTest {
    
}





















































@end
