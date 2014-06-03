//
//  PMNetworkOperation.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/5/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMNetwork.h"

@protocol PMNetworkOperationDelegate;

@interface PMNetworkOperation : NSOperation

@property (nonatomic, assign) id <PMNetworkOperationDelegate> delegate;

@property (nonatomic, readonly, strong) NSString *identifier;
@property (nonatomic, readonly, strong) NSString *url;
@property (nonatomic, readonly, strong) NSString *xml;
@property (nonatomic, readonly, strong) NSString *responseXML;
@property (nonatomic, readonly, assign) BOOL failed;

- (id) initWithIdentifier:(NSString *)identifier XML:(NSString *)xml andURL:(NSString *)url;
- (BOOL) timedOut;
@end


@protocol PMNetworkOperationDelegate <NSObject>

@required
- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation;
@end
