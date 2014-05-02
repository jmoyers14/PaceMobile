//
//  NetworkViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/2/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//
//  This category contains common methods used by all UIViewController that access the network

#import "NetworkViewController.h"

@implementation UIViewController (NetworkViewController)


//Show the activity spinner
- (void) showSpinner {

    SEL selector = NSSelectorFromString(@"spinner");
    if([self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        id (*func)(id, SEL) = (void *)imp;
        id av = func(self, selector);
        
        if([av isKindOfClass:[UIActivityIndicatorView class]]) {
            [av startAnimating];
            [av setHidden:NO];
        }
    } else {
        NSLog(@"%@ does not respond to spinner", [self class]);
    }

}


//Hide the activity spinner
- (void) hideSpinner {
    SEL selector = NSSelectorFromString(@"spinner");
    if([self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        id (*func)(id, SEL) = (void *)imp;
        id av = func(self, selector);
        
        if([av isKindOfClass:[UIActivityIndicatorView class]]) {
            [av stopAnimating];
            [av setHidden:YES];
        }
    } else {
        NSLog(@"%@ does not respond to spinner", [self class]);
    }
}

@end
