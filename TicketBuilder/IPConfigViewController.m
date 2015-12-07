//
//  IPConfigurationViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/1/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "IPConfigViewController.h"

@interface IPConfigViewController () <UITextFieldDelegate>

@end

@implementation IPConfigViewController
@synthesize ipTextField = _ipTextField;
@synthesize portTextField = _portTextField;
@synthesize ip = _ip;
@synthesize urlPort = _urlPort;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setPreferredContentSize:CGSizeMake(674.0, 90.0)];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.ipTextField setText:self.ip];
    [self.portTextField setText:self.urlPort];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField == self.portTextField) {
        [self.delegate didEditPort:textField.text];
    } else if (textField == self.ipTextField) {
        [self.delegate didEditIP:textField.text];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
