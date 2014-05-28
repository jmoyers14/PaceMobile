//
//  EditItemViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/26/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkViewController.h"
#import "PMUser.h"
#import "QuantityViewController.h"
@interface EditItemViewController : UITableViewController <PMNetworkOperationDelegate, QuantityDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) IBOutlet UILabel *partLabel;
@property (nonatomic, strong) IBOutlet UILabel *lineLabel;
@property (nonatomic, strong) IBOutlet UILabel *typeLabel;
@property (nonatomic, strong) IBOutlet UILabel *qtyLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) PMItem *item;


@end
