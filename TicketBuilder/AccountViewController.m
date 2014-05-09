//
//  AccountViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/8/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController () {
    PMUser *_user;
    NSOperationQueue *_operations;
    NSArray *_functions;
}


@property (nonatomic, strong) IBOutlet UILabel *acctNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *acctNumLabel;

@property (nonatomic, strong) IBOutlet UILabel *addr1Label;
@property (nonatomic, strong) IBOutlet UILabel *addr2Label;
@property (nonatomic, strong) IBOutlet UILabel *addr3Label;
@property (nonatomic, strong) IBOutlet UILabel *phoneLabel;
@property (nonatomic, strong) IBOutlet UILabel *faxLabel;
@property (nonatomic, strong) IBOutlet UILabel *contactLabel;
@property (nonatomic, strong) IBOutlet UILabel *emailLabel;

@property (nonatomic, strong) IBOutlet UIView *contentView;



@end

@implementation AccountViewController

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    //Add functions to this array ot add buttons to the table view
    _functions = [NSArray arrayWithObjects:@"Orders", @"Customers", @"Account Balances", @"Part Lookup", nil];
    
    [self styleHeader];
    
    [self setTitle:@"Account Info"];
    
    _user = [PMUser sharedInstance];
    _operations = [[NSOperationQueue alloc] init];
    [_operations setMaxConcurrentOperationCount:1];
    [_operations setName:@"confacct operations"];

    [_acctNameLabel setText:[[[_user currentStore] currentAccount] name]];
    NSString *anum = [NSString stringWithFormat:@"%lu", (unsigned long)[[[_user currentStore] currentAccount] anum]] ;
    [_acctNumLabel setText:anum];
    
    //start confacct request
    NSString *xml = [PMXMLBuilder confacctXMLWithUsername:[_user username]
                                 password:[_user password]
                               accountRow:[[[_user currentStore] currentAccount] acctRow]];
    [self showSpinner];
    PMNetworkOperation *confacct = [[PMNetworkOperation alloc] initWithIdentifier:@"confacct"
                                                                              XML:xml
                                                                           andURL:[_user url]];
    [confacct setDelegate:self];
    [_operations addOperation:confacct];
}

- (void) styleHeader {

    [[_contentView layer] setShadowColor:[UIColor blackColor].CGColor];
    [[_contentView layer] setShadowOpacity:0.4];
    [[_contentView layer] setShadowOffset:CGSizeMake(0.0, 1.0)];
    [[_contentView layer] setShadowRadius:15.0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) redisplayAccountInfo {
    PMAccount *currAccount = [[_user currentStore] currentAccount];
    
    NSArray *address = [currAccount address];
    NSString *lastLine = [NSString stringWithFormat:@"%@ %@, %@", [currAccount city], [currAccount state], [currAccount zip]];
    
    if([address count] == 2) {
        [_addr1Label setText:[address objectAtIndex:0]];
        [_addr2Label setText:[address objectAtIndex:1]];
        [_addr3Label setText:lastLine];
    } else {
        [_addr1Label setText:[address objectAtIndex:0]];
        [_addr2Label setText:lastLine];
        [_addr3Label setHidden:YES];
    }


    if([[currAccount fax] length] > 0) {
        [_faxLabel setText:[currAccount fax]];
    } else {
        [_faxLabel setText:@"   "];
    }
    [_contactLabel setText:[currAccount contact]];
    [_emailLabel setText:[currAccount email]];
}

#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_functions count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FuncitonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FunctionCell"];
    
    [[cell textLabel] setText:[_functions objectAtIndex:indexPath.row]];
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[_functions objectAtIndex:indexPath.row] isEqualToString:@"Orders"]) {
        [self performSegueWithIdentifier:@"Orders" sender:self];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}


#pragma mark - PMNetworkOperationDelegate
-(void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {
    [self hideSpinner];
    if (![operation failed]) {
        NSDictionary *response = [PMNetwork parseConfacctReply:[operation responseXML]];
        
        NSLog(@"%@", [operation responseXML]);
        
        [[[_user currentStore] currentAccount] setAddress: [NSArray arrayWithObjects:[response objectForKey:@"addr1"], [response objectForKey:@"addr2"], nil]];
        [[[_user currentStore] currentAccount] setCity:[response objectForKey:@"city"]];
        [[[_user currentStore] currentAccount] setState:[response objectForKey:@"state"]];
        [[[_user currentStore] currentAccount] setZip:[response objectForKey:@"zip"]];
        [[[_user currentStore] currentAccount] setPhone:[response objectForKey:@"phone"]];
        [[[_user currentStore] currentAccount] setFax:[response objectForKey:@"fax"]];
        [[[_user currentStore] currentAccount] setContact:[response objectForKey:@"contact"]];
        [[[_user currentStore] currentAccount] setEmail:[response objectForKey:@"email"]];

        [self redisplayAccountInfo];
    } else {
        NSLog(@"confacct peration failed");
    }
}

@end
