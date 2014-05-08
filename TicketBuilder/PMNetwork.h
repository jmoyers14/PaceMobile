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
@interface PMNetwork : NSObject

//Request building/sending
+(NSString *) postXML:(NSString *)xml toURL:(NSString *)url;
    
//Request parsing
+ (NSDictionary *) parseLoginReply:(NSString *)data;
+ (NSDictionary *) parseFindacctReply:(NSString *)data;

@end
