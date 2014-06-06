//
//  OrderDetailViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/15/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController () {
    PMUser *_user;
    PMAccount *_account;
    PMOrder *_order;
    NSOperationQueue *_operations;
    FindPartViewControllerTableViewController *_findPartViewController;
    UIPopoverController *_findPartPopover;
}

@end

@implementation OrderDetailViewController
@synthesize accountNameLabel = _accountNameLabel;
@synthesize accountNumLabel = _accountNumLabel;
@synthesize partTotalLabel = _partTotalLabel;
@synthesize coreTotalLabel = _coreTotalLabel;
@synthesize taxTotalLabel = _taxTotalLabel;
@synthesize totalLabel = _totalLabel;

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
    _account = [[_user currentStore] currentAccount];
    _order = [_account currentOrder];
    [self setTitle:[_order date]];
    [self.accountNameLabel setText:[_account name]];
    [self.accountNumLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[_account anum]]];
    
    _operations = [[NSOperationQueue alloc] init];
    [_operations setMaxConcurrentOperationCount:3];
    [_operations setName:@"items queue"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedAddItemNotification:) name:@"AddItemNotification" object:nil];
}

- (void) refreshItems {
    NSString *xml = [PMXMLBuilder listitemsXMLWithUsername:[_user username] password:[_user password] orderRow:[_order ordRow]];
    PMNetworkOperation *listitems = [[PMNetworkOperation alloc] initWithIdentifier:@"listitems" XML:xml andURL:[_user url]];
    [listitems setDelegate:self];
    
    [_operations addOperation:listitems];
}

- (void) viewWillAppear:(BOOL)animated {
    [self refreshItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)addItem:(id)sender {
    if(_findPartViewController == nil) {
        //create IPConfigurationViewController
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _findPartViewController = [storyboard instantiateViewControllerWithIdentifier:@"FindPartViewController"];
    }
    
    if (_findPartPopover == nil) {
        //Show the ipConfig view
        
        _findPartPopover = [[UIPopoverController alloc] initWithContentViewController:_findPartViewController];
        [_findPartPopover setDelegate:self];
        
        [_findPartPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }
}
*/

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isKindOfClass:[ItemCell class]]) {
        EditItemViewController *destVC = [segue destinationViewController];
        ItemCell *ic = (ItemCell*)sender;
        [destVC setItem:[ic item]];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[_order items] count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
        
    [cell setItem:[[_order items] objectAtIndex:[indexPath row]]];
        
    return cell;

}

- (IBAction) finalize:(id) sender {
    NSString *message =[NSString stringWithFormat:@"Once finalized the order can no longer be edited."];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Finalize Order?" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [av show];
}

- (IBAction)deleteOrder:(id)sender {
    NSString *message =[NSString stringWithFormat:@"Are you sure you want to delete order created on %@", [_order date]];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Alert!" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [av show];
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - UIAlertViewDelegate
- (void) performDeleteOperation {
    NSString *xml = [PMXMLBuilder deleteordXMLWithUsername:[_user username] password:[_user password] orderRow:[_order ordRow]];
    PMNetworkOperation *deleteord = [[PMNetworkOperation alloc] initWithIdentifier:@"deleteord" XML:xml andURL:[_user url]];
    [deleteord setDelegate:self];
    [_operations addOperation:deleteord];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView title] isEqualToString:@"Alert!"]) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"Cancel");
                break;
            case 1:
                [self performDeleteOperation];
                break;
        }
    } else {
        switch (buttonIndex) {
            case 0:
                NSLog(@"Cancel");
                break;
            case 1:
                break;
        }
    }
}

#pragma mark - NetworkOperationDelegate
- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {
    if(![operation failed]) {
        if ([operation timedOut]) {
            [self displayErrorMessage:@"Operation timed out: check network connection."];
        } else {
            if ([[operation identifier] isEqualToString:@"listitems"]) {
                //list item response
                NSDictionary *response = [PMNetwork parseListitemsReply:[operation responseXML]];
                if([[response objectForKey:@"error"] length] > 0) {
                    [self displayErrorMessage:[response objectForKey:@"error"]];
                } else {
                    [_order setItems:[response objectForKey:@"items"]];
                    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
                    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [nf setMinimumIntegerDigits:1];
                    [nf setMinimumFractionDigits:2];
                    [nf setCurrencySymbol:@"$"];
                    NSDecimalNumber *partTot = (NSDecimalNumber *)[response objectForKey:@"ordTot"];
                    NSDecimalNumber *coreTot = (NSDecimalNumber *)[response objectForKey:@"coreTot"];
                    NSDecimalNumber *taxTot = (NSDecimalNumber *)[response objectForKey:@"taxTot"];
                    NSDecimalNumber *ordTot = [[partTot decimalNumberByAdding:coreTot] decimalNumberByAdding:taxTot];
                    [self.partTotalLabel setText:[nf stringFromNumber:partTot]];
                    [self.coreTotalLabel setText:[nf stringFromNumber:coreTot]];
                    [self.taxTotalLabel setText:[nf stringFromNumber:taxTot]];
                    [self.tableView reloadData];

                    [self.totalLabel setText:[nf stringFromNumber:ordTot]];

                }
            } else if([[operation identifier] isEqualToString:@"additem"]) {
                //add item response
                NSDictionary *response = [PMNetwork parseAdditemReply:[operation responseXML]];
                if ([[response objectForKey:@"error"] length] > 0) {
                    [self displayErrorMessage:[response objectForKey:@"eror"]];
                } else {
                    [self refreshItems];
                }
            } else if([[operation identifier] isEqualToString:@"deleteord"]) {
                NSDictionary *response = [PMNetwork parseDeleteordReply:[operation responseXML]];
                if ([[response objectForKey:@"error"] length] > 0) {
                    [self displayErrorMessage:[response objectForKey:@"error"]];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    } else {
        NSLog(@"%@ failed", [operation identifier]);
    }
}



#pragma mark - UIPopoverViewControllerDelegate

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    _findPartPopover = nil;
}

#pragma mark - notifications

- (void) receivedAddItemNotification:(NSNotification *)notification {
    if ([[notification name] isEqualToString:@"AddItemNotification"]) {
        PMItem *item = [[notification userInfo] objectForKey:@"item"];
        
        if (item) {
            NSString *xml = [PMXMLBuilder additemXMLWithUsername:[_user username] password:[_user password] accountRow:[_account acctRow] orderRow:[_order ordRow] partRow:[[item part] partRow] quantity:[item qty] tranType:[item transType]];
            
            PMNetworkOperation *additem = [[PMNetworkOperation alloc] initWithIdentifier:@"additem" XML:xml andURL:[_user url]];
            [additem setDelegate:self];
            [_operations addOperation:additem];
        }
    }
}



@end
