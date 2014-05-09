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

#pragma mark - orders

/*
- (void) testParseCheckordResponse {
    NSNumber *ordCnt;
    id<XMLStreamWriter> cxmlWriter = [[XMLWriter alloc] init];
    [cxmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [cxmlWriter writeEndDocument];
}
*/

@end
