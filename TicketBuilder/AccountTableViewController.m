//
//  AccountTableViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/7/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "AccountTableViewController.h"
#import "PMUser.h"
#import "PMXMLBuilder.h"
@interface AccountTableViewController () {
    PMUser *_user;
    NSOperationQueue *_operations;
    //NSArray *_filteredAccounts;
}
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation AccountTableViewController
@synthesize searchController = _searchController;

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
    [self setTitle:@"Accounts"];
    _user = [PMUser sharedInstance];
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    [searchBar setDelegate:self];
    [[self tableView] setTableHeaderView:searchBar];

    _operations = [[NSOperationQueue alloc] init];
    [_operations setMaxConcurrentOperationCount:1];
    [_operations setName:@"Find Accounts Operations"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_user currentStore] accounts] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell" forIndexPath:indexPath];
    [[cell textLabel] setText:[[[[_user currentStore] accounts] objectAtIndex:indexPath.row] name]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[_user currentStore] setCurrentAccount:[[[_user currentStore] accounts] objectAtIndex:indexPath.row]];
    NSLog(@"current account is %@", [[[_user currentStore] currentAccount] name]);
}

#pragma mark - PMNetworkOperationDelegate

- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {
    if(![operation failed]) {
        if([[operation identifier] isEqualToString:@"findacct"]) {
            NSDictionary *response = [PMNetwork parseFindacctReply:[operation responseXML]];
            if (response) {
                if([response objectForKey:@"error"] != nil) {
                    [self displayErrorMessage:[response objectForKey:@"error"]];
                } else {
                    [[_user currentStore] setAccounts:[response objectForKey:@"accounts"]];
                    [self.tableView reloadData];
                }
            } else {
                [self displayErrorMessage:@"Network Error: Check connection or ip configuration"];
            }
        }
    } else {
        NSLog(@"findacct operation failed");
    }

}

#pragma mark - UISearchBarDelegate methods

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@", searchText);
    //xml to lookup all accounts for the store
    if (searchText.length > 3) {
        NSString *xml = [PMXMLBuilder findacctXMLWithUsername:[_user username]
                                                     password:[_user password]
                                                      storeID:[[_user currentStore] storeId]
                                                accountNumber:0
                                                    storeName:searchText];
        
        PMNetworkOperation *findacct = [[PMNetworkOperation alloc] initWithIdentifier:@"findacct" XML:xml andURL:[_user url]];
        [findacct setDelegate:self];
        [_operations addOperation:findacct];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil]];
}

@end
