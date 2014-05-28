//
//  BalancesTableViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/28/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkViewController.h"
#import "PMUser.h"

@interface BalancesTableViewController : UITableViewController <PMNetworkOperationDelegate>

@property (nonatomic, strong) IBOutlet UILabel *age1BalLabel;
@property (nonatomic, strong) IBOutlet UILabel *age2BalLabel;
@property (nonatomic, strong) IBOutlet UILabel *age3BalLabel;
@property (nonatomic, strong) IBOutlet UILabel *age4BalLabel;
@property (nonatomic, strong) IBOutlet UILabel *age1DesLabel;
@property (nonatomic, strong) IBOutlet UILabel *age2DesLabel;
@property (nonatomic, strong) IBOutlet UILabel *age3DesLabel;
@property (nonatomic, strong) IBOutlet UILabel *age4DesLabel;
@property (nonatomic, strong) IBOutlet UILabel *hist1SalesLabel;
@property (nonatomic, strong) IBOutlet UILabel *hist2SalesLabel;
@property (nonatomic, strong) IBOutlet UILabel *hist1DesLabel;
@property (nonatomic, strong) IBOutlet UILabel *hist2DesLabel;
@property (nonatomic, strong) IBOutlet UILabel *hist1ProfitLabel;
@property (nonatomic, strong) IBOutlet UILabel *hist2ProfitLabel;
@property (nonatomic, strong) IBOutlet UILabel *currBalanceLabel;

@end
