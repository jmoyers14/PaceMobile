//
//  EditItemViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/26/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "EditItemViewController.h"

@interface EditItemViewController () {
    PMUser *_user;
    NSOperationQueue *_operations;
    
    //This is bad design.. need to think of way around using hte global
    NSUInteger _tempQuantity;
}
@end

@implementation EditItemViewController
@synthesize partLabel = _partLabel;
@synthesize lineLabel = _lineLabel;
@synthesize qtyLabel  = _qtyLabel;
@synthesize item      = _item;
@synthesize typeLabel = _typeLabel;
@synthesize spinner   = _spinner;

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

    [self hideSpinner];
    
    _user = [PMUser sharedInstance];
    
    _operations = [[NSOperationQueue alloc] init];
    [_operations setMaxConcurrentOperationCount:2];
    [_operations setName:@"edit item operations"];

    [_partLabel setText:[[_item part] part]];
    [_lineLabel setText:[[_item part] line]];
    [_qtyLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[_item qty]]];
    
    [self setTitle:[NSString stringWithFormat:@"%@ %@",[[_item part] line], [[_item part] part]]];
    
    switch ([_item transType]) {
        case SaleTrans:
            [_typeLabel setText:@"S"];
            break;
        case ReturnTrans:
            [_typeLabel setText:@"R"];
            break;
        case CoreTrans:
            [_typeLabel setText:@"C"];
            break;
        case DefectTrans:
            [_typeLabel setText:@"D"];
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void) editItem {
    NSLog(@"edit");
}

- (void) deleteItem {
    NSString *alertMessage = [NSString stringWithFormat:@"Are you sure you wish to delete %@ from this order?", [[_item part] part]];
    UIAlertView *deletConf = [[UIAlertView alloc] initWithTitle:@"Alert!" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [deletConf show];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath section] == 1) {
        switch ([indexPath row]) {
            case 0:
                [self editItem];
                break;
            case 1:
                [self deleteItem];
                break;
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[QuantityViewController class]]) {
        QuantityViewController *qvc = [segue destinationViewController];
        [qvc setDelegate:self];
    }
}

#pragma mark - UIAlertViewDelegate

- (void) performDeleteOperation {
    NSString *xml = [PMXMLBuilder deleteitemXMLWithUsername:[_user username]
                                                   password:[_user password]
                                                 accountRow:[[[_user currentStore] currentAccount] acctRow]
                                                   orderRow:[[[[_user currentStore] currentAccount] currentOrder] ordRow]
                                                    itemRow:[_item itemRow]];

    PMNetworkOperation *deleteitem = [[PMNetworkOperation alloc] initWithIdentifier:@"deleteitem" XML:xml andURL:[_user url]];
    [deleteitem setDelegate:self];
    [_operations addOperation:deleteitem];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView title] isEqualToString:@"Alert!"]) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"canceled");
                break;
            case 1:
                [self performDeleteOperation];
                break;
        }
    }
}

#pragma mark - QuantityDelegate Methods
- (void) quantityChanged:(NSUInteger)quantity {
    NSLog(@"quantity changed to %d", quantity);
    _tempQuantity = quantity;
    [self showSpinner];
    NSString *xml = [PMXMLBuilder edititemXMLWithUsername:[_user username]
                                                 password:[_user password]
                                               accountRow:[[[_user currentStore] currentAccount] acctRow]
                                                 orderRow:[[[[_user currentStore] currentAccount] currentOrder] ordRow]
                                                  itemRow:[_item itemRow]
                                                 quantity:quantity];
    
    PMNetworkOperation *edititem =[[PMNetworkOperation alloc] initWithIdentifier:@"edititem" XML:xml andURL:[_user url]];
    [edititem setDelegate:self];
    
    [_operations addOperation:edititem];
    
}

#pragma mark - PMNetworkOperationDelegateMethods

- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {
    [self hideSpinner];
    if (![operation failed]) {
        if ([[operation identifier] isEqualToString:@"edititem"]) {
            //respond to edit item call
            NSDictionary *response = [PMNetwork parseEdititemReply:[operation responseXML]];
            if ([[response objectForKey:@"error"] length] > 0) {
                [self displayErrorMessage:[response objectForKey:@"error"]];
            } else {
                [_qtyLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)_tempQuantity]];
            }
        } else if ([[operation identifier] isEqualToString:@"deleteitem"]) {
            //respond to delete item call
            NSDictionary *response = [PMNetwork parseDeleteitemReply:[operation responseXML]];
            if ([response objectForKey:@"error"] > 0) {
                [self displayErrorMessage:[response objectForKey:@"error"]];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            NSLog(@"unknown operaiton %@ in edit item view controller", [operation identifier]);
        }
    } else {
        NSLog(@"%@ operation failed", [operation identifier]);
    }
    
}

@end
