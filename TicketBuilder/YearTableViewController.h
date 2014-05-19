//
//  YearTableViewController.h
//  TicketBuilder
//
//  Created by Jeremy Moyers on 4/23/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkViewController.h"



@interface YearTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, PMNetworkOperationDelegate>
@property IBOutlet UISearchBar *yearSearchBar;
@end
