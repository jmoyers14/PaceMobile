//
//  ItemCell.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMItem.h"
@interface ItemCell : UITableViewCell
@property (nonatomic) IBOutlet UILabel *lineLabel;
@property (nonatomic) IBOutlet UILabel *partLabel;
@property (nonatomic) IBOutlet UILabel *qtyLabel;
@property (nonatomic) IBOutlet UILabel *tranTypeLabel;
@property (nonatomic, strong) PMItem *item;

@end
