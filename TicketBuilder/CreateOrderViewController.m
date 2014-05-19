//
//  CreateOrderViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "CreateOrderViewController.h"

@interface CreateOrderViewController () {
    PMUser *_user;
    NSOperationQueue *_operations;
}

@end

@implementation CreateOrderViewController
@synthesize commentView = _commentView;
@synthesize spinner = _spinner;
@synthesize storeLabel = _storeLabel;
@synthesize accountLabel = _accountLabel;

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
    _user = [PMUser sharedInstance];
    _operations = [[NSOperationQueue alloc] init];
    [_operations setMaxConcurrentOperationCount:1];
    [_operations setName:@"createord operations"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd//yyyy"];
    
    [self.dateLabel setText:[formatter stringFromDate:[NSDate date]]];
    [self.storeLabel setText:[[_user currentStore] name]];
    [self.accountLabel setText:[[[_user currentStore] currentAccount] name]];
    [self hideSpinner];
    
    [self.commentView becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)create {
    
    PMAccount *account = [[_user currentStore] currentAccount];
    NSString* xml = [PMXMLBuilder createordXMLWithUsername:[_user username] password:[_user password] accountRow:[account acctRow] customerRow:0 orderComment:[_commentView text] customerPONumber:0 shipText:nil messageText:nil];
    
    PMNetworkOperation *createord = [[PMNetworkOperation alloc] initWithIdentifier:@"createord" XML:xml andURL:[_user url]];
    [createord setDelegate:self];
    [_operations addOperation:createord];
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PMNetworkOperationDelegate

- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {
    if (![operation failed]) {
        if([[operation identifier] isEqualToString:@"createord"]) {
            NSDictionary *response = [PMNetwork parseCreateordReply:[operation responseXML]];
            if ([[response objectForKey:@"error"] length] > 0) {
                [self displayErrorMessage:[response objectForKey:@"error"]];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } else {
        NSLog(@"%@ failed", [operation identifier]);
    }
    [self hideSpinner];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.commentView) {
        [self create];
        [self showSpinner];
        [textField resignFirstResponder];
    }
    return YES;
}

@end
