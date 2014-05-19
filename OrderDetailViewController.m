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
    [_operations setMaxConcurrentOperationCount:2];
    [_operations setName:@"listitems queue"];
    
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


#pragma mark - UITableViewDelegate

#pragma mark - NetworkOperationDelegate
- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {
    if(![operation failed]) {
        if ([[operation identifier] isEqualToString:@"listitems"]) {
            //list item response
            NSDictionary *response = [PMNetwork parseListitemsReply:[operation responseXML]];
            if([[response objectForKey:@"error"] length] > 0) {
                [self displayErrorMessage:[response objectForKey:@"error"]];
            } else {
                [_order setItems:[response objectForKey:@"items"]];
                [self.totalLabel setText:[NSString stringWithFormat:@"$%@", [response objectForKey:@"ordTot"]]];
                [self.coreTotalLabel setText:[NSString stringWithFormat:@"$%@", [response objectForKey:@"coreTot"]]];
                [self.taxTotalLabel setText:[NSString stringWithFormat:@"$%@", [response objectForKey:@"taxTot"]]];
                [self.tableView reloadData];
            }
        } else if([[operation identifier] isEqualToString:@"additem"]) {
            //add item response
            NSDictionary *response = [PMNetwork parseAdditemReply:[operation responseXML]];
            if ([[response objectForKey:@"error"] length] > 0) {
                [self displayErrorMessage:[response objectForKey:@"eror"]];
            } else {
                [self refreshItems];
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
