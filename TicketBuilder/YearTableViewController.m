//
//  YearTableViewController.m
//  TicketBuilder
//
//  Created by Jeremy Moyers on 4/23/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "YearTableViewController.h"
#import "PMUser.h"
@interface YearTableViewController () {
    NSMutableArray *_years;
    NSMutableArray *_filteredYears;
    NSOperationQueue *_operations;
    PMUser *_user;
}
@end

@implementation YearTableViewController
@synthesize yearSearchBar = _yearSearchBar;

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
    
    self.title = @"Year";
    
    _filteredYears = [[NSMutableArray alloc] init];
    _years = [[NSMutableArray alloc] init];
    /*
    NSInteger baseYear = 2014;
    for(int i=0; i < 115;i++) {
        [_years addObject:[NSString stringWithFormat:@"%ld", (long)baseYear]];
        baseYear--;
    }
    */
    _operations = [[NSOperationQueue alloc] init];
    [_operations setMaxConcurrentOperationCount:1];
    [_operations setName:@"years operations"];
    _user = [PMUser sharedInstance];
    
    NSString *xml = [PMXMLBuilder yearsXMLWithUsername:[_user username] password:[_user password]];
    PMNetworkOperation *years = [[PMNetworkOperation alloc] initWithIdentifier:@"years" XML:xml andURL:[_user url]];
    [years setDelegate:self];
    [_operations addOperation:years];

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
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return [_filteredYears count];
    } else {
        return [_years count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"yearCell" forIndexPath:indexPath];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"yearCell"];
    }
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [_filteredYears objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [_years objectAtIndex:indexPath.row];
    }
    
    return cell;
}


-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {

    [_filteredYears removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    _filteredYears = [NSMutableArray arrayWithArray:[_years filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - PMNetworkOperationDelegate

- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {
    if (![operation failed]) {
        if ([[operation identifier] isEqualToString:@"years"]) {
            NSDictionary *response = [PMNetwork parseYearsReply:[operation responseXML]];
            if ([[response objectForKey:@"error"] length] > 0) {
                [self displayErrorMessage:[response objectForKey:@"error"]];
            } else {
                _years = [response objectForKey:@"years"];
                [self.tableView reloadData];
            }
        }
    } else {
        NSLog(@"%@ operation failed", [operation identifier]);
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
