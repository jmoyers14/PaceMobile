//
//  BalancesTableViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/28/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "BalancesTableViewController.h"

@interface BalancesTableViewController () {
    PMUser *_user;
    NSOperationQueue *_operations;
    PMAccount *_account;
}
@end

@implementation BalancesTableViewController
@synthesize age1BalLabel = _age1BalLabel;
@synthesize age2BalLabel = _age2BalLabel;
@synthesize age3BalLabel = _age3BalLabel;
@synthesize age4BalLabel = _age4BalLabel;
@synthesize age1DesLabel = _age1DesLabel;
@synthesize age2DesLabel = _age2DesLabel;
@synthesize age3DesLabel = _age3DesLabel;
@synthesize age4DesLabel = _age4DesLabel;
@synthesize hist1SalesLabel = _hist1SalesLabel;
@synthesize hist2SalesLabel = _hist2SalesLabel;
@synthesize hist1DesLabel = _hist1DesLabel;
@synthesize hist2DesLabel = _hist2DesLabel;
@synthesize hist1ProfitLabel = _hist1ProfitLabel;
@synthesize hist2ProfitLabel = _hist2ProfitLabel;

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
    [self setTitle:@"Account Balances"];
    _user = [PMUser sharedInstance];
    _account = [[_user currentStore] currentAccount];
    _operations = [[NSOperationQueue alloc] init];
    [_operations setMaxConcurrentOperationCount:1];
    [_operations setName:@"inqacct operations"];
    
    NSString *xml = [PMXMLBuilder inqacctXMLWithUsername:[_user username]
                                                password:[_user password]
                                                 acctRow:[[[_user currentStore] currentAccount] acctRow]];
    
    PMNetworkOperation *inqacct = [[PMNetworkOperation alloc] initWithIdentifier:@"inqacct" XML:xml andURL:[_user url]];
    [inqacct setDelegate:self];
    [_operations addOperation:inqacct];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) populateData:(NSDictionary *)data {
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setMinimumFractionDigits:2];
    [nf setMinimumIntegerDigits:1];
    [nf setCurrencySymbol:@"$"];
    
    NSDecimalNumber *currBal = [data objectForKey:@"currBal"];
    NSDecimalNumber *age1 = [data objectForKey:@"age1Bal"];
    NSDecimalNumber *age2 = [data objectForKey:@"age2Bal"];
    NSDecimalNumber *age3 = [data objectForKey:@"age3Bal"];
    NSDecimalNumber *age4 = [data objectForKey:@"age4Bal"];
    NSDecimalNumber *profit1 = [data objectForKey:@"hist1Profit"];
    NSDecimalNumber *sales1  = [data objectForKey:@"hist1Sales"];
    NSDecimalNumber *profit2 = [data objectForKey:@"hist2Profit"];
    NSDecimalNumber *sales2  = [data objectForKey:@"hist2Sales"];
    
    
    [self.currBalanceLabel setText:[nf stringFromNumber:currBal]];
    [self.age1BalLabel setText:[nf stringFromNumber:age1]];
    [self.age2BalLabel setText:[nf stringFromNumber:age2]];
    [self.age3BalLabel setText:[nf stringFromNumber:age3]];
    [self.age4BalLabel setText:[nf stringFromNumber:age4]];
    [self.age1DesLabel setText:[data objectForKey:@"age1Des"]];
    [self.age2DesLabel setText:[data objectForKey:@"age2Des"]];
    [self.age3DesLabel setText:[data objectForKey:@"age3Des"]];
    [self.age4DesLabel setText:[data objectForKey:@"age4Des"]];
    [self.hist1SalesLabel setText:[nf stringFromNumber:sales1]];
    [self.hist1ProfitLabel setText:[nf stringFromNumber:profit1]];
    [self.hist1DesLabel setText:[data objectForKey:@"hist1Des"]];
    [self.hist2SalesLabel setText:[nf stringFromNumber:sales2]];
    [self.hist2ProfitLabel setText:[nf stringFromNumber:profit2]];
    [self.hist2DesLabel setText:[data objectForKey:@"hist2Des"]];
}

#pragma mark - PMNetworkOperationDelegate
- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {
    if (![operation failed]) {
        if ([[operation identifier] isEqualToString:@"inqacct"]) {
            NSDictionary *response = [PMNetwork parseInqacctReply:[operation responseXML]];
            if ([[response objectForKey:@"error"] length] > 0) {
                [self displayErrorMessage:[response objectForKey:@"error"]];
            } else {
                [self populateData:response];
            }
        }
    } else {
        NSLog(@"%@ operation failed", [operation identifier]);
    }
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
