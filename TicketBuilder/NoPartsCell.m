//
//  NoPartsCell.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 1/20/16.
//  Copyright © 2016 Bluesage. All rights reserved.
//

#import "NoPartsCell.h"
#import "PMTheme.h"

@implementation NoPartsCell

+ (NSString *) cellIdentifier {
    return @"NoPartsCell";
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setMessageLabel:[[UILabel alloc] init]];
        
        [[self messageLabel] setNumberOfLines:0];
        [[self messageLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
        [[self messageLabel] setText:@"To find a part, enter a part number into the text field above and tap 'search'."];
        [[self messageLabel] setTextAlignment:NSTextAlignmentCenter];
        [[self messageLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:[self messageLabel]];
        [[self contentView] setBackgroundColor:[PMTheme lightHeaderColor]];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) initializeSubviews {
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:[self messageLabel] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeTop multiplier:1.0f constant:8.0f]];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:[self messageLabel] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:[self contentView] attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-8.0f];
    bottom.priority = 999;
    [[self contentView] addConstraint:bottom];
    
    [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:[self messageLabel] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeLeft multiplier:1.0f constant:16.0f]];
    [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:[self messageLabel] attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeRight multiplier:1.0f constant:-16.0f]];
}

@end
