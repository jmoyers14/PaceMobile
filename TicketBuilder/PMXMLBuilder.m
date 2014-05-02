//
//  TBXMLBuilder.m
//  TicketBuilder
//
//  Created by Jeremy Moyers on 4/28/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMXMLBuilder.h"
#define TB_isValidCreds(u, p) ([u length] > 0 && [p length] > 0)
@implementation PMXMLBuilder




+ (NSString *) formatWithFunction:(NSString *)func user:(NSString *)user pass:(NSString *)pass body:(NSString *)body{
    NSString *xmlHeader = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
    return [NSString stringWithFormat:@"%@<%@><user>%@</user><password>%@</password>%@</%@>", xmlHeader, func, user, pass, body, func];
}


//Return an xml string to log user in with MOE
+ (NSString *) loginXMLWithUsername:(NSString *)username andPassword:(NSString *)password {

    NSString *xml;
    
    //ensure username password is not nil or empty
    if(TB_isValidCreds(username, password)) {
        xml = [PMXMLBuilder formatWithFunction:@"login" user:username pass:password body:@""];
    } else {
        xml = nil;
    }
    return xml;
}

#pragma mark - account
+ (NSString *)findacctXMLWithUsername:(NSString *)username password:(NSString *)password storeID:(NSUInteger)storeID accountNumber:(NSUInteger)anum storeName:(NSString *)name {
    
    NSString *xml;
    if(TB_isValidCreds(username, password) && (anum > 0 || [name length] > 0)) {
        if (name == nil) {
            name = @"";
        }
        NSString *xmlBody = [NSString stringWithFormat:@"<storeId>%lu</storeId><anum>%lu</anum><name>%@</name>", (unsigned long)storeID, (unsigned long)anum, name];
        xml = [PMXMLBuilder formatWithFunction:@"findacct" user:username pass:password body:xmlBody];
    } else {
        xml = nil;
    }
    
    return xml;
}


+ (NSString *) checkcustXMLWithUsername:(NSString *)username password:(NSString *)password storeID:(NSUInteger)storeID accountNumber:(NSUInteger)anum customerNumber:(NSUInteger)cnum {
    
    NSString *xml;
    if(TB_isValidCreds(username, password)) {
        NSString *body;
        //if cnum is 0 remove value from tag
        if(cnum == 0) {
            body = [NSString stringWithFormat:@"<storeId>%lu</storeId><anum>%lu</anum><cnum></cnum>", (unsigned long)storeID, (unsigned long)anum];
        } else {
            body = [NSString stringWithFormat:@"<storeId>%lu</storeId><anum>%lu</anum><cnum>%lu</cnum>", (unsigned long)storeID, (unsigned long)anum, (unsigned long)cnum];
        }
        
        xml = [PMXMLBuilder formatWithFunction:@"checkcust" user:username pass:password body:body];
    } else {
        xml = nil;
    }
    
    return xml;
}

+ (NSString *) confacctXMLWithUsername:(NSString *)username password:(NSString *)password accountRow:(NSUInteger)acctRow {
    
    NSString *xml;
    if(TB_isValidCreds(username, password)) {
        NSString *body = [NSString stringWithFormat:@"<acctRow>%lu</acctRow>", (unsigned long)acctRow];
        xml = [PMXMLBuilder formatWithFunction:@"confacct" user:username pass:password body:body];
    } else {
        xml = nil;
    }
    
    return xml;
}

+ (NSString *) confcustXMLWithUsername:(NSString *)username password:(NSString *)password customerRow:(NSUInteger)custRow {
    
    NSString *xml;
    if(TB_isValidCreds(username, password)) {
        NSString *body = [NSString stringWithFormat:@"<custRow>%lu</custRow>", (unsigned long)custRow];
        xml = [PMXMLBuilder formatWithFunction:@"confcust" user:username pass:password body:body];
    } else {
        xml = nil;
    }
    
    return xml;
}

@end
