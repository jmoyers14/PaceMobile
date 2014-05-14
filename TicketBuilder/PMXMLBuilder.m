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

+ (void) credError:(NSString *)method  {
    NSLog(@"%@: invalid username or password", method);
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

//cnum 0 == blank cnum tag
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
#pragma mark - confacct
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

//acctRow 0 == blank acctRow tag
//line 0 == blank line tag
+ (NSString *) findpartXMLWithUsername:(NSString *)username password:(NSString *)password accountRow:(NSUInteger)acctRow lineNumber:(NSUInteger)line partNumber:(NSUInteger)part {

    id<XMLStreamWriter> xmlWriter = [[XMLWriter alloc] init];
    if(TB_isValidCreds(username, password)) {
        [xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
        [xmlWriter writeStartElement:@"findpart"];
        [xmlWriter writeStartElement:@"user"];
        [xmlWriter writeCharacters:username];
        [xmlWriter writeEndElement];
        [xmlWriter writeStartElement:@"password"];
        [xmlWriter writeCharacters:password];
        [xmlWriter writeEndElement];
        [xmlWriter writeStartElement:@"acctRow"];
        if (acctRow > 0) {
            [xmlWriter writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)acctRow]];
        }
        [xmlWriter writeEndElement];
        [xmlWriter writeStartElement:@"line"];
        if (line > 0) {
            [xmlWriter writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)line]];
        }
        [xmlWriter writeEndElement];
        [xmlWriter writeStartElement:@"part"];
        [xmlWriter writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long)part]];
        [xmlWriter writeEndElement];
        [xmlWriter writeEndElement];
        [xmlWriter writeEndDocument];
    } else {
        NSLog(@"findpart: invalid username and password");
        return nil;
    }
    return [xmlWriter toString];
}

#pragma mark inqpart
+ (NSString *) inqpartXMLWithUsername:(NSString *)username password:(NSString *)password accountRow:(NSUInteger)acctRow partRow:(NSUInteger)partRow {
    
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    if(TB_isValidCreds(username, password)) {
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
    } else {
        [self credError:@"inqpart"];
        return nil;
    }
    
    return [writer toString];
}

#pragma mark - checkord
//custRow 0 == blank customerRow tag
+ (NSString *)checkordXMLWithUsername:(NSString *)username password:(NSString *)password accountRow:(NSUInteger)acctRow customerRow:(NSUInteger)custRow {
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    if(TB_isValidCreds(username, password)) {
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
        if(custRow > 0) {
            [writer writeCharacters:[NSString stringWithFormat:@"%lu", (unsigned long) custRow]];
        }
        [writer writeEndElement];
        [writer writeEndElement];
        [writer writeEndDocument];
    } else {
        [self credError:@"checkord"];
        return nil;
    }
    
    return [writer toString];
}

#pragma mark - createord
+ (NSString *) createordXMLWithUsername:(NSString *)username password:(NSString *)password accountRow:(NSUInteger)acctRow customerRow:(NSUInteger)custRow orderComment:(NSString *)ordComment customerPONumber:(NSUInteger)custPoNum shipText:(NSArray *)shipText messageText:(NSArray *)messageText {
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    
    if([shipText count] > 10 || [messageText count] > 10) {
        NSLog(@"createord: shiptext or message text exceeds 10 lines");
        return nil;
    }
    if(TB_isValidCreds(username, password)) {
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
    } else {
        [self credError:@"createord"];
        return nil;
    }

    return [writer toString];
}

#pragma mark - deleteord
+ (NSString *) deleteordXMLWithUsername:(NSString *)username password:(NSString *)password orderRow:(NSUInteger)ordRow {
    
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    if(TB_isValidCreds(username, password)) {
        [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
        [writer writeStartElement:@"deleteord"];
        [writer writeStartElement:@"user"];
        [writer writeCharacters:username];
        [writer writeEndElement];
        [writer writeStartElement:@"password"];
        [writer writeCharacters:password];
        [writer writeEndElement];
        [writer writeStartElement:@"ordRow"];
        [writer writeCharacters:[NSString stringWithFormat:@"%d", ordRow]];
        [writer writeEndElement];
        [writer writeEndElement];
        [writer writeEndDocument];
    } else {
        [self credError:@"deleteord"];
        return nil;
    }
    
    return nil;
}

#pragma mark - additem

+ (NSString *) additemXMLWithUsername:(NSString *)username password:(NSString *)password accountRow:(NSUInteger)acctRow orderRow:(NSUInteger)ordRow partRow:(NSUInteger)partRow quantity:(NSUInteger)qty tranType:(NSString *)tranType {
    
    id<XMLStreamWriter> writer = [[XMLWriter alloc] init];
    if(TB_isValidCreds(username, password)) {
        [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
        [writer writeStartElement:@"additem"];
        [writer writeStartElement:@"user"];
        [writer writeCharacters:username];
        [writer writeEndElement];
        [writer writeStartElement:@"password"];
        [writer writeCharacters:password];
        [writer writeEndElement];
        [writer writeEndElement];
        [writer writeEndDocument];
    } else {
        [self credError:@"additem"];
        return nil;
    }
    
}



@end
