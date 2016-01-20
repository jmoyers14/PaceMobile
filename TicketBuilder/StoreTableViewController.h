//
//  StoreTableViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/7/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreTableViewController : UITableViewController <UISearchResultsUpdating>
@property (nonatomic, strong) UISearchController *searchController;
@end
