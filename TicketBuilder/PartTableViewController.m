//
//  PartTableViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/18/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PartTableViewController.h"
#import "AddItemTableViewController.h"
#import "UIView+Theme.h"

typedef NS_ENUM(NSInteger, PartSection) {
    PartSectionInfo,
    PartSectionStock,
    PartSectionPrice,
    PartSectionBlank
};

@interface PartTableViewController ()

@end

@implementation PartTableViewController
@synthesize currentPart = _currentPart;
@synthesize partLabel = _partLabel;
@synthesize lineLabel = _lineLabel;
@synthesize descLabel = _descLabel;
@synthesize typeLabel = _typeLabel;
@synthesize weightLabel = _weightLabel;
@synthesize stockLabel = _stockLabel;
@synthesize allStockLabel = _allStockLabel;
@synthesize pricePartLabel = _pricePartLabel;
@synthesize priceCoreLabel = _priceCoreLabel;
@synthesize coreTLabel = _coreTLabel;
@synthesize partTaxLabel = _partTaxLabel;
@synthesize sPartTaxLabel= _sPartTaxLabel;
@synthesize sCoreTaxLabel = _sCoreTaxLabel;
@synthesize lPartTaxLabel = _lPartTaxLabel;
@synthesize lCoreTaxLabel = _lCoreTaxLabel;

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
    self.title = [_currentPart part];
    [self.partLabel setText:[_currentPart part]];
    [self.lineLabel setText:[_currentPart line]];
    [self.descLabel setText:[_currentPart partDesc]];
    switch ([_currentPart partType]) {
        case PMTypeAlternate:
            [self.typeLabel setText:@"Alternate"];
            break;
        case PMTypeMain:
            [self.typeLabel setText:@"Main"];
            break;
        case PMTypeSupresed:
            [self.typeLabel setText:@"Surpresed"];
            break;
        case PMTypeXref:
            [self.typeLabel setText:@"Xref part"];
            break;
    }
    [self.weightLabel setText:[[_currentPart weight] stringValue]];
    [self.stockLabel setText: [NSString stringWithFormat:@"%lu", (unsigned long)[_currentPart instock]]];
    [self.allStockLabel setText: [NSString stringWithFormat:@"%lu", (unsigned long)[_currentPart instockAll]]];
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setMinimumFractionDigits:2];
    [nf setMinimumIntegerDigits:1];
    [nf setCurrencySymbol:@"$"];
    
    
    [self.pricePartLabel setText:[nf stringFromNumber:[_currentPart price]]];
    [self.priceCoreLabel setText:[nf stringFromNumber:[_currentPart core]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [((AddItemTableViewController*)[segue destinationViewController]) setCurrentPart:_currentPart];
}

- (IBAction)addPart:(id)sender {
    [self performSegueWithIdentifier:@"AddPartSegue" sender:self];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    
    switch ((PartSection)section) {
        case PartSectionInfo:
            title = @"Info";
            break;
        case PartSectionStock:
            title = @"Stock";
            break;
        case PartSectionPrice:
            title = @"Price";
            break;
        case PartSectionBlank:
            title = nil;
            break;
        default:
            title = nil;
            break;
    }
    
    return [UIView tableHeaderWithTitle:title];
}


@end
