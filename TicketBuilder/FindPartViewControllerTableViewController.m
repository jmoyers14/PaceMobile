//
//  FindPartViewControllerTableViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/18/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "FindPartViewControllerTableViewController.h"
#import "PMUser.h"
@interface FindPartViewControllerTableViewController () {
    PMUser *_user;
    NSOperationQueue *_operations;
    NSArray *_parts;
}

@end

@implementation FindPartViewControllerTableViewController
@synthesize partNumTextField = _partNumTextField;
@synthesize spinner = _spinner;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [_operations setName:@"findpart operations"];
    _parts = [[NSArray alloc] init];
    [self hideSpinner];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_parts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PartDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"partDescCell"];
    [cell setPart:[_parts objectAtIndex:[indexPath row]]];
    return cell;
}


#pragma mark - PMNetworkOperationDelegate
- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {
    if (![operation failed]) {
        if ([[operation identifier] isEqualToString:@"findpart"]) {
            NSDictionary *response = [PMNetwork parseFindPartReply:[operation responseXML]];
            if ([[response objectForKey:@"error"] length] > 0) {
                [self displayErrorMessage:[response objectForKey:@"error"]];
            } else {
                
                if (!([[response objectForKey:@"partCnt"] integerValue] > 0)) {
                    [self displayErrorMessage:@"Not parts found"];
                }
                _parts = [response objectForKey:@"parts"];
                [self.tableView reloadData];
            }
        }
    } else {
        NSLog(@"%@ operation failed", [operation identifier]);
    }
    [self hideSpinner];
}

#pragma mark - UITextFieldDelegate 

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.partNumTextField) {
        if ([[textField text] length] > 0) {
            [self showSpinner];
            NSLog(@"search");
            NSString *xml = [PMXMLBuilder findpartXMLWithUsername:[_user username] password:[_user password] accountRow:[[[_user currentStore] currentAccount] acctRow] lineNumber:@"" partNumber:[textField text]];
            PMNetworkOperation *findpart = [[PMNetworkOperation alloc] initWithIdentifier:@"findpart" XML:xml andURL:[_user url]];
            [findpart setDelegate:self];
            [_operations addOperation:findpart];
            [textField resignFirstResponder];
        }
    }
    
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[PartDescCell class]]) {
        PartDescCell *cell = (PartDescCell *)sender;
        [((PartTableViewController *)[segue destinationViewController]) setCurrentPart:[cell part]];
    }
}


@end
