//
//  TBNetwork.m
//  TicketBuilder
//
//  Created by Jeremy Moyers on 4/29/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMNetwork.h"

#define USERNAME_PASSWORD 10
#define USER_NOT_VALID 11
#define INVALID_ACCT_NUM_ALL_STORES 20
#define NO_STORE_NAME_MATCH 21
#define INVALID_ACCT_NUM_FOR_USER 22
#define ACCOUNT_NUM_IN_USE 23
#define CREDIT_HOLD 24
#define INVALID_RECID 25
#define ORDER_FINALIZED 40
#define INVALID_CUSTOMER_NUMBER 60
#define NON_CUSTOMER_LIST_ACCT 61
#define CATALOG_NOT_AVAILABLE 80

@implementation PMNetwork

/**************************************************************
 *Send a xml file over HTTP to the address specified
 *
 *params
 *  xml - NSString* - xml data to be sent over the network
 *  url - NSString* - the ip and port num in "255.255.255.255:55555"
 *                    string format
 *return
 *  NSString representing the xml returned form the server
 ***************************************************************/
+(NSString *) postXML:(NSString *)xml toURL:(NSString *)url {
    
    NSData *body = [xml dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", url]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Accept"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSLog(@"Status code = %ld", (long)httpResponse.statusCode);
    
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if([responseString length] == 0) {
        responseString = @"Connection timed out";
    }
    return responseString;
}

#pragma mark - parsing
/**************************************************************
 *Check error codes of network response
 *
 *params 
 *  error - NSString* - string value of the error code
 *
 *return
 *  NSString* - correct error message to display to user, nil 
 *              if no erros are found
 **************************************************************/
+ (NSString *) checkErrors:(NSString *)error {
    NSInteger errorCode = [error integerValue];
    NSString *errorMessage = nil;
    
    switch (errorCode) {
        case USERNAME_PASSWORD:
            errorMessage = @"Invalid user/password";
            break;
        case USER_NOT_VALID:
            errorMessage = @"User not valid for MOE system";
            break;
        case INVALID_ACCT_NUM_ALL_STORES:
            errorMessage = @"Invalid account # for all stores";
            break;
        case NO_STORE_NAME_MATCH:
            errorMessage = @"No matches on name field in current store";
            break;
        case INVALID_CUSTOMER_NUMBER:
            errorMessage = @"Invalid customer # (phone #)";
            break;
        case NON_CUSTOMER_LIST_ACCT:
            errorMessage = @"Not a customer list account";
            break;
        case CREDIT_HOLD:
            errorMessage = @"Account on credit hold";
            break;
        case ORDER_FINALIZED:
            errorMessage = @"Order is already finalized";
            break;
        case ACCOUNT_NUM_IN_USE:
            errorMessage = @"Account already exists with this account number";
            break;
        case CATALOG_NOT_AVAILABLE:
            errorMessage = @"Catalog is not available";
            break;
        default:
            break;
    }
    return errorMessage;
}

/**************************************************************
 *parse the response from the login function
 *
 *params
 *  data - NSString* - xml data returned from a network request
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *      error      => error code if there is an error
 *      storeCount => number of stores returned
 *      stores     => array of store objects returned
 ***************************************************************/
+ (NSDictionary *) parseLoginReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%d, message: %@", [rootError code], [rootError localizedDescription]);
        return nil;
    }
    
    TBXMLElement *root = [tbxml rootXMLElement];
    
    //parse errors
    TBXMLElement *error = [TBXML childElementNamed:@"error" parentElement:root];
    if (error == nil) {
        NSLog(@"parseLoginReply could not find error");
        return nil;
    }
    NSString *errorString = [TBXML textForElement:error];
    
    NSString *errorMessage = [PMNetwork checkErrors:errorString];
    if (errorMessage != nil) {
        return [NSDictionary dictionaryWithObject:errorMessage forKey:@"error"];
    }
    
    //Parse store count
    TBXMLElement *storeCntEle = [TBXML childElementNamed:@"storeCnt" parentElement:root];
    NSInteger storeCnt = [[TBXML textForElement:storeCntEle] integerValue];

    //Parse stores
    TBXMLElement *storeElement     = [TBXML childElementNamed:@"stores" parentElement:root];
    TBXMLElement *storeNameElement = [TBXML childElementNamed:@"storeName" parentElement:storeElement];
    TBXMLElement *storeIdElement   = [TBXML childElementNamed:@"storeId" parentElement:storeElement];
    PMStore *store1 = [[PMStore alloc] initWithName:[TBXML textForElement:storeNameElement]
                                              andID:[[TBXML textForElement:storeIdElement] integerValue]];
    NSMutableArray *stores = [[NSMutableArray alloc] initWithObjects:store1, nil];

    while ((storeElement = storeElement->nextSibling)) {
        storeNameElement = [TBXML childElementNamed:@"storeName" parentElement:storeElement];
        storeIdElement   = [TBXML childElementNamed:@"storeId" parentElement:storeElement];
        PMStore *store   = [[PMStore alloc] initWithName:[TBXML textForElement:storeNameElement]
                                                  andID:[[TBXML textForElement:storeIdElement] integerValue]];
        [stores addObject:store];
    }
    
    NSDictionary *returnData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:storeCnt],
                                                                          @"storeCnt", stores, @"stores", nil];

    return returnData;
}

/**************************************************************
 *parse the response from the findacct function
 *
 *params
 *  data - NSString* - xml data returned from a network request
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *      error      => error code if there is an error
 *      acctCnt    => number of stores returned
 *      accounts   => array of account objects returned
 ***************************************************************/

+ (NSDictionary *) parseFindacctReply:(NSString *)xml {

    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%d, message: %@", [rootError code], [rootError localizedDescription]);
        return nil;
    }

    TBXMLElement *root = [tbxml rootXMLElement];
    
    //parse errors
    TBXMLElement *error = [TBXML childElementNamed:@"error" parentElement:root];
    if (error == nil) {
        NSLog(@"parseFindacctReply could not find error");
        return nil;
    }
    NSString *errorString = [TBXML textForElement:error];
    
    NSString *errorMessage = [PMNetwork checkErrors:errorString];
    if (errorMessage != nil) {
        return [NSDictionary dictionaryWithObject:errorMessage forKey:@"error"];
    }
    
    //Parse store count
    TBXMLElement *acctCntEle = [TBXML childElementNamed:@"acctCnt" parentElement:root];
    NSInteger acctCnt = [[TBXML textForElement:acctCntEle] integerValue];

    //Parse stores
    TBXMLElement *acctElement     = [TBXML childElementNamed:@"accts" parentElement:root];
    TBXMLElement *acctNameElement = [TBXML childElementNamed:@"name" parentElement:acctElement];
    TBXMLElement *acctNumElement  = [TBXML childElementNamed:@"anum" parentElement:acctElement];
    TBXMLElement *acctRowElement  = [TBXML childElementNamed:@"acctRow" parentElement:acctElement];
    PMAccount *account1 = [[PMAccount alloc] initWithName:[TBXML textForElement:acctNameElement]
                                                      row:[[TBXML textForElement:acctRowElement] integerValue]
                                                      num:[[TBXML textForElement:acctNumElement] integerValue]];
    NSMutableArray *accounts = [[NSMutableArray alloc] initWithObjects:account1, nil];
    
    while ((acctElement = acctElement->nextSibling)) {
        acctNameElement = [TBXML childElementNamed:@"name" parentElement:acctElement];
        acctNumElement  = [TBXML childElementNamed:@"anum" parentElement:acctElement];
        acctRowElement  = [TBXML childElementNamed:@"acctRow" parentElement:acctElement];
        PMAccount *account = [[PMAccount alloc] initWithName:[TBXML textForElement:acctNameElement]
                                                         row:[[TBXML textForElement:acctRowElement] integerValue]
                                                         num:[[TBXML textForElement:acctNumElement] integerValue]];
        [accounts addObject:account];
    }
    
    NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:acctCnt], @"acctCnt", accounts, @"accounts", nil];
    
    return response;
}

/**************************************************************
 *parse the response from the confacct function
 *
 *params
 *  data - NSString* - xml data returned from a network request
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *      error      => error code if there is an error
 *      anum       => account number
 *      name       => name of account
 *      addr1      => address line one
 *      addr2      => address line two
 *      city       => account city
 *      state      => account state
 *      zip        => account zip code
 *      phone      => account phone number
 *      fax        => account fax number
 *      contact    => account contact name
 *      email      => account email address
 ***************************************************************/

+ (NSDictionary *) parseConfacctReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%d, message: %@", [rootError code], [rootError localizedDescription]);
        return nil;
    }
    
    TBXMLElement *root = [tbxml rootXMLElement];
    
    //parse errors
    TBXMLElement *error = [TBXML childElementNamed:@"error" parentElement:root];
    if (error == nil) {
        NSLog(@"parseFindacctReply could not find error");
        return nil;
    }
    NSString *errorString = [TBXML textForElement:error];
    
    NSString *errorMessage = [PMNetwork checkErrors:errorString];
    if (errorMessage != nil) {
        return [NSDictionary dictionaryWithObject:errorMessage forKey:@"error"];
    }
    
    NSArray *keys = [PMAccount dictionaryKeys];
    NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
    for(NSString *key in keys) {
        TBXMLElement *element = [TBXML childElementNamed:key parentElement:root];
        if(element) {
            //special case for anum value
            if ([key isEqualToString:@"anum"]) {
                NSNumber *anum = [NSNumber numberWithInteger:[[TBXML textForElement:element] intValue]];
                [response setObject:anum forKey:key];
            } else {
                [response setObject:[TBXML textForElement:element] forKey:key];
            }
        } else {
            NSLog(@"parse confacct: element not found for key %@", key);
        }
    }

    
    
    return response;
}

@end
