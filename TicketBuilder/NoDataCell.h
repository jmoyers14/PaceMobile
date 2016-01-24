//
//  NoPartsCell.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 1/20/16.
//  Copyright © 2016 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataCell : UITableViewCell
@property (nonatomic, strong) UILabel *messageLabel;
+ (NSString *) cellIdentifier;
@end
