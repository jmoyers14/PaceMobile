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
    [_operations setMaxConcurrentOperationCount:1];
    [_operations setName:@"listitems queue"];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
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
            NSDictionary *response = [PMNetwork parseListitemsReply:[operation responseXML]];
            if([[response objectForKey:@"error"] length] > 0) {
                [self displayErrorMessage:[response objectForKey:@"error"]];
            } else {
                [_order setItems:[response objectForKey:@"items"]];
                [self.partTotalLabel setText:[[response objectForKey:@"ordTot"] stringValue]];
                [self.coreTotalLabel setText:[[response objectForKey:@"coreTot"] stringValue]];
                [self.taxTotalLabel setText:[[response objectForKey:@"taxTot"] stringValue]];
                [self.tableView reloadData];
            }
        }
    } else {
        NSLog(@"%@ failed", [operation identifier]);
    }
}

@end
