//
//  MakeTableViewController.m
//  TicketBuilder
//
//  Created by Jeremy Moyers on 4/23/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "MakeTableViewController.h"

@interface MakeTableViewController () {
    NSMutableArray *_makes;
    NSMutableArray *_filteredMakes;
}

@end

@implementation MakeTableViewController


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
    self.title = @"Make";
    _makes = [NSMutableArray arrayWithObjects:@"ACURA", @"APRILIA", @"ARCTIC CAT", @"ASTON MARTIN", @"AUDI",
                                              @"BENTLY", @"BMW", @"BUICK", @"CADILLAC", @"CAN-AM", @"CHEVROLET",
                                              @"CHRYSLER", @"COBRA", @"DOGE", @"DECATI", @"FIAT", @"FREIGHTLINER",
                                              @"GMC", @"HARLEY DAVIDSON", @"HONDA", @"INFINITE", @"JAGUIRE", @"JEEP",
                                              @"KAWASAKI", nil];
    
    _filteredMakes = [NSMutableArray arrayWithCapacity:[_makes count]];
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
    if(tableView == [[self searchDisplayController] searchResultsTableView]) {
        return [_filteredMakes count];
    } else {
        return [_makes count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"makeCell" forIndexPath:indexPath];
    
    
    if( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"makeCell"];
    }
    
    if(tableView == self.searchDisplayController.searchResultsTableView ) {
        cell.textLabel.text = [_filteredMakes objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [_makes objectAtIndex:indexPath.row];
    }

    
    return cell;
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    
    [_filteredMakes removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    _filteredMakes = [NSMutableArray arrayWithArray:[_makes filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return  YES;
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
