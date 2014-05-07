//
//  PMNetworkOperation.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/5/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMNetworkOperation.h"

@implementation PMNetworkOperation
@synthesize xml = _xml;
@synthesize url = _url;
@synthesize responseXML = _responseXML;
@synthesize failed = _failed;
@synthesize identifier = _identifier;

- (id) initWithIdentifier:(NSString *)identifier XML:(NSString *)xml andURL:(NSString *)url {
    self = [super init];
    if (self) {
        _identifier = identifier;
        _xml = xml;
        _url = url;
        _failed = NO;
    }
    return self;
}

- (void) main {
    
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
    
        _responseXML = [PMNetwork postXML:_xml toURL:_url];
    
        if(![_responseXML length] > 0) {
            _failed = YES;
        }
    
        if (self.isCancelled) {
            return;
        }
    
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(networkRequestOperationDidFinish:) withObject:self waitUntilDone:NO];
    }
}

@end
