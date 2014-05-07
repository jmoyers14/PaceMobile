//
//  LoginViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/1/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController () {
    IPConfigViewController *_ipConfViewController;
    UIPopoverController *_ipConfigPopover;
    PMUser *_user;
    NSOperationQueue *_operations;
}

@end

@implementation LoginViewController
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize loginView = _loginView;
@synthesize spinner = _spinner;

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
    
    _operations = [[NSOperationQueue alloc] init];
    [_operations setMaxConcurrentOperationCount:1];
    [_operations setName:@"login operation"];
    
    [self hideSpinner];
    [self styleTheLoginView];
    _user = [PMUser sharedInstance];
    [self createUser];
    [self checkValidIP];
    
    self.usernameField.text = [_user username];
}





//add shadow and rounded corners to login view
- (void) styleTheLoginView {
    [[self.loginView layer] setCornerRadius:15.0];
    [[self.loginView layer] setShadowColor:[UIColor blackColor].CGColor];
    [[self.loginView layer] setShadowOpacity:0.8];
    [[self.loginView layer] setShadowOffset:CGSizeMake(3.0, 5.0)];
    [[self.loginView layer] setShadowRadius:15.0];
}

//retrieve saved values from user defaults, initialize the shared user
- (void) createUser {
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    [_user setIp:[defaults objectForKey:@"ip"]];
    [_user setUrlPort:[defaults objectForKey:@"port"]];
    [_user setUsername:[defaults objectForKey:@"username"]];
}

//Checks if the user has a valid IP address to connect with
- (void) checkValidIP {
    
    if ([[_user ip] length] > 0 &&
        [[_user urlPort] length] > 0) {
        [self enableLogin];
    } else {
        [self disableLogin];
    }
}

//enable user interaction with login view
- (void) enableLogin {
    [self.usernameField setUserInteractionEnabled:YES];
    [self.passwordField setUserInteractionEnabled:YES];
    [self.loginView setOpaque:YES];
    [self.loginView setAlpha:1.0];
}

//disable user interaction with login view
- (void) disableLogin {
    [self.usernameField setUserInteractionEnabled:NO];
    [self.passwordField setUserInteractionEnabled:NO];
    [self.loginView setOpaque:NO];
}

//log user into pacesetter
- (void)login {
    if([[_usernameField text] length] > 0 && [[_passwordField text] length] > 0) {
        [self showSpinner];
        [_user setPassword:[self.passwordField text]];
        [_user setUsername:[self.usernameField text]];
    
        NSString *xml = [PMXMLBuilder loginXMLWithUsername:[[PMUser sharedInstance] username]
                                               andPassword:[[PMUser sharedInstance] password]];
        

        PMNetworkOperation *loginOperation = [[PMNetworkOperation alloc] initWithIdentifier:@"login" XML:xml andURL:[_user url]];
        loginOperation.delegate = self;
        
        [_operations addOperation:loginOperation];


        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Error" message:@"Please enter a username and password" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}



//Hide and show the ipConfiguration view
- (IBAction)ipConfigTapped:(id)sender {
    
    if(_ipConfViewController == nil) {
        //create IPConfigurationViewController
        _ipConfViewController = [[IPConfigViewController alloc] initWithNibName:@"IPConfigView" bundle:nil];
        [_ipConfViewController setDelegate:self];
    }
    
    if (_ipConfigPopover == nil) {
        //Show the ipConfig view

        _ipConfigPopover = [[UIPopoverController alloc] initWithContentViewController:_ipConfViewController];
        [_ipConfigPopover setDelegate:self];
        [_ipConfViewController setIp:[_user ip]];
        [_ipConfViewController setUrlPort:[_user urlPort]];
        
        [_ipConfigPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }
}


#pragma mark - PMNetworkOperationDelegate

- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {

    if(![operation failed]) {
        if([[operation identifier] isEqualToString:@"login"]) {
            NSDictionary *data = [PMNetwork parseLoginReply:operation.responseXML];
    
            if([data objectForKey:@"error"] != nil) {
                [self displayErrorMessage:[data objectForKey:@"error"]];
            } else {
                NSLog(@"Login success!");
                [_user setStores:[data objectForKey:@"stores"]];
                [self performSegueWithIdentifier:@"presentStorePicker" sender:self];
            }
        }
    } else {
        NSLog(@"Operation failed");
    }
    
    [self hideSpinner];
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidEndEditing:(UITextField *)textField {
    //Save username to NSDefaults, update MPUser
    if (textField == _usernameField) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [_user setUsername:textField.text];
        [defaults setObject:textField.text forKey:@"username"];
        [defaults synchronize];
        [_passwordField becomeFirstResponder];
    }
    
}

//override return key functionality to toggle textfields
//login when password is selected
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == _usernameField) {
        [_passwordField becomeFirstResponder];
    } else if (textField == _passwordField) {
        [self login];
        [_passwordField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - UIPopoverViewControllerDelegate

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    _ipConfigPopover = nil;
}

#pragma mark - IPConfigureationDelegate

//update the PMUser and save new ip in user defaults
- (void) didEditIP:(NSString *)ip {
    if([ip length] > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [_user setIp:ip];
        [defaults setObject:ip forKey:@"ip"];
        [defaults synchronize];
        [self checkValidIP];
    }
}

//update the PMUser and save new port in user defaults
- (void) didEditPort:(NSString *)port {
    if([port length] > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [_user setUrlPort:port];
        [defaults setObject:port forKey:@"port"];
        [defaults synchronize];
        [self checkValidIP];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
