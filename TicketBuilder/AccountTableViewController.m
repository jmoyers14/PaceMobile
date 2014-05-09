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
}

@end

@implementation AccountTableViewController

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
    _operations = [[NSOperationQueue alloc] init];
    [_operations setMaxConcurrentOperationCount:1];
    [_operations setName:@"Find Accounts Operations"];
    
    //xml to lookup all accounts for the store
    NSString *xml = [PMXMLBuilder findacctXMLWithUsername:[_user username]
                                                 password:[_user password]
                                                  storeID:[[_user currentStore] storeId]
                                            accountNumber:0
                                                storeName:@"*"];
    
    PMNetworkOperation *findacct = [[PMNetworkOperation alloc] initWithIdentifier:@"findacct" XML:xml andURL:[_user url]];
    [findacct setDelegate:self];
    [_operations addOperation:findacct];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

/*
- (IBAction)presentAddAccountViewController:(id)sender {
    [self performSegueWithIdentifier:@"presentAddAccount" sender:self];
}
*/
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
            if([response objectForKey:@"error"] != nil) {
                [self displayErrorMessage:[response objectForKey:@"error"]];
            } else {
                [[_user currentStore] setAccounts:[response objectForKey:@"accounts"]];
                [self.tableView reloadData];
            }
        }
    } else {
        NSLog(@"findacct operation failed");
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
