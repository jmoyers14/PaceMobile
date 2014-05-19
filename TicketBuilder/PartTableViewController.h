//
//  PartTableViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/18/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMUser.h"
#import "FindPartViewControllerTableViewController.h"

@interface PartTableViewController : UITableViewController
@property (nonatomic, strong) PMPart *currentPart;
@property (nonatomic, strong) IBOutlet UILabel *partLabel;
@property (nonatomic, strong) IBOutlet UILabel *lineLabel;
@property (nonatomic, strong) IBOutlet UILabel *descLabel;
@property (nonatomic, strong) IBOutlet UILabel *typeLabel;
@property (nonatomic, strong) IBOutlet UILabel *weightLabel;
@property (nonatomic, strong) IBOutlet UILabel *stockLabel;
@property (nonatomic, strong) IBOutlet UILabel *allStockLabel;
@property (nonatomic, strong) IBOutlet UILabel *pricePartLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceCoreLabel;
@property (nonatomic, strong) IBOutlet UILabel *partTaxLabel;
@property (nonatomic, strong) IBOutlet UILabel *coreTLabel;
@property (nonatomic, strong) IBOutlet UILabel *sPartTaxLabel;
@property (nonatomic, strong) IBOutlet UILabel *sCoreTaxLabel;
@property (nonatomic, strong) IBOutlet UILabel *lPartTaxLabel;
@property (nonatomic, strong) IBOutlet UILabel *lCoreTaxLabel;

@end
