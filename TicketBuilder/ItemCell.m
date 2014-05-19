//
//  ItemCell.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell
@synthesize lineLabel = _lineLabel;
@synthesize partLabel = _partLabel;
@synthesize qtyLabel = _qtyLabel;
@synthesize tranTypeLabel = _tranTypeLabel;
@synthesize item = _item;
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

- (void) setItem:(PMItem *)item {
    _item = item;
    [self.lineLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[[item part] line]]];
    [self.partLabel setText:[[item part] part]];
    [self.qtyLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[item qty]]];
    NSString *type;
    switch ([item transType]) {
        case SaleTrans:
            type = @"S";
            break;
        case ReturnTrans:
            type = @"R";
            break;
        case CoreTrans:
            type = @"C";
            break;
        case DefectTrans:
            type = @"D";
            break;
    }
    
    [self.tranTypeLabel setText:type];
}

@end
