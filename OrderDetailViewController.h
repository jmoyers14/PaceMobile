//
//  OrderDetailViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkViewController.h"
#import "PMNetwork.h"
#import "PMXMLBuilder.h"
#import "PMUser.h"
#import "ItemCell.h"
#import "PMNetworkOperation.h"
#import "FindPartViewControllerTableViewController.h"
#import "EditItemViewController.h"
@interface OrderDetailViewController : UITableViewController <PMNetworkOperationDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate>

@property (nonatomic) IBOutlet UILabel *accountNameLabel;
@property (nonatomic) IBOutlet UILabel *accountNumLabel;
@property (nonatomic) IBOutlet UILabel *partTotalLabel;
@property (nonatomic) IBOutlet UILabel *coreTotalLabel;
@property (nonatomic) IBOutlet UILabel *taxTotalLabel;
@property (nonatomic) IBOutlet UILabel *totalLabel;
@property (nonatomic) IBOutlet UIButton *finalizeButton;
@property (nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)deleteOrder:(id)sender;
- (IBAction)finalize:(id)sender;

@end
