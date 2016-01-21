//
//  StoreTableViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/7/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "StoreTableViewController.h"
#import "PMUser.h"
@interface StoreTableViewController () {
    PMUser *_user;
    NSArray *_filteredStores;
}

@end

@implementation StoreTableViewController
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
    [self setTitle:@"Stores"];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    [[self searchController] setSearchResultsUpdater:self];
    [[self searchController] setDimsBackgroundDuringPresentation:NO];
    [[[self searchController] searchBar] setScopeButtonTitles:@[]];
    [self setDefinesPresentationContext:YES];
    
    [[self tableView] setTableHeaderView:[[self searchController] searchBar]];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _user = [PMUser sharedInstance];
    
    
    [[self tableView] reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[self searchController] isActive] && [[[[self searchController] searchBar] text] length] > 0) {
        return [_filteredStores count];
    } else {
        return [[_user stores] count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell" forIndexPath:indexPath];
    
    if ([[self searchController] isActive] && [[[[self searchController] searchBar] text] length] > 0) {
        [[cell textLabel] setText:[[_filteredStores objectAtIndex:indexPath.row] name]];
    } else {
        [[cell textLabel] setText:[[[_user stores] objectAtIndex:indexPath.row] name]];
    }
    
    return cell;
}


#pragma mark - UISearchResultsUpdating

- (void) updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = [[searchController searchBar] text];
    
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    
    _filteredStores = [[_user stores] filteredArrayUsingPredicate:filterPredicate];
    
    [[self tableView] reloadData];
    
}




- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PMStore *currStore = nil;
    if ([[self searchController] isActive] && [[[[self searchController] searchBar] text] length] > 0) {
        currStore = [_filteredStores objectAtIndex:indexPath.row];
        [_user setCurrentStore:currStore];
    } else {
        currStore = [[_user stores] objectAtIndex:indexPath.row];
        [_user setCurrentStore:currStore];
        
    }
    
    
    NSLog(@"Set current store to %@", [[_user currentStore] name]);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil]];
}


@end
