//
//  AddItemTableViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/18/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "AddItemTableViewController.h"
@interface AddItemTableViewController ()

@end

@implementation AddItemTableViewController
@synthesize currentPart = _currentPart;
@synthesize quantityLabel = _quantityLabel;

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
    [self.quantityLabel setText:[NSString stringWithFormat:@"/%lu", (unsigned long)[_currentPart instockAll]]];
}

- (void)addItem {
    
    PMTransactionType transType = SaleTrans;
    NSUInteger qnty = [[self.quantityField text] integerValue];
    
    if (qnty == 0) {
        [self displayErrorMessage:@"invalid quantity"];
    } else if (qnty > [_currentPart instockAll]) {
        [self displayErrorMessage:[NSString stringWithFormat:@"Only %lu parts in stock.", (unsigned long)[_currentPart instockAll]]];
    } else {
        switch ([[self typeControl] selectedSegmentIndex]) {
            case 0:
                transType = SaleTrans;
                break;
            case 1:
                transType = ReturnTrans;
                break;
            case 2:
                transType = CoreTrans;
                break;
            case 3:
                transType = DefectTrans;
                break;
        }
        

        PMItem *item = [[PMItem alloc] initWithItemRow:0 part:_currentPart quantity:qnty transType:transType];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:item, @"item", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddItemNotification" object:nil userInfo:userInfo];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [self addItem];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
