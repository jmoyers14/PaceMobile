//
//  OrdersTableViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/9/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "OrdersTableViewController.h"
#import "OrderTableViewCell.h"
#import "NoDataCell.h"
@interface OrdersTableViewController () {
    PMUser *_user;
    PMAccount *_account;
    NSOperationQueue *_operations;
}
@end

@implementation OrdersTableViewController

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
    
    [self setTitle:@"Orders"];
    
    _user = [PMUser sharedInstance];
    _account = [[[PMUser sharedInstance] currentStore] currentAccount];
    _operations = [[NSOperationQueue alloc] init];
    [_operations setMaxConcurrentOperationCount:1];
    [_operations setName:@"checkord operations"];
    
    [[self tableView] registerClass:[NoDataCell class] forCellReuseIdentifier:[NoDataCell cellIdentifier]];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self refreshData];
}

- (void) refreshData {
    NSString *xml = [PMXMLBuilder checkordXMLWithUsername:[_user username] password:[_user password] accountRow:[_account acctRow] customerRow:0];
    
    PMNetworkOperation *checkord = [[PMNetworkOperation alloc] initWithIdentifier:@"checkord" XML:xml andURL:[_user url]];
    [checkord setDelegate:self];
    [_operations addOperation:checkord];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_account setCurrentOrder:[[_account orders] objectAtIndex:[indexPath row]]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[_account orders] count] > 0) {
        return [[_account orders] count];
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_account orders] count] > 0) {
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
        
        PMOrder *order = [[_account orders] objectAtIndex:[indexPath row]];
        
        [cell setOrder:order];
        return cell;
    } else {
        NoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:[NoDataCell cellIdentifier]];
        [[cell messageLabel] setText:@"There are no open orders for this account. To create a new order tap 'Create'."];
        return  cell;
    }
}

#pragma mark - PMNetworkOperationDelegate

- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {
    if (![operation failed]) {
        NSDictionary *response = [PMNetwork parseCheckordReply:[operation responseXML]];
        if (response) {
            if([[response objectForKey:@"error"] length] > 0) {
                [self displayErrorMessage:[response objectForKey:@"error"]];
            } else {
                [_account setOrders:[response objectForKey:@"orders"]];
                [self.tableView reloadData];
            }
        } else {
            [self displayErrorMessage:@"Network Error: Check connection or ip configuration"];
        }
    } else {
        NSLog(@"%@ failed", [operation identifier]);
    }
}



@end
