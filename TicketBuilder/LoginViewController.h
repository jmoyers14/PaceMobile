//
//  LoginViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/1/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMUser.h"
#import "PMNetwork.h"
#import "PMXMLBuilder.h"
#import "IPConfigViewController.h"
#import "NetworkViewController.h"
#import "PMNetworkOperation.h"

@interface LoginViewController : UIViewController <IPConfigDelegate, UIPopoverControllerDelegate, UITextFieldDelegate, PMNetworkOperationDelegate>

@property IBOutlet UITextField *usernameField;
@property IBOutlet UITextField *passwordField;
@property IBOutlet UIView *loginView;
@property IBOutlet UIActivityIndicatorView *spinner;

@end
