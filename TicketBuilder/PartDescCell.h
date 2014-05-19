//
//  PartDescCell.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/18/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMPart.h"
@interface PartDescCell : UITableViewCell
@property (nonatomic, strong) PMPart *part;
@property (nonatomic, strong) IBOutlet UILabel *partNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *stockLabel;
@property (nonatomic, strong) IBOutlet UILabel *descLabel;
@end
