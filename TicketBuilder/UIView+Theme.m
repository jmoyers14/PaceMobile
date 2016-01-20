//
//  UIView+Theme.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 1/19/16.
//  Copyright © 2016 Bluesage. All rights reserved.
//

#import "UIView+Theme.h"

@implementation UIView(UIView_Theme)

+ (UIView *) tableHeaderWithTitle:(NSString *)title {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = 50.0;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [header setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [header addSubview:titleLabel];
    
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [header addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    return header;
}

@end
