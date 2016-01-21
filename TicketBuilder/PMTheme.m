//
//  PMTheme.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 1/19/16.
//  Copyright © 2016 Bluesage. All rights reserved.
//

#import "PMTheme.h"

@implementation PMTheme

+ (UIColor *) primaryColor {
    return [UIColor colorWithRed:253.0/255.0 green:184.0/255.0 blue:19.0/255.0 alpha:1.0f];
}

+ (UIColor *) secondaryColor {
    return [UIColor colorWithRed:24.0/255.0 green:49.0/255.0 blue:126.0/255.0 alpha:1.0f];
}

+ (UIColor *) acceptColor {
    return [UIColor colorWithRed:171.0/255.0 green:246.0/255.0 blue:168.0/255.0 alpha:1.0f];
}

+ (UIColor *) deleteColor {
    return [UIColor colorWithRed:255.0/255.0 green:193.0/255.0 blue:190.0/255.0 alpha:1.0f];
}

+ (UIColor *) lightHeaderColor {
    return [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0f];
}

@end
