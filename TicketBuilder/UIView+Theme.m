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

+ (UIView *) partTableViewHeader {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = 50.0;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [header setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel *stockLabel = [[UILabel alloc] init];
    UILabel *partLabel = [[UILabel alloc] init];
    UILabel *descriptionLabel = [[UILabel alloc] init];
    
    [stockLabel setTextAlignment:NSTextAlignmentCenter];
    [partLabel setTextAlignment:NSTextAlignmentCenter];
    [descriptionLabel setTextAlignment:NSTextAlignmentCenter];
    
    [stockLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [partLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [stockLabel setText:@"stock"];
    [partLabel setText:@"part#"];
    [descriptionLabel setText:@"description"];
    
    [header addSubview:stockLabel];
    [header addSubview:partLabel];
    [header addSubview:descriptionLabel];
    
    [header addConstraint:[NSLayoutConstraint constraintWithItem:stockLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeLeft multiplier:1.0f constant:8.0f]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:stockLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:stockLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:42.0f]];
    
    [header addConstraint:[NSLayoutConstraint constraintWithItem:partLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:stockLabel attribute:NSLayoutAttributeRight multiplier:1.0f constant:8.0f]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:partLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:partLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:60.0f]];
    
    [header addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:partLabel attribute:NSLayoutAttributeRight multiplier:1.0f constant:8.0f]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeRight multiplier:1.0f constant:16.0f]];
    
    
    return header;
}

@end
