//
//  OrderTableViewCell.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/18/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell
@synthesize ordNumLabel = _ordNumLabel;
@synthesize commentLabel = _commentLabel;
@synthesize dateLabel = _dateLabel;
@synthesize order = _order;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setOrder:(PMOrder *)order {
    _order = order;
    [self.ordNumLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[_order ordNum]]];
    [self.commentLabel setText:[_order comment]];
    [self.dateLabel setText:[_order date]];
}

@end
