//
//  FuncitonCell.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/9/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "FuncitonCell.h"

@implementation FuncitonCell
@synthesize textLabel = _textLabel;
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

@end
