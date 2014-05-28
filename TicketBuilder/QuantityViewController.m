//
//  QuantityViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/26/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "QuantityViewController.h"

@interface QuantityViewController ()

@end

@implementation QuantityViewController
@synthesize delegate  = _delegate;
@synthesize container = _container;
@synthesize qntyField = _qntyField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.container layer] setCornerRadius:15.0];
    [self.qntyField becomeFirstResponder];
    //[[self.container layer] setShadowColor:[UIColor blackColor].CGColor];
    //[[self.container layer] setShadowOpacity:0.8];
    //[[self.container layer] setShadowOffset:CGSizeMake(3.0, 5.0)];
    //[[self.container layer] setShadowRadius:15.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.qntyField) {
        if ([[textField text] length] > 0) {
            [[self delegate] quantityChanged:[[textField text] integerValue]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    return YES;
}

@end
