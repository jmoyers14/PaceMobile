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
 *remove and replace &amp; and other html encodings from the xml
 *
 *params
 *  xml - xml string to be decoded
 *
 *return
 *  NSString* - decoded xml string
 *
 **************************************************************/
+ (NSString *) decodeXML:(NSString *)xml {
    
    return nil;
}

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
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    NSMutableArray *stores = [NSMutableArray arrayWithCapacity:storeCnt];
    if (storeCnt > 0) {
        //Parse stores
        TBXMLElement *storeElement     = [TBXML childElementNamed:@"stores" parentElement:root];
        TBXMLElement *storeNameElement = [TBXML childElementNamed:@"storeName" parentElement:storeElement];
        TBXMLElement *storeIdElement   = [TBXML childElementNamed:@"storeId" parentElement:storeElement];
        PMStore *store1 = [[PMStore alloc] initWithName:[TBXML textForElement:storeNameElement]
                                              andID:[[TBXML textForElement:storeIdElement] integerValue]];

        [stores addObject:store1];

        while ((storeElement = storeElement->nextSibling)) {
            storeNameElement = [TBXML childElementNamed:@"storeName" parentElement:storeElement];
            storeIdElement   = [TBXML childElementNamed:@"storeId" parentElement:storeElement];
            PMStore *store   = [[PMStore alloc] initWithName:[TBXML textForElement:storeNameElement]
                                                  andID:[[TBXML textForElement:storeIdElement] integerValue]];
            [stores addObject:store];
        }
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
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    NSMutableArray *accounts = [NSMutableArray arrayWithCapacity:acctCnt];
    

    TBXMLElement *acctElement     = [TBXML childElementNamed:@"accts" parentElement:root];
    if (acctElement) {
        do {
            TBXMLElement *acctNameElement = [TBXML childElementNamed:@"name" parentElement:acctElement];
            TBXMLElement *acctNumElement  = [TBXML childElementNamed:@"anum" parentElement:acctElement];
            TBXMLElement *acctRowElement  = [TBXML childElementNamed:@"acctRow" parentElement:acctElement];
            PMAccount *account1 = [[PMAccount alloc] initWithName:[TBXML textForElement:acctNameElement]
                                                              row:[[TBXML textForElement:acctRowElement] integerValue]
                                                              num:[[TBXML textForElement:acctNumElement] integerValue]];
            [accounts addObject:account1];
        } while((acctElement = acctElement->nextSibling));
    }

    NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:acctCnt], @"acctCnt", accounts, @"accounts", nil];
    
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
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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

/**************************************************************
 *parse the response from the checkord function
 *
 *params
 *  data - NSString* - xml data returned from a network request
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *      error      => error code if there is an error
 *      ordCnt    => number of orders returned
 *      orders   => array of order objects returned
 ***************************************************************/
+ (NSDictionary *) parseCheckordReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    
    //Parse orders
    TBXMLElement *ordCntEle = [TBXML childElementNamed:@"ordCnt" parentElement:root];
    NSInteger ordCnt = [[TBXML textForElement:ordCntEle] integerValue];
    NSMutableArray *orders = [NSMutableArray arrayWithCapacity:ordCnt];

    if (ordCnt > 0) {
        TBXMLElement *ordersElement = [TBXML childElementNamed:@"orders" parentElement:root];
        TBXMLElement *ordRowEle = [TBXML childElementNamed:@"ordRow" parentElement:ordersElement];
        TBXMLElement *ordDateEle = [TBXML childElementNamed:@"ordDate" parentElement:ordersElement];
        TBXMLElement *ordNumEle = [TBXML childElementNamed:@"ordNum" parentElement:ordersElement];
        TBXMLElement *ordComment = [TBXML childElementNamed:@"ordComment" parentElement:ordersElement];
        [orders addObject:[[PMOrder alloc] initWithRow:[[TBXML textForElement:ordRowEle] integerValue]
                                              Date:[TBXML textForElement:ordDateEle]
                                          orderNum:[[TBXML textForElement:ordNumEle] integerValue]
                                           comment:[TBXML textForElement:ordComment]]];
    
        while((ordersElement = ordersElement->nextSibling)) {
            ordRowEle = [TBXML childElementNamed:@"ordRow" parentElement:ordersElement];
            ordDateEle = [TBXML childElementNamed:@"ordDate" parentElement:ordersElement];
            ordNumEle = [TBXML childElementNamed:@"ordNum" parentElement:ordersElement];
            ordComment = [TBXML childElementNamed:@"ordComment" parentElement:ordersElement];
            [orders addObject:[[PMOrder alloc] initWithRow:[[TBXML textForElement:ordRowEle] integerValue]
                                                  Date:[TBXML textForElement:ordDateEle]
                                              orderNum:[[TBXML textForElement:ordNumEle] integerValue]
                                               comment:[TBXML textForElement:ordComment]]];
        }
    }
    NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:ordCnt], @"ordCnt", orders, @"orders", nil];
    
    return  response;
}

/**************************************************************
 *parse the response from the createord function
 *
 *params
 *  data - NSString* - xml data returned from a network request
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *      error      => error code if there is an error
 *      ordCnt    => number of orders returned
 *      orders   => array of order objects returned
 ***************************************************************/
+ (NSDictionary *) parseCreateordReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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

    TBXMLElement *ordRowElement = [TBXML childElementNamed:@"ordRow" parentElement:root];
    TBXMLElement *ordNumElement = [TBXML childElementNamed:@"ordNum" parentElement:root];
    
    NSNumber *ordRow = [NSNumber numberWithInteger:[[TBXML textForElement:ordRowElement] integerValue]];
    NSNumber *ordNum = [NSNumber numberWithInteger:[[TBXML textForElement:ordNumElement] integerValue]];
    
    NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:ordRow, @"ordRow", ordNum, @"ordNum", nil];
    
    return response;
}

/**************************************************************
 *parse the response from the deleteord function
 *
 *params
 *  data - NSString* - xml data returned from a network request
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *      error      => error code if there is an error
 ***************************************************************/
+ (NSDictionary *) parseDeleteordReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    
    
    return [[NSDictionary alloc] init];
}


/**************************************************************
 *parse the response from the additem function
 *
 *params
 *  data - NSString* - xml data returned from a network request
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *      error     => error code if there is an error
 *      ordTot    => total of order without cores and tax
 *      coreTot   => array of order objects returned
 *      taxTot    => total tax for order
 *      itemRow   => id of order record in database
 ***************************************************************/
+ (NSDictionary *)parseAdditemReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    
    TBXMLElement *ordTotElement = [TBXML childElementNamed:@"ordTot" parentElement:root];
    TBXMLElement *coreTotElement = [TBXML childElementNamed:@"coreTot" parentElement:root];
    TBXMLElement *taxTotElement = [TBXML childElementNamed:@"taxTot" parentElement:root];
    TBXMLElement *itemRowElement = [TBXML childElementNamed:@"itemRow" parentElement:root];
    
    NSDecimalNumber *ordTot = [NSDecimalNumber decimalNumberWithString:[TBXML textForElement:ordTotElement]];
    NSDecimalNumber *coreTot = [NSDecimalNumber decimalNumberWithString:[TBXML textForElement:coreTotElement]];
    NSDecimalNumber *taxTot = [NSDecimalNumber decimalNumberWithString:[TBXML textForElement:taxTotElement]];
    NSNumber *itemRow = [NSNumber numberWithInteger:[[TBXML textForElement:itemRowElement] integerValue]];
    
    NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:ordTot, @"ordTot",
                              coreTot, @"coreTot", taxTot, @"taxTot", itemRow, @"itemRow", nil];
    
    return response;
}


/**************************************************************
 *parse the response from the edititem function
 *
 *params
 *  data - NSString* - xml data returned from a network request
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *      error     => error code if there is an error
 *      ordTot    => total of order without cores and tax
 *      coreTot   => total of core transactions
 *      taxTot    => total tax for order
 ***************************************************************/
+ (NSDictionary *) parseEdititemReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
  
    TBXMLElement *ordTotElement = [TBXML childElementNamed:@"ordTot" parentElement:root];
    TBXMLElement *coreTotElement = [TBXML childElementNamed:@"coreTot" parentElement:root];
    TBXMLElement *taxTotElement = [TBXML childElementNamed:@"taxTot" parentElement:root];
    
    NSNumber *ordTot = [NSNumber numberWithInteger:[[TBXML textForElement:ordTotElement] integerValue]];
    NSNumber *coreTot = [NSNumber numberWithInteger:[[TBXML textForElement:coreTotElement] integerValue]];
    NSNumber *taxTot = [NSNumber numberWithInteger:[[TBXML textForElement:taxTotElement] integerValue]];
    
    NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:ordTot, @"ordTot",
                              coreTot, @"coreTot", taxTot, @"taxTot", nil];
    
    return response;
}


/**************************************************************
 *parse the response from the deleteitem function
 *
 *params
 *  data - NSString* - xml data returned from a network request
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *      error     => error code if there is an error
 *      ordTot    => total of order without cores and tax
 *      coreTot   => total of core transactions
 *      taxTot    => total tax for order
 ***************************************************************/
+ (NSDictionary *) parseDeleteitemReply:(NSString *)xml {
    return [self parseEdititemReply:xml];
}


+(PMTransactionType) transTypeForString:(NSString *)string {
    
    if([string isEqualToString:@"S"]) {
        return SaleTrans;
    } else if([string isEqualToString:@"R"]) {
        return ReturnTrans;
    } else if([string isEqualToString:@"D"]) {
        return DefectTrans;
    } else if([string isEqualToString:@"C"]) {
        return CoreTrans;
    } else {
        NSLog(@"Type %@ does not exist", string);
    }
    return -1;
}

/**************************************************************
 *parse the response from the listitems function
 *
 *params
 *  data - NSString* - xml data returned from a network request
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *      error     => error code if there is an error
 *      ordTot    => total of order without cores and tax
 *      coreTot   => total of core transactions
 *      taxTot    => total tax for order
 *      itemCnt   => amount of items returned
 *      items     => Array of PMItem objects
 ***************************************************************/
+ (NSDictionary *) parseListitemsReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    
    TBXMLElement *ordTotElement = [TBXML childElementNamed:@"ordTot" parentElement:root];
    TBXMLElement *coreTotElement = [TBXML childElementNamed:@"coreTot" parentElement:root];
    TBXMLElement *taxTotElement = [TBXML childElementNamed:@"taxTot" parentElement:root];
    TBXMLElement *itemCntElement = [TBXML childElementNamed:@"itemCnt" parentElement:root];
    
    NSDecimalNumber *ordTot = [NSDecimalNumber decimalNumberWithString:[TBXML textForElement:ordTotElement]];
    NSDecimalNumber *coreTot = [NSDecimalNumber decimalNumberWithString:[TBXML textForElement:coreTotElement]];
    NSDecimalNumber *taxTot = [NSDecimalNumber decimalNumberWithString:[TBXML textForElement:taxTotElement]];
    NSNumber *itemCnt = [NSNumber numberWithInteger:[[TBXML textForElement:itemCntElement] integerValue]];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if([itemCnt integerValue] > 0) {
        TBXMLElement *itemElement = [TBXML childElementNamed:@"items" parentElement:root];
        TBXMLElement *itemRowElement = [TBXML childElementNamed:@"itemRow" parentElement:itemElement];
        TBXMLElement *partRowElement = [TBXML childElementNamed:@"partRow" parentElement:itemElement];
        TBXMLElement *lineElement = [TBXML childElementNamed:@"line" parentElement:itemElement];
        TBXMLElement *partElement = [TBXML childElementNamed:@"part" parentElement:itemElement];
        TBXMLElement *qtyElement = [TBXML childElementNamed:@"qty" parentElement:itemElement];
        TBXMLElement *tranTypeElement = [TBXML childElementNamed:@"tranType" parentElement:itemElement];
        
        PMPart *part = [[PMPart alloc] initWithPartRow:[[TBXML textForElement:partRowElement] integerValue]
                                                  line:[TBXML textForElement:lineElement]
                                                  part:[TBXML textForElement:partElement]];
        
        PMItem *item = [[PMItem alloc] initWithItemRow:[[TBXML textForElement:itemRowElement] integerValue]
                                                  part:part
                                              quantity:[[TBXML textForElement:qtyElement] integerValue]
                                             transType:[PMNetwork transTypeForString:[TBXML textForElement:tranTypeElement]]];
        [items addObject:item];
        
        while ((itemElement = itemElement->nextSibling)) {
            itemRowElement  = [TBXML childElementNamed:@"itemRow" parentElement:itemElement];
            partRowElement  = [TBXML childElementNamed:@"partRow" parentElement:itemElement];
            lineElement     = [TBXML childElementNamed:@"line" parentElement:itemElement];
            partElement     = [TBXML childElementNamed:@"part" parentElement:itemElement];
            qtyElement      = [TBXML childElementNamed:@"qty" parentElement:itemElement];
            tranTypeElement = [TBXML childElementNamed:@"tranType" parentElement:itemElement];
            
            PMPart *part = [[PMPart alloc] initWithPartRow:[[TBXML textForElement:partRowElement] integerValue]
                                                      line:[TBXML textForElement:lineElement]
                                                      part:[TBXML textForElement:partElement]];

            
            PMItem *item = [[PMItem alloc] initWithItemRow:[[TBXML textForElement:itemRowElement] integerValue]
                                                      part:part
                                                  quantity:[[TBXML textForElement:qtyElement] integerValue]
                                                 transType:[PMNetwork transTypeForString:[TBXML textForElement:tranTypeElement]]];
            
            
            [items addObject:item];
        }
        
        
        
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:ordTot, @"ordTot", coreTot, @"coreTot", taxTot, @"taxTot", itemCnt, @"itemCnt", items, @"items", nil];

    return dictionary;
}


/**************************************************************
 *parse the response from the inqacct function
 *
 *params
 *  data - NSString* - xml data returned from a network request
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *      error       => error code if there is an error
 *      currBal     => current balance
 *      age1Bal     => age period 1 balance
 *      age2Bal     => age period 2 balance
 *      age3Bal     => age period 3 balance
 *      age4Bal     => age period 4 balance
 *      age1Des     => age period 1 description
 *      age2Des     => age period 2 description
 *      age3Des     => age period 3 description
 *      age4Des     => age period 4 description
 *      hist1Sales  => history period 1 sales
 *      hist1Profit => history period 1 profit
 *      hist1Des    => history period 1 desctiption
 *      hist2Sales  => history period 2 sales
 *      hist2Profit => history period 2 profit
 *      hist2Des    => history period 2 desctiption
 ***************************************************************/
+ (NSDictionary *) parseInqacctReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
    NSArray *stringKeys = [NSArray arrayWithObjects:@"age1Des", @"age2Des", @"age3Des", @"age4Des", @"hist1Des", @"hist2Des", nil];
    NSArray *decKeys = [NSArray arrayWithObjects:@"currBal", @"age1Bal", @"age2Bal", @"age3Bal", @"age4Bal", @"hist1Sales", @"hist2Sales", @"hist1Profit", @"hist2Profit", nil];
    
    for (NSString *key in stringKeys) {
        TBXMLElement *element = [TBXML childElementNamed:key parentElement:root];
        [response setObject:[TBXML textForElement:element] forKey:key];
    }
    for (NSString *key in decKeys) {
        TBXMLElement *element = [TBXML childElementNamed:key parentElement:root];
        [response setObject:[NSDecimalNumber decimalNumberWithString:[TBXML textForElement:element]] forKey:key];
    }
    
    return response;
}


#pragma mark - catalog parsing

/**************************************************************
 *parse the response from the years
 *
 *params
 *  xml - NSString* - xml data returned from a network request
 *  type - PMCatalogReply - flag to tell the type of function
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *  error - error message, nil if no error
 *  years - array of strings for years
 ***************************************************************/
+ (NSDictionary *) parseYearsReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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

    NSMutableArray *years = [[NSMutableArray alloc] init];
    TBXMLElement *yearElement = [TBXML childElementNamed:@"year" parentElement:root];
    if (yearElement) {
        [years addObject:[TBXML textForElement:yearElement]];
    
        while ((yearElement = yearElement->nextSibling)) {
            [years addObject:[TBXML textForElement:yearElement]];
        }
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:years, @"years", nil];
}

/**************************************************************
 *parse the response from the makes
 *
 *params
 *  xml - NSString* - xml data returned from a network request
 *  type - PMCatalogReply - flag to tell the type of function
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *  error - error message, nil if no error
 *  makes - array of strings for years
 ***************************************************************/

+ (NSDictionary *) parseMakesReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    
    NSMutableArray *makes = [[NSMutableArray alloc] init];
    TBXMLElement *makesElement = [TBXML childElementNamed:@"makes" parentElement:root];
    if (makesElement) {
        TBXMLElement *makeElement = [TBXML childElementNamed:@"make" parentElement:makesElement];
        TBXMLElement *makeDescElement = [TBXML childElementNamed:@"makeDesc" parentElement:makesElement];
        PMMake *make = [[PMMake alloc] initWithMake:[TBXML textForElement:makeElement]
                                           makeDesc:[TBXML textForElement:makeDescElement]];
        [makes addObject:make];
        
        while ((makesElement = makesElement->nextSibling)) {
            makeElement = [TBXML childElementNamed:@"make" parentElement:makesElement];
            makeDescElement = [TBXML childElementNamed:@"makeDesc" parentElement:makesElement];
            PMMake *make = [[PMMake alloc] initWithMake:[TBXML textForElement:makeElement]
                                               makeDesc:[TBXML textForElement:makeDescElement]];
            [makes addObject:make];
        }
    }
    
    
    return [NSDictionary dictionaryWithObjectsAndKeys:makes, @"makes", nil];
    
    return nil;
}

/**************************************************************
 *parse the response from the models call
 *
 *params
 *  xml - NSString* - xml data returned from a network request
 *  type - PMCatalogReply - flag to tell the type of function
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *  error - error message, nil if no error
 *  years - array of strings for years
 ***************************************************************/
+ (NSDictionary *) parseModelsReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    TBXMLElement *modelsElement = [TBXML childElementNamed:@"models" parentElement:root];
    if (modelsElement) {
        TBXMLElement *modelElement = [TBXML childElementNamed:@"model" parentElement:modelsElement];
        TBXMLElement *descElement = [TBXML childElementNamed:@"modelDesc" parentElement:modelsElement];
        PMModel *model = [[PMModel alloc] initWithModel:[TBXML textForElement:modelElement]
                                              modelDesc:[TBXML textForElement:descElement]];
        [models addObject:model];
        while ((modelsElement = modelsElement->nextSibling)) {
            modelElement = [TBXML childElementNamed:@"model" parentElement:modelsElement];
            descElement = [TBXML childElementNamed:@"modelDesc" parentElement:modelsElement];
            PMModel *model = [[PMModel alloc] initWithModel:[TBXML textForElement:modelElement]
                                                  modelDesc:[TBXML textForElement:descElement]];
            [models addObject:model];
            
        }
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:models, @"models", nil];
}

/**************************************************************
 *parse the response from the engines
 *
 *params
 *  xml - NSString* - xml data returned from a network request
 *  type - PMCatalogReply - flag to tell the type of function
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *  error - error message, nil if no error
 *  years - array of strings for years
 ***************************************************************/

+ (NSDictionary *) parseEnginesReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    
    NSMutableArray *engines = [[NSMutableArray alloc] init];
    
    TBXMLElement *enginesElement = [TBXML childElementNamed:@"engines" parentElement:root];
    if (enginesElement) {
        TBXMLElement *vidElement = [TBXML childElementNamed:@"vid" parentElement:enginesElement];
        TBXMLElement *descElement = [TBXML childElementNamed:@"engineDesc" parentElement:enginesElement];
        PMEngine *engine = [[PMEngine alloc] initWithVid:[TBXML textForElement:vidElement]
                                              engineDesc:[TBXML textForElement:descElement]];
        [engines addObject:engine];
        
        while ((enginesElement = enginesElement->nextSibling)) {
            vidElement = [TBXML childElementNamed:@"vid" parentElement:enginesElement];
            descElement = [TBXML childElementNamed:@"engineDesc" parentElement:enginesElement];
            PMEngine *engine = [[PMEngine alloc] initWithVid:[TBXML textForElement:vidElement]
                                                  engineDesc:[TBXML textForElement:descElement]];
            [engines addObject:engine];
        }
    }
    
    
    return [NSDictionary dictionaryWithObjectsAndKeys:engines, @"engines", nil];
}

/**************************************************************
 *parse the response from the groups
 *
 *params
 *  xml - NSString* - xml data returned from a network request
 *  type - PMCatalogReply - flag to tell the type of function
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *  error - error message, nil if no error
 *  years - array of strings for years
 ***************************************************************/

+ (NSDictionary *) parseGroupsReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    TBXMLElement *groupsElement = [TBXML childElementNamed:@"groups" parentElement:root];
    if (groupsElement) {
        TBXMLElement *groupElement = [TBXML childElementNamed:@"group" parentElement:groupsElement];
        TBXMLElement *descElement = [TBXML childElementNamed:@"groupDesc" parentElement:groupsElement];
        PMGroup *group = [[PMGroup alloc] initWithGroup:[TBXML textForElement:groupsElement]
                                              groupDesc:[TBXML textForElement:groupsElement]];
        [groups addObject:group];
        while ((groupsElement = groupsElement->nextSibling)) {
            groupElement = [TBXML childElementNamed:@"group" parentElement:groupsElement];
            descElement = [TBXML childElementNamed:@"groupDesc" parentElement:groupsElement];
            PMGroup *group = [[PMGroup alloc] initWithGroup:[TBXML textForElement:groupsElement]
                                                  groupDesc:[TBXML textForElement:groupsElement]];
            [groups addObject:group];
        }
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:groups, @"groups", nil];
}

/**************************************************************
 *parse the response from the subgroups
 *
 *params
 *  xml - NSString* - xml data returned from a network request
 *  type - PMCatalogReply - flag to tell the type of function
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *  error - error message, nil if no error
 *  subgroupss - array of strings for subgroups
 ***************************************************************/
+ (NSDictionary *) parseSubgroupsReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    
    NSMutableArray *subGroups = [[NSMutableArray alloc] init];
    TBXMLElement *subGroupsElement = [TBXML childElementNamed:@"subgroups" parentElement:root];
    if (subGroupsElement) {
        TBXMLElement *subGroupElement = [TBXML childElementNamed:@"subgroup" parentElement:subGroupsElement];
        TBXMLElement *descElement = [TBXML childElementNamed:@"subgroupDesc" parentElement:subGroupsElement];
        PMSubGroup *subGroup = [[PMSubGroup alloc] initWithSubGroup:[TBXML textForElement:subGroupElement]
                                                       subGroupDesc:[TBXML textForElement:descElement]];
        [subGroups addObject:subGroup];
        while ((subGroupsElement = subGroupsElement->nextSibling)) {
            subGroupElement = [TBXML childElementNamed:@"subgroup" parentElement:subGroupsElement];
            descElement = [TBXML childElementNamed:@"subgroupDesc" parentElement:subGroupsElement];
            PMSubGroup *subGroup = [[PMSubGroup alloc] initWithSubGroup:[TBXML textForElement:subGroupElement]
                                                           subGroupDesc:[TBXML textForElement:descElement]];
            [subGroups addObject:subGroup];
        }
    }
    
    
    
    
    return [NSDictionary dictionaryWithObjectsAndKeys:subGroups, @"subgroups", nil];
}

/**************************************************************
 *parse the response from the parts call
 *
 *params
 *  xml - NSString* - xml data returned from a network request
 *  type - PMCatalogReply - flag to tell the type of function
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *  error - error message, nil if no error
 *  partTypes - array of PMPartType objects
 ***************************************************************/

+ (NSDictionary *) parsePartsReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    
    NSMutableArray *partTypes = [[NSMutableArray alloc] init];
    TBXMLElement *partTypesElement = [TBXML childElementNamed:@"partTypes" parentElement:root];
    if (partTypesElement) {
        do {
            TBXMLElement *typeCodeElement = [TBXML childElementNamed:@"partType" parentElement:partTypesElement];
            TBXMLElement *descElement = [TBXML childElementNamed:@"partTypeDesc" parentElement:partTypesElement];
            TBXMLElement *partsElement = [TBXML childElementNamed:@"parts" parentElement:partTypesElement];
            NSMutableArray *parts = [[NSMutableArray alloc] init];
            if (partsElement) {                                
                do{
                    TBXMLElement *partRowElement  = [TBXML childElementNamed:@"partRow" parentElement:partsElement];
                    TBXMLElement *lineElement     = [TBXML childElementNamed:@"line" parentElement:partsElement];
                    TBXMLElement *partElement     = [TBXML childElementNamed:@"part" parentElement:partsElement];
                    TBXMLElement *partDescElement = [TBXML childElementNamed:@"partDesc" parentElement:partsElement];
                    TBXMLElement *longDescElement = [TBXML childElementNamed:@"longDesc" parentElement:partsElement];
                    TBXMLElement *manufElement    = [TBXML childElementNamed:@"manuf" parentElement:partsElement];
                    TBXMLElement *listElement     = [TBXML childElementNamed:@"list" parentElement:partsElement];
                    TBXMLElement *priceElement    = [TBXML childElementNamed:@"price" parentElement:partsElement];
                    TBXMLElement *coreElement     = [TBXML childElementNamed:@"core" parentElement:partsElement];
                    TBXMLElement *instockElement  = [TBXML childElementNamed:@"instock" parentElement:partsElement];
                    PMPart *part = [[PMPart alloc] initWithPartRow:[[TBXML textForElement:partRowElement] integerValue]
                                                              line:[TBXML textForElement:lineElement]
                                                              part:[TBXML textForElement:partElement]
                                                       description:[TBXML textForElement:partDescElement]
                                                    longDesciption:[TBXML textForElement:longDescElement]
                                                             manuf:[TBXML textForElement:manufElement]
                                                              list:[[TBXML textForElement:listElement] integerValue]
                                                             price:[NSDecimalNumber decimalNumberWithString:[TBXML textForElement:priceElement]]
                                                              core:[NSDecimalNumber decimalNumberWithString:[TBXML textForElement:coreElement]]
                                                           instock:[[TBXML textForElement:instockElement] integerValue]];
                    
                    [parts addObject:part];
                } while ((partsElement = partsElement->nextSibling));
            }
            PMPartType *partType = [[PMPartType alloc] initWithCode:[TBXML textForElement:typeCodeElement] description:[TBXML textForElement:descElement] parts:parts];
            [partTypes addObject:partType];
            
        } while ((partTypesElement = partTypesElement->nextSibling));
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:partTypes, @"partTypes", nil];
}

+ (PMType) parsePMType:(NSString*)t {
    if ([t isEqualToString:@"M"]) {
        return PMTypeMain;
    } else if([t isEqualToString:@"S"]) {
        return PMTypeSupresed;
    } else if([t isEqualToString:@"A"]) {
        return PMTypeAlternate;
    } else if([t isEqualToString:@"X"]) {
        return PMTypeXref;
    } else {
        NSLog(@"type %@ could not be parsed", t);
        return 0;
    }
}

+ (BOOL) parseTaxString:(NSString *)s {
    if ([s isEqualToString:@"Y"]) {
        return YES;
    } else {
        return NO;
    }
}

/**************************************************************
 *parse the response from the findpart call
 *
 *params
 *  xml - NSString* - xml data returned from a network request
 *  type - PMCatalogReply - flag to tell the type of function
 *
 *return
 *  NSDictionary with the following keys value pairs:
 *  error - error message, nil if no error
 *  parts - array of PMPartType objects
 ***************************************************************/
+ (NSDictionary *) parseFindPartReply:(NSString *)xml {
    //Extract root element
    NSError *rootError;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&rootError];
    if(rootError) {
        NSLog(@"Error value pasrsing error code:%ld, message: %@", (long)[rootError code], [rootError localizedDescription]);
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
    
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    
    TBXMLElement *partCountElement = [TBXML childElementNamed:@"partCnt" parentElement:root];
    NSNumber *partCnt = [NSNumber numberWithInt:[[TBXML textForElement:partCountElement] integerValue]];
    if ([partCnt integerValue] > 0) {
        TBXMLElement *partsElement = [TBXML childElementNamed:@"parts" parentElement:root];
        do {
            TBXMLElement *partRowEle = [TBXML childElementNamed:@"partRow" parentElement:partsElement];
            TBXMLElement *lineEle = [TBXML childElementNamed:@"line" parentElement:partsElement];
            TBXMLElement *partEle = [TBXML childElementNamed:@"part" parentElement:partsElement];
            TBXMLElement *partDescEle = [TBXML childElementNamed:@"partDesc" parentElement:partsElement];
            TBXMLElement *partTypeEle = [TBXML childElementNamed:@"partType" parentElement:partsElement];
            TBXMLElement *instockEle = [TBXML childElementNamed:@"instock" parentElement:partsElement];
            TBXMLElement *instockAllEle = [TBXML childElementNamed:@"instockAll" parentElement:partsElement];
            TBXMLElement *priceEle = [TBXML childElementNamed:@"price" parentElement:partsElement];
            TBXMLElement *coreEle = [TBXML childElementNamed:@"core" parentElement:partsElement];
            TBXMLElement *weightEle = [TBXML childElementNamed:@"weight" parentElement:partsElement];
            TBXMLElement *taxpartEle = [TBXML childElementNamed:@"taxpart" parentElement:partsElement];
            TBXMLElement *taxcoreEle = [TBXML childElementNamed:@"taxpart" parentElement:partsElement];
            TBXMLElement *stateTaxPartEle = [TBXML childElementNamed:@"stateTaxPart" parentElement:partsElement];
            TBXMLElement *stateTaxCoreEle = [TBXML childElementNamed:@"stateTaxCore" parentElement:partsElement];
            TBXMLElement *localTaxPartEle = [TBXML childElementNamed:@"localTaxPart" parentElement:partsElement];
            TBXMLElement *localTaxCoreEle = [TBXML childElementNamed:@"localTaxCore" parentElement:partsElement];
            
            PMPart *part = [[PMPart alloc] initWithPartRow:[[TBXML textForElement:partRowEle] integerValue]
                                                      line:[TBXML textForElement:lineEle]
                                                      part:[TBXML textForElement:partEle]];
            [part setPartDesc:[TBXML textForElement:partDescEle]];
            [part setPartType:[PMNetwork parsePMType:[TBXML textForElement:partTypeEle]]];
            [part setInstock:[[TBXML textForElement:instockEle] integerValue]];
            [part setInstockAll:[[TBXML textForElement:instockAllEle] integerValue]];
            [part setPrice:[NSDecimalNumber decimalNumberWithString:[TBXML textForElement:priceEle]]];
            [part setCore:[NSDecimalNumber decimalNumberWithString:[TBXML textForElement:coreEle]]];
            [part setWeight:[NSDecimalNumber decimalNumberWithString:[TBXML textForElement:weightEle]]];
            [part setTaxpart:[PMNetwork parseTaxString:[TBXML textForElement:taxpartEle]]];
            [part setTaxcore:[PMNetwork parseTaxString:[TBXML textForElement:taxcoreEle]]];
            [part setStateTaxPart:[PMNetwork parseTaxString:[TBXML textForElement:stateTaxPartEle]]];
            [part setStateTaxCore:[PMNetwork parseTaxString:[TBXML textForElement:stateTaxCoreEle]]];
            [part setLocalTaxPart:[PMNetwork parseTaxString:[TBXML textForElement:localTaxPartEle]]];
            [part setLocalTaxCore:[PMNetwork parseTaxString:[TBXML textForElement:localTaxCoreEle]]];
            
            [parts addObject:part];
            
        } while ((partsElement = partsElement->nextSibling));
    }
                         
    NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:partCnt, @"partCnt", parts, @"parts", nil];
    
    return response;
}

@end

