//
//  AddItemTableViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/18/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMItem.h"
#import "NetworkViewController.h"
@interface AddItemTableViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UISegmentedControl *typeControl;
@property (nonatomic, strong) IBOutlet UITextField *quantityField;
@property (nonatomic, strong) PMPart *currentPart;
@property (nonatomic, strong) IBOutlet UILabel *quantityLabel;
- (IBAction)add:(id)sender;

@end
