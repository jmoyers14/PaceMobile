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
@interface CreateOrderViewController : UIViewController <PMNetworkOperationDelegate, UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet UITextField *commentView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *storeLabel;
@property (nonatomic, strong) IBOutlet UILabel *accountLabel;

- (IBAction)cancel:(id)sender;
@end
