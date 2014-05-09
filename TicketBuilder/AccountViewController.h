//
//  AccountViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/8/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkViewController.h"
#import "PMUser.h"
#import "PMNetworkOperation.h"
#import "PMXMLBuilder.h"
#import "FuncitonCell.h"
@interface AccountViewController : UIViewController <PMNetworkOperationDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;

@end
