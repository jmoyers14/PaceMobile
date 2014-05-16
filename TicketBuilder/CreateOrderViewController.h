//
//  CreateOrderViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkViewController.h"
#import "PMUser.h"
#import "PMNetwork.h"
#import "PMXMLBuilder.h"
#import "PMNetworkOperation.h"
@interface CreateOrderViewController : UIViewController <PMNetworkOperationDelegate>
@property (nonatomic, strong) IBOutlet UITextView *commentView;

- (IBAction)create:(id)sender;
- (IBAction)cancel:(id)sender;
@end
