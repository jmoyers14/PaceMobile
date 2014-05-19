//
//  OrderTableViewCell.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/18/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMOrder.h"
@interface OrderTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *ordNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) PMOrder *order;
@end
