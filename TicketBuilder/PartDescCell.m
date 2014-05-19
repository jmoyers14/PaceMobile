//
//  PartDescCell.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/18/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PartDescCell.h"

@implementation PartDescCell
@synthesize part = _part;
@synthesize partNumLabel = _partNumLabel;
@synthesize stockLabel = _stockLabel;
@synthesize descLabel = _descLabel;

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

}

- (void) setPart:(PMPart *)part {
    _part = part;
    [_partNumLabel setText:[part part]];
    [_stockLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[part instock]]];
    [_descLabel setText:[part partDesc]];
}

@end
