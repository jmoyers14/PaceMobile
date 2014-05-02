//
//  TBNetwork.h
//  TicketBuilder
//
//  Created by Jeremy Moyers on 4/29/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMNetwork : NSObject

+(NSString *) postXML:(NSString *)xml toURL:(NSString *)url;
    



@end
