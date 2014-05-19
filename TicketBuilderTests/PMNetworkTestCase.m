//
//  PMNetworkTestCase.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/3/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMLWriter.h"
#import "PMNetwork.h"
#import "PMItem.h"
#import "PMItem.h"
#import "PMMake.h"
#import "PMModel.h"
#import "PMEngine.h"
#import "PMGroup.h"
#import "PMSubGroup.h"
#import "PMPartType.h"
#import "PMPart.h"

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

#pragma mark - parseLoginReply

- (void)testParseLoginReplyNintytores {
    NSString *error = @"00";
    NSString *storeCnt = @"90";
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
        //root element
    [cxmlWriter writeStartElement:@"loginReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:error];
    [cxmlWriter writeEndElement];
    
    [cxmlWriter writeStartElement:@"storeCnt"];
    [cxmlWriter writeCharacters:storeCnt];
    [cxmlWriter writeEndElement];
    
    for(int i = 1; i < 91; i++) {
        [cxmlWriter writeStartElement:@"stores"];
        [cxmlWriter writeStartElement:@"storeId"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%d", i]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"storeName"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"Store%d", i]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeEndElement];
    }
    
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    //create correct response
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(int i=1; i < 91; i++) {
        [temp addObject:[[PMStore alloc] initWithName:[NSString stringWithFormat:@"Store%d", i] andID:i]];
    }
    NSArray *correctArray = [NSArray arrayWithArray:temp];
    NSNumber *count = [NSNumber numberWithInt:90];
    NSDictionary *correctResponse = [NSDictionary dictionaryWithObjectsAndKeys:count, @"storeCnt", correctArray, @"stored", nil];
    
    
    //call the network class
    NSDictionary *response = [PMNetwork parseLoginReply:[cxmlWriter toString]];

    
    //compare results
    XCTAssertTrue([[correctResponse objectForKey:@"storeCnt"] isEqualToNumber:[response objectForKey:@"storeCnt"]], @"correct count %@ should equal response count %@", [correctResponse objectForKey:@"storeCnt"], [response objectForKey:@"storeCnt"]);

    NSArray *resultArray = [response objectForKey:@"stores"];
    for(int i = 0; i < 90; i ++) {
        PMStore *correctStore = [correctArray objectAtIndex:i];
        PMStore *store = [resultArray objectAtIndex:i];
        XCTAssertTrue([correctStore isEqualToStore:store], @"correctStore %@ should equal store %@", [correctStore name], [store name]);
    }
}


- (void)testParseLoginReplyOneStores {
    NSString *error = @"00";
    NSString *storeCnt = @"1";
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    //root element
    [cxmlWriter writeStartElement:@"loginReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:error];
    [cxmlWriter writeEndElement];
    
    [cxmlWriter writeStartElement:@"storeCnt"];
    [cxmlWriter writeCharacters:storeCnt];
    [cxmlWriter writeEndElement];
    
    
    [cxmlWriter writeStartElement:@"stores"];
    [cxmlWriter writeStartElement:@"storeId"];
    [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%d", 1]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"storeName"];
    [cxmlWriter writeCharacters:[NSString stringWithFormat:@"Store%d", 1]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    
    
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    //create correct response
    NSMutableArray *temp = [[NSMutableArray alloc] init];

    [temp addObject:[[PMStore alloc] initWithName:[NSString stringWithFormat:@"Store%d", 1] andID:1]];
    
    NSArray *correctArray = [NSArray arrayWithArray:temp];
    NSNumber *count = [NSNumber numberWithInt:1];
    NSDictionary *correctResponse = [NSDictionary dictionaryWithObjectsAndKeys:count, @"storeCnt", correctArray, @"stored", nil];
    
    
    //call the network class
    NSDictionary *response = [PMNetwork parseLoginReply:[cxmlWriter toString]];
    
    
    //compare results
    XCTAssertTrue([[correctResponse objectForKey:@"storeCnt"] isEqualToNumber:[response objectForKey:@"storeCnt"]], @"correct count %@ should equal response count %@", [correctResponse objectForKey:@"storeCnt"], [response objectForKey:@"storeCnt"]);
    
    NSArray *resultArray = [response objectForKey:@"stores"];
    
    PMStore *correctStore = [correctArray objectAtIndex:0];
    PMStore *store = [resultArray objectAtIndex:0];
    XCTAssertTrue([correctStore isEqualToStore:store], @"correctStore %@ should equal store %@", [correctStore name], [store name]);
    
}

- (void)testParseLoginReplyNoStores {
    NSString *error = @"00";
    NSString *storeCnt = @"0";
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    //root element
    [cxmlWriter writeStartElement:@"loginReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:error];
    [cxmlWriter writeEndElement];
    
    [cxmlWriter writeStartElement:@"storeCnt"];
    [cxmlWriter writeCharacters:storeCnt];
    [cxmlWriter writeEndElement];
    
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    //create correct response
    
    
    NSNumber *count = [NSNumber numberWithInt:0];
    
    //call the network class
    NSDictionary *response = [PMNetwork parseLoginReply:[cxmlWriter toString]];
    
    
    //compare results
    XCTAssertTrue([count isEqualToNumber:[response objectForKey:@"storeCnt"]], @"correct count %@ should equal response count %@", count, [response objectForKey:@"storeCnt"]);
    
    NSArray *resultArray = [response objectForKey:@"stores"];
    
    XCTAssertTrue(([resultArray count] == 0), @"result array should be no nil length 0");
    
}


#pragma mark - findacct

- (void) testParseFindacct {
    NSString *error = @"00";
    NSString *acctCnt = @"90";
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    
    [cxmlWriter writeStartElement:@"findacctReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:error];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"acctCnt"];
    [cxmlWriter writeCharacters:acctCnt];
    [cxmlWriter writeEndElement];
    //add 90 accounts
    for(int i=0; i < 90; i++) {
        
        [cxmlWriter writeStartElement:@"accts"];
        [cxmlWriter writeStartElement:@"acctRow"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%d", i]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"anum"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%d", i]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"name"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"Account%d", i]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeEndElement];
    }
    
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    //build correct response
    NSMutableArray *tempAccounts = [[NSMutableArray alloc] init];
    for(int i = 0; i < 90; i++) {
        NSString *name = [NSString stringWithFormat:@"Account%d", i];
        [tempAccounts addObject:[[PMAccount alloc] initWithName:name row:i num:i]];
    }
    NSDictionary *correctResponse = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:90], @"acctCnt", tempAccounts, @"accounts", nil];
    
    //get response
    NSDictionary *response = [PMNetwork parseFindacctReply:[cxmlWriter toString]];
    
    
    //test response against correct response
    NSArray *correctAccts = [correctResponse objectForKey:@"accounts"];
    NSArray *responseAccts = [response objectForKey:@"accounts"];
    for(int i = 0; i < 90; i++) {
        PMAccount *correctAccount = [correctAccts objectAtIndex:i];
        PMAccount *account = [responseAccts objectAtIndex:i];
        XCTAssertTrue([correctAccount isEqualToAccount:account], @"correctAccount %@ should equal account %@", [correctAccount name], [account name]);
    }
    
    XCTAssertTrue([[correctResponse objectForKey:@"acctCnt"] isEqualToNumber:[response objectForKey:@"acctCnt"]], @"correct acctCnt:%@ should equal response acctCnt:%@", [correctResponse objectForKey:@"acctCnt"], [response objectForKey:@"acctCnt"]);
    
    XCTAssertTrue(([response objectForKey:@"error"] == nil), @"error should be nil");
    
}

- (void) testParseFindacctNoAccounts {
    NSString *error = @"00";
    NSString *acctCnt = @"0";
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    
    [cxmlWriter writeStartElement:@"findacctReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:error];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"acctCnt"];
    [cxmlWriter writeCharacters:acctCnt];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    //build correct response
    
    //get response
    NSDictionary *response = [PMNetwork parseFindacctReply:[cxmlWriter toString]];
    
    
    //test response against correct response


    XCTAssertTrue(([[response objectForKey:@"accounts"] count] == 0), @"accounts should be no nil and 0");
    
    XCTAssertTrue([[NSNumber numberWithInteger:0] isEqualToNumber:[response objectForKey:@"acctCnt"]], @"correct acctCnt:%d should equal response acctCnt:%@", 0, [response objectForKey:@"acctCnt"]);
    
    XCTAssertTrue(([response objectForKey:@"error"] == nil), @"error should be nil");
    
}


#pragma mark - confacct

- (void) testConfacct {
    NSNumber *anum = [NSNumber numberWithInteger:22];
    NSString *name = @"Account Name";
    NSString *addr1 = @"Address line 1";
    NSString *addr2 = @"Address line 2";
    NSString *city = @"City Name";
    NSString *state = @"State Name";
    NSString *zip = @"Account Zip";
    NSString *phone = @"666-666-6666";
    NSString *fax = @"777-777-7777";
    NSString *contact = @"John Doe";
    NSString *email = @"John@store.com";
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"confacctReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"anum"];
    [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%@", anum]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"name"];
    [cxmlWriter writeCharacters:name];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"addr1"];
    [cxmlWriter writeCharacters:addr1];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"addr2"];
    [cxmlWriter writeCharacters:addr2];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"city"];
    [cxmlWriter writeCharacters:city];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"state"];
    [cxmlWriter writeCharacters:state];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"zip"];
    [cxmlWriter writeCharacters:zip];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"phone"];
    [cxmlWriter writeCharacters:phone];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"fax"];
    [cxmlWriter writeCharacters:fax];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"contact"];
    [cxmlWriter writeCharacters:contact];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"email"];
    [cxmlWriter writeCharacters:email];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    //build correct response
    
    NSDictionary *response = [PMNetwork parseConfacctReply:[cxmlWriter toString]];
    
    XCTAssertTrue([anum isEqualToNumber:[response objectForKey:@"anum"]], @"anums should be equal");
    XCTAssertTrue([[response objectForKey:@"name"] isEqualToString:name], @"correct name %@ should equal name:%@", name, [response objectForKey:@"name"]);
    XCTAssertTrue([[response objectForKey:@"addr1"] isEqualToString:addr1], @"correct addr1 %@ should equal addr1 %@", addr1, [response objectForKey:@"addr1"]);
    XCTAssertTrue([[response objectForKey:@"addr2"] isEqualToString:addr2], @"correct addr2 %@ should equal addr2 %@", addr2, [response objectForKey:@"addr2"]);
    XCTAssertTrue([[response objectForKey:@"city"] isEqualToString:city], @"correct city %@ should equal city %@", city, [response objectForKey:@"city"]);
    XCTAssertTrue([[response objectForKey:@"state"] isEqualToString:state], @"correct state %@ should equal state %@", state, [response objectForKey:@"state"]);
    XCTAssertTrue([[response objectForKey:@"zip"] isEqualToString:zip], @"correct zip %@ shoudl equal zip %@", zip, [response objectForKey:@"zip"]);
    XCTAssertTrue([[response objectForKey:@"phone"] isEqualToString:phone], @"correct phone %@ should equal phone %@", phone, [response objectForKey:@"phone"]);
    XCTAssertTrue([[response objectForKey:@"fax"] isEqualToString:fax], @"correct fax %@ shoudl equal fax %@", fax, [response objectForKey:@"fax"]);
    XCTAssertTrue([[response objectForKey:@"contact"] isEqualToString:contact], @"correct contact %@ shoudl equal contact %@", contact, [response objectForKey:@"contact"]);
    XCTAssertTrue([[response objectForKey:@"email"] isEqualToString:email], @"correct email %@ should equal email %@", email, [response objectForKey:@"email"]);
}

#pragma mark - checkord


- (void) testParseCheckordReply {
    NSNumber *ordCnt = [NSNumber numberWithInteger:90];
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    
    
    NSMutableArray *correctOrders = [[NSMutableArray alloc] init];
    for (int i=0; i<90; i++) {
        [correctOrders addObject:[[PMOrder alloc] initWithRow:i Date:[NSString stringWithFormat:@"5/5/2005"] orderNum:i comment:[NSString stringWithFormat:@"Comment%d", i]]];
    }
    
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    
    [cxmlWriter writeStartElement:@"checkordReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"ordCnt"];
    [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%@", ordCnt]];
    [cxmlWriter writeEndElement];
    
    for (int i = 0; i < 90; i++) {
        PMOrder *order = [correctOrders objectAtIndex:i];
        [cxmlWriter writeStartElement:@"orders"];
        [cxmlWriter writeStartElement:@"ordRow"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)[order ordRow]]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"ordDate"];
        [cxmlWriter writeCharacters:[order date]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"ordNum"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)[order ordNum]]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"ordComment"];
        [cxmlWriter writeCharacters:[order comment]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeEndElement];
    }
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseCheckordReply:[cxmlWriter toString]];
    
    NSArray *orders = [response objectForKey:@"orders"];
    for (int i = 0; i < 90; i++) {
        PMOrder *correctOrder = [correctOrders objectAtIndex:i];
        PMOrder *order = [orders objectAtIndex:i];
        XCTAssertTrue([correctOrder isEqualToOrder:order], @"orders are not equal");
    }
    
    NSNumber *rOrdCnt = [NSNumber numberWithInteger:[[response objectForKey:@"ordCnt"] integerValue]];
    
    XCTAssertTrue([ordCnt isEqualToNumber:rOrdCnt], @"order counts are different");
    
}

- (void) testParseCheckordReplyNoOrders {
    NSNumber *ordCnt = [NSNumber numberWithInteger:0];
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    
    [cxmlWriter writeStartElement:@"checkordReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"ordCnt"];
    [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%@", ordCnt]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseCheckordReply:[cxmlWriter toString]];
    
    NSArray *orders = [response objectForKey:@"orders"];
    XCTAssertTrue(([orders count] == 0), @"orders should be non nil and empty");
    NSNumber *rOrdCnt = [response objectForKey:@"ordCnt"];
    
    XCTAssertTrue([ordCnt isEqualToNumber:rOrdCnt], @"order counts are different");
    
}

#pragma mark - createord

- (void) testParseCreateordReply {
    NSNumber *ordRow = [NSNumber numberWithInteger:1234];
    NSNumber *ordNum = [NSNumber numberWithInteger:4321];
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"createordReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"ordRow"];
    [cxmlWriter writeCharacters:[ordRow stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"ordNum"];
    [cxmlWriter writeCharacters:[ordNum stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseCreateordReply:[cxmlWriter toString]];
    
    XCTAssertTrue([[response objectForKey:@"ordRow"] isEqualToNumber:ordRow], @"response row %@ equals %@", [response objectForKey:@"ordRow"], ordRow);
    XCTAssertTrue([[response objectForKey:@"ordNum"] isEqualToNumber:ordNum], @"order numbers not equal");
}

#pragma mark - deleteord 

- (void) testParseDeleteordReply {
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"deleteordReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseDeleteordReply:[cxmlWriter toString]];

    XCTAssertTrue(([response objectForKey:@"error"] == nil), @"no error key");
    XCTAssertTrue(([response count] == 0), @"response should be empty");
}

#pragma mark - additem
- (void) testAdditemReply {
    NSNumber *ordTot = [NSNumber numberWithInteger:1234.56];
    NSNumber *coreTot = [NSNumber numberWithInteger:6543.89];
    NSNumber *taxTot = [NSNumber numberWithInteger:345.45];
    NSNumber *itemRow = [NSNumber numberWithInteger:333];
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"additemReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"ordTot"];
    [cxmlWriter writeCharacters:[ordTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"coreTot"];
    [cxmlWriter writeCharacters:[coreTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"taxTot"];
    [cxmlWriter writeCharacters:[taxTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"itemRow"];
    [cxmlWriter writeCharacters:[itemRow stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseAdditemReply:[cxmlWriter toString]];
    
    XCTAssertTrue([[response objectForKey:@"ordTot"] isEqualToNumber:ordTot], @"order totals not equal");
    XCTAssertTrue([[response objectForKey:@"coreTot"] isEqualToNumber:coreTot], @"core totals not equal");
    XCTAssertTrue([[response objectForKey:@"taxTot"] isEqualToNumber:taxTot], @"tax totals not equal");
    XCTAssertTrue([[response objectForKey:@"itemRow"] isEqualToNumber:itemRow], @"item rows not equal");
    
}

#pragma mark - edititem
- (void) testEdititemReply {
    NSNumber *ordTot = [NSNumber numberWithInteger:1234.56];
    NSNumber *coreTot = [NSNumber numberWithInteger:6543.89];
    NSNumber *taxTot = [NSNumber numberWithInteger:345.45];
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"edititemReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"ordTot"];
    [cxmlWriter writeCharacters:[ordTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"coreTot"];
    [cxmlWriter writeCharacters:[coreTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"taxTot"];
    [cxmlWriter writeCharacters:[taxTot stringValue]];
    [cxmlWriter writeEndElement];

    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseEdititemReply:[cxmlWriter toString]];
    
    XCTAssertTrue([[response objectForKey:@"ordTot"] isEqualToNumber:ordTot], @"order totals not equal");
    XCTAssertTrue([[response objectForKey:@"coreTot"] isEqualToNumber:coreTot], @"core totals not equal");
    XCTAssertTrue([[response objectForKey:@"taxTot"] isEqualToNumber:taxTot], @"tax totals not equal");

}

#pragma mark - deleteitem
- (void) testDeleteitemReply {
    NSNumber *ordTot = [NSNumber numberWithInteger:1234.56];
    NSNumber *coreTot = [NSNumber numberWithInteger:6543.89];
    NSNumber *taxTot = [NSNumber numberWithInteger:345.45];
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"deleteitemReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"ordTot"];
    [cxmlWriter writeCharacters:[ordTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"coreTot"];
    [cxmlWriter writeCharacters:[coreTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"taxTot"];
    [cxmlWriter writeCharacters:[taxTot stringValue]];
    [cxmlWriter writeEndElement];
    
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseDeleteitemReply:[cxmlWriter toString]];
    
    XCTAssertTrue([[response objectForKey:@"ordTot"] isEqualToNumber:ordTot], @"order totals not equal");
    XCTAssertTrue([[response objectForKey:@"coreTot"] isEqualToNumber:coreTot], @"core totals not equal");
    XCTAssertTrue([[response objectForKey:@"taxTot"] isEqualToNumber:taxTot], @"tax totals not equal");
}

#pragma mark - listitems
- (void) testListitemsReply {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSNumber *ordTot = [NSNumber numberWithDouble:22.50];
    NSNumber *coreTot = [NSNumber numberWithDouble:33.25];
    NSNumber *taxTot = [NSNumber numberWithDouble:3.33];
    NSNumber *itemCnt = [NSNumber numberWithInteger:90];
    
    for (int i=0; i<90; i++) {
        PMPart *part = [[PMPart alloc] initWithPartRow:i line:@"DUP" part:[NSString stringWithFormat:@"EE%dF22%d", i, i]];
        
        if (i < 25) {
            [items addObject:[[PMItem alloc] initWithItemRow:i part:part quantity:i transType:SaleTrans]];
        } else if (i >= 25 && i < 50) {
            [items addObject:[[PMItem alloc] initWithItemRow:i part:part quantity:i transType:ReturnTrans]];
        } else if (i >= 50 < 75) {
            [items addObject:[[PMItem alloc] initWithItemRow:i part:part quantity:i transType:DefectTrans]];
        } else {
            [items addObject:[[PMItem alloc] initWithItemRow:i part:part quantity:i transType:CoreTrans]];
        }
    }
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"listitemsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"ordTot"];
    [cxmlWriter writeCharacters:[ordTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"coreTot"];
    [cxmlWriter writeCharacters:[coreTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"taxTot"];
    [cxmlWriter writeCharacters:[taxTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"itemCnt"];
    [cxmlWriter writeCharacters:[itemCnt stringValue]];
    [cxmlWriter writeEndElement];
    
    for(int i=0; i<90; i++) {
        PMItem *item = [items objectAtIndex:i];
        PMPart *part = [item part];
        [cxmlWriter writeStartElement:@"items"];
        [cxmlWriter writeStartElement:@"itemRow"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)[item itemRow]]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"partRow"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)[part partRow]]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"line"];
        [cxmlWriter writeCharacters:[part line]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"part"];
        [cxmlWriter writeCharacters:[part part]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"qty"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)[item qty]]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"tranType"];
        NSString *type = nil;
        switch ([item transType]) {
            case SaleTrans:
                type = @"S";
                break;
            case ReturnTrans:
                type = @"R";
                break;
            case CoreTrans:
                type = @"C";
                break;
            case DefectTrans:
                type = @"D";
                break;
        }
        [cxmlWriter writeCharacters:type];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeEndElement];
    }
    
    
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    
    NSDictionary *response = [PMNetwork parseListitemsReply:[cxmlWriter toString]];
    
    XCTAssertTrue([[response objectForKey:@"ordTot"] isEqualToNumber:ordTot] , @"ordTot not equal");
    XCTAssertTrue([[response objectForKey:@"coreTot"] isEqualToNumber:coreTot] , @"coreTot not Equal");
    XCTAssertTrue([[response objectForKey:@"taxTot"] isEqualToNumber:taxTot] , @"taxTot not Equal");
    XCTAssertTrue([[response objectForKey:@"itemCnt"] isEqualToNumber:itemCnt] , @"itemCnt not equal");
    
    NSArray *responseItems = [response objectForKey:@"items"];
    
    for(int i = 0; i < 90; i++) {
        PMItem *item1 = [items objectAtIndex:i];
        PMItem *item2 = [responseItems objectAtIndex:i];
        XCTAssertTrue([item1 isEqualToItem:item2], @"item %d is not equal", i);
    }
}

- (void) testListitemsNoItems {
    NSNumber *ordTot = [NSNumber numberWithDouble:22.50];
    NSNumber *coreTot = [NSNumber numberWithDouble:33.25];
    NSNumber *taxTot = [NSNumber numberWithDouble:3.33];
    NSNumber *itemCnt = [NSNumber numberWithInteger:00];
    
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"listitemsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"ordTot"];
    [cxmlWriter writeCharacters:[ordTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"coreTot"];
    [cxmlWriter writeCharacters:[coreTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"taxTot"];
    [cxmlWriter writeCharacters:[taxTot stringValue]];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"itemCnt"];
    [cxmlWriter writeCharacters:[itemCnt stringValue]];
    [cxmlWriter writeEndElement];
    
    
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    
    NSDictionary *response = [PMNetwork parseListitemsReply:[cxmlWriter toString]];
    
    XCTAssertTrue([[response objectForKey:@"ordTot"] isEqualToNumber:ordTot] , @"ordTot not equal");
    XCTAssertTrue([[response objectForKey:@"coreTot"] isEqualToNumber:coreTot] , @"coreTot not Equal");
    XCTAssertTrue([[response objectForKey:@"taxTot"] isEqualToNumber:taxTot] , @"taxTot not Equal");
    XCTAssertTrue([[response objectForKey:@"itemCnt"] isEqualToNumber:itemCnt] , @"itemCnt not equal");
    
    NSArray *responseItems = [response objectForKey:@"items"];
    
    XCTAssertTrue(([responseItems count] == 0), @"return non nil empty array");
}

#pragma mark - year test

- (void) testParseYears {

    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"yearsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    for(int i = 1970; i < 2014; i++) {
        NSString *year = [NSString stringWithFormat:@"%d", i];
        [cxmlWriter writeStartElement:@"year"];
        [cxmlWriter writeCharacters:year];
        [cxmlWriter writeEndElement];
    }
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseYearsReply:[cxmlWriter toString]];
    
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0) , @"error should be nil");

    NSArray *years = [response objectForKey:@"years"];
    
    XCTAssertTrue([years isEqualToArray:[response objectForKey:@"years"]], @"");
}

- (void) testParseYearsNoYears {
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"yearsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseYearsReply:[cxmlWriter toString]];
    
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0) , @"error should be nil");
    XCTAssertTrue(([[response objectForKey:@"years"] count] == 0), @"shoud return empty array of years");
}

#pragma mark - makes 

- (void) testParseMakes {
    
    NSMutableArray *makes = [[NSMutableArray alloc] init];
    for (int i=0; i<500; i++) {
        NSString *make = [NSString stringWithFormat:@"Make%d", i];
        NSString *makeDesc = [NSString stringWithFormat:@"%@, description", make];
        [makes addObject:[[PMMake alloc] initWithMake:make makeDesc:makeDesc]];
    }
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"makesReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    for(int i = 0; i < 500; i++) {
        PMMake *make = [makes objectAtIndex:i];
        [cxmlWriter writeStartElement:@"makes"];
        [cxmlWriter writeStartElement:@"make"];
        [cxmlWriter writeCharacters:[make make]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"makeDesc"];
        [cxmlWriter writeCharacters:[make makeDesc]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeEndElement];
    }
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    
    NSDictionary *response = [PMNetwork parseMakesReply:[cxmlWriter toString]];
    
    XCTAssertTrue(([[response objectForKey:@"makes"] count] == 500), @"500 makes in count");
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error returned");

    
}

- (void) testParseNoMakes {
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"makesReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseMakesReply:[cxmlWriter toString]];
    
    XCTAssertTrue(([[response objectForKey:@"makes"] count] == 0), @"0 makes in count");
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error returned");
}
#pragma mark - models
- (void) testParseModels {
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"modelsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    for(int i = 0; i < 500; i++) {
        NSString *model = [NSString stringWithFormat:@"Model%d", i];
        [cxmlWriter writeStartElement:@"models"];
        [cxmlWriter writeStartElement:@"model"];
        [cxmlWriter writeCharacters:model];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"modelDesc"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%@, description", model]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeEndElement];
    }
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseModelsReply:[cxmlWriter toString]];
    XCTAssertTrue(([[response objectForKey:@"models"] count] == 500), @"500 models in count");
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error returned");
}

- (void) testParseNoModels {
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"modelsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseModelsReply:[cxmlWriter toString]];
    XCTAssertTrue(([[response objectForKey:@"models"] count] == 0), @"0 models in count");
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error returned");
}
#pragma mark - engines
- (void) testParseEngines {
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"enginesReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    for(int i = 0; i < 500; i++) {
        NSString *vid = [NSString stringWithFormat:@"Make%d", i];
        [cxmlWriter writeStartElement:@"engines"];
        [cxmlWriter writeStartElement:@"vid"];
        [cxmlWriter writeCharacters:vid];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"engineDesc"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%@, description", vid]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeEndElement];
    }
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseEnginesReply:[cxmlWriter toString]];
    XCTAssertTrue(([[response objectForKey:@"engines"] count] == 500), @"500 models in count");
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error returned");
}

- (void) testParseEnginesNoEngines {
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"enginesReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseEnginesReply:[cxmlWriter toString]];
    XCTAssertTrue(([[response objectForKey:@"engines"] count] == 0), @"0 engines in count");
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error returned");
}

#pragma mark - groups

- (void) testParseGroups {
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"groupsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    for(int i = 0; i < 500; i++) {
        NSString *group = [NSString stringWithFormat:@"group%d", i];
        [cxmlWriter writeStartElement:@"groups"];
        [cxmlWriter writeStartElement:@"group"];
        [cxmlWriter writeCharacters:group];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"groupDesc"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%@, description", group]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeEndElement];
    }
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseGroupsReply:[cxmlWriter toString]];
    XCTAssertTrue(([[response objectForKey:@"groups"] count] == 500), @"500 groupss in count");
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error returned");
}

- (void) testParseNoGroups {
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"groupsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseGroupsReply:[cxmlWriter toString]];
    XCTAssertTrue(([[response objectForKey:@"groups"] count] == 0), @"0 groupss in count");
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error returned");
}

#pragma mark - subgroups
- (void) testParseSubGroups {
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"subgroupsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    for(int i = 0; i < 500; i++) {
        NSString *group = [NSString stringWithFormat:@"subgroup%d", i];
        [cxmlWriter writeStartElement:@"subgroups"];
        [cxmlWriter writeStartElement:@"subgroup"];
        [cxmlWriter writeCharacters:group];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"subgroupDesc"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%@, description", group]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeEndElement];
    }
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseSubgroupsReply:[cxmlWriter toString]];
    
    XCTAssertTrue(([[response objectForKey:@"subgroups"] count] == 500), @"500 subgroups in array");
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error returned");
}

- (void) testParseNoSubGroups {
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"subgroupsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];

    NSDictionary *response = [PMNetwork parseSubgroupsReply:[cxmlWriter toString]];
    
    XCTAssertTrue(([[response objectForKey:@"subgroups"] count] == 0), @"0 subgroups in array");
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error returned");
}

#pragma mark - parts

- (void) testParsePartsReply {
    NSMutableArray *partTypes = [[NSMutableArray alloc] init];
    for (int i = 0; i<50; i++) {
        NSMutableArray *parts = [[NSMutableArray alloc] init];
        for (int i = 0; i < 25; i++) {
            PMPart *part = [[PMPart alloc] initWithPartRow:i
                                                      line:@"DUP"
                                                      part:[NSString stringWithFormat:@"EFT%d", i]
                                               description:[NSString stringWithFormat:@"Desc%d", i]
                                            longDesciption:[NSString stringWithFormat:@"longDesc%d", i]
                                                     manuf:[NSString stringWithFormat:@"manuf%d", i]
                                                      list:i
                                                     price:[NSDecimalNumber decimalNumberWithString:@"3.3"]
                                                      core:[NSDecimalNumber decimalNumberWithString:@"4.4"]
                                                   instock:i];
            
            [parts addObject:part];
        }
        PMPartType *partType = [[PMPartType alloc] initWithCode:[NSString stringWithFormat:@"%d", i]
                                                    description:[NSString stringWithFormat:@"%d", i]
                                                          parts:parts];
        
        [partTypes addObject:partType];
    }
    
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"subgroupsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    
    for (int i = 0; i < 50; i++) {
        PMPartType *partType = [partTypes objectAtIndex:i];
        [cxmlWriter writeStartElement:@"partTypes"];
        [cxmlWriter writeStartElement:@"partType"];
        [cxmlWriter writeCharacters:[partType typeCode]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"partTypeDesc"];
        [cxmlWriter writeCharacters:[partType description]];
        [cxmlWriter writeEndElement];
        
        for (PMPart *p in [partType parts]) {
            [cxmlWriter writeStartElement:@"parts"];
            [cxmlWriter writeStartElement:@"partRow"];
            [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%d", [p partRow]]];
            [cxmlWriter writeEndElement];
            [cxmlWriter writeStartElement:@"line"];
            [cxmlWriter writeCharacters:@"DUP"];
            [cxmlWriter writeEndElement];
            [cxmlWriter writeStartElement:@"part"];
            [cxmlWriter writeCharacters:[p part]];
            [cxmlWriter writeEndElement];
            [cxmlWriter writeStartElement:@"partDesc"];
            [cxmlWriter writeCharacters:[p partDesc]];
            [cxmlWriter writeEndElement];
            [cxmlWriter writeStartElement:@"longDesc"];
            [cxmlWriter writeCharacters:[p longDesc]];
            [cxmlWriter writeEndElement];
            [cxmlWriter writeStartElement:@"manuf"];
            [cxmlWriter writeCharacters:[p manuf]];
            [cxmlWriter writeEndElement];
            [cxmlWriter writeStartElement:@"list"];
            [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%d", [p list]]];
            [cxmlWriter writeEndElement];
            [cxmlWriter writeStartElement:@"price"];
            [cxmlWriter writeCharacters:[[p price] stringValue]];
            [cxmlWriter writeEndElement];
            [cxmlWriter writeStartElement:@"core"];
            [cxmlWriter writeCharacters:[[p core] stringValue]];
            [cxmlWriter writeEndElement];
            [cxmlWriter writeStartElement:@"instock"];
            [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%d", [p instock]]];
            [cxmlWriter writeEndElement];
            [cxmlWriter writeEndElement];
        }
        
        [cxmlWriter writeEndElement];
    }
    
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parsePartsReply:[cxmlWriter toString]];
    
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error message");
    NSArray *types = [response objectForKey:@"partTypes"];
    
    XCTAssertTrue(([types count] == 50), @"50 types");
    for (PMPartType *pt in types) {
        XCTAssertTrue(([[pt parts] count] == 25), @"25 parts in each category");
    }
}

- (void) testParsePartsReplyNoPartTypes {

    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"subgroupsReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parsePartsReply:[cxmlWriter toString]];
    
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error message");
    NSArray *types = [response objectForKey:@"partTypes"];
    XCTAssertTrue(([types count] == 0), @"50 types");

}

- (void) testParseFindPartReply {
    
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (int i = 0; i < 50; i++) {
        
        PMPart *part = [[PMPart alloc] initWithPartRow:i line:@"dup" part:[NSString stringWithFormat:@"%d", i]];
        [part setPartDesc:@"This is a part"];
        [part setPartType:PMTypeMain];
        [part setInstock:5];
        [part setInstockAll:100];
        [part setPrice:[NSDecimalNumber decimalNumberWithString:@"9.22"]];
        [part setCore:[NSDecimalNumber decimalNumberWithString:@"4.22"]];
        [part setWeight:[NSDecimalNumber decimalNumberWithString:@"14.0"]];
        [part setTaxpart:NO];
        [part setTaxcore:NO];
        [part setStateTaxPart:NO];
        [part setLocalTaxCore:NO];
        [part setLocalTaxPart:NO];

        [parts addObject:part];
    }
    
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeStartElement:@"findpartReply"];
    [cxmlWriter writeStartElement:@"error"];
    [cxmlWriter writeCharacters:@"00"];
    [cxmlWriter writeEndElement];
    [cxmlWriter writeStartElement:@"partCnt"];
    [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%d", [parts count]]];
    [cxmlWriter writeEndElement];
    for (PMPart *p in parts) {
        [cxmlWriter writeStartElement:@"parts"];
        [cxmlWriter writeStartElement:@"partRow"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%d", [p partRow]]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"line"];
        [cxmlWriter writeCharacters:[p line]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"part"];
        [cxmlWriter writeCharacters:[p part]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"partDesc"];
        [cxmlWriter writeCharacters:[p partDesc]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"partType"];
        [cxmlWriter writeCharacters:@"M"];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"instock"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%d", [p instock]]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"instockAll"];
        [cxmlWriter writeCharacters:[NSString stringWithFormat:@"%d", [p instockAll]]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"price"];
        [cxmlWriter writeCharacters:[[p price] stringValue]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"core"];
        [cxmlWriter writeCharacters:[[p core] stringValue]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"weight"];
        [cxmlWriter writeCharacters:[[p weight] stringValue]];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"taxpart"];
        [cxmlWriter writeCharacters:@"N"];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"taxcore"];
        [cxmlWriter writeCharacters:@"N"];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"stateTaxPart"];
        [cxmlWriter writeCharacters:@"N"];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"stateTaxCore"];
        [cxmlWriter writeCharacters:@"N"];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"localTaxPart"];
        [cxmlWriter writeCharacters:@"N"];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeStartElement:@"localTaxCore"];
        [cxmlWriter writeCharacters:@"N"];
        [cxmlWriter writeEndElement];
        [cxmlWriter writeEndElement];
    }
    [cxmlWriter writeEndElement];
    [cxmlWriter writeEndDocument];
    
    NSDictionary *response = [PMNetwork parseFindPartReply:[cxmlWriter toString]];
    
    XCTAssertFalse(([[response objectForKey:@"error"] length] > 0), @"no error message");
    XCTAssertTrue(([[response objectForKey:@"parts"] count] == 50), @"50 parts in resposne");
    

}

@end
