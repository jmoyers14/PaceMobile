//
//  NetworkViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/2/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMNetworkOperation.h"
#import "PMNetwork.h"
#import "PMXMLBuilder.h"

@interface UIViewController (NetworkViewController)
- (void) showSpinner;
- (void) hideSpinner;
- (void) displayErrorMessage:(NSString *)message;
@end
