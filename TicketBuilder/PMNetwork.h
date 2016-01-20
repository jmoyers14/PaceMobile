//
//  TBNetwork.h
//  TicketBuilder
//
//  Created by Jeremy Moyers on 4/29/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

//  The PMNetwork Class is responsible for building network requests, sending requests, and parsing the request data.
//  Two calls to the PMNetwork class are made for each network request. One to build and send the request, and a second to parse the returned data from the request.

#import <Foundation/Foundation.h>
#import "PMStore.h"
#import "TBXML.h"
#import "PMItem.h"
#import "PMMake.h"
#import "PMModel.h"
#import "PMEngine.h"
#import "PMGroup.h"
#import "PMSubGroup.h"
#import "PMPartType.h"

@interface PMNetwork : NSObject

//Request building/sending
+(NSString *) postXML:(NSString *)xml toURL:(NSString *)url;
    
//Request parsing
+ (NSDictionary *) parseLoginReply:(NSString *)data;
+ (NSDictionary *) parseFindacctReply:(NSString *)data;
+ (NSDictionary *) parseConfacctReply:(NSString *)xml;
+ (NSDictionary *) parseCheckordReply:(NSString *)xml;
+ (NSDictionary *) parseCreateordReply:(NSString *)xml;
+ (NSDictionary *) parseDeleteordReply:(NSString *)xml;
+ (NSDictionary *) parseFinalizeReply:(NSString *)xml;
+ (NSDictionary *) parseAdditemReply:(NSString *)xml;
+ (NSDictionary *) parseEdititemReply:(NSString *)xml;
+ (NSDictionary *) parseDeleteitemReply:(NSString *)xml;
+ (NSDictionary *) parseListitemsReply:(NSString *)xml;
+ (NSDictionary *) parseInqacctReply:(NSString *)xml;
//catalog
+ (NSDictionary *) parseYearsReply:(NSString *)xml;
+ (NSDictionary *) parseMakesReply:(NSString *)xml;
+ (NSDictionary *) parseModelsReply:(NSString *)xml;
+ (NSDictionary *) parseEnginesReply:(NSString *)xml;
+ (NSDictionary *) parseGroupsReply:(NSString *)xml;
+ (NSDictionary *) parseSubgroupsReply:(NSString *)xml;
+ (NSDictionary *) parsePartsReply:(NSString *)xml;

+ (NSDictionary *) parseFindPartReply:(NSString *)xml;

@end
