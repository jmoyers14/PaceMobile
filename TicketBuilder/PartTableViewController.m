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
    PartSectionOrderDetails
};

@interface PartTableViewController ()
@property (nonatomic, strong) UIPickerView *pickerView;
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
@synthesize pickerView = _pickerView;
@synthesize quantityField = _quantityField;
@synthesize typeControl = _typeControl;

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
    self.title = [NSString stringWithFormat:@"Part#: %@", [_currentPart part]];
    [self.partLabel setText:[_currentPart part]];
    [self.lineLabel setText:[_currentPart line]];
    [self.descLabel setText:[_currentPart partDesc]];
    
    [self configurePickerView];
    
    UITapGestureRecognizer *tpgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [[self view] addGestureRecognizer:tpgr];
    
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


- (void) viewTapped:(id)sender {
    [[self quantityField] resignFirstResponder];
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
        case PartSectionOrderDetails:
            title = @"Order Details";
            break;
        default:
            title = nil;
            break;
    }
    
    return [UIView tableHeaderWithTitle:title];
}

- (void) configurePickerView {
    [self setPickerView:[[UIPickerView alloc] init]];
    [[self pickerView] setDelegate:self];
    [[self pickerView] setDataSource:self];
    
    [[self quantityField] setInputView:[self pickerView]];
    //[[self quantityField] setInputView:nil];
}

#pragma mark - UIPickerViewDelegate

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [[self quantityField] setText:[NSString stringWithFormat:@"%ld", row]];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self currentPart] instockAll] + 1;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
   return [NSString stringWithFormat:@"%ld", row];
}

#pragma mark - Add Part

- (IBAction)segValueChanged:(id)sender {
    NSUInteger index = [(UISegmentedControl *)sender selectedSegmentIndex];
    [[self typeControl] setSelectedSegmentIndex:index];
    if (index == 0) {
        [[self quantityField] setInputView:[self pickerView]];
    } else {
        [[self quantityField] setInputView:nil];
    }
}

- (IBAction)addPart:(id)sender {
    [self addItem];
}

- (void) addItem {
    PMTransactionType transType = (PMTransactionType)[[self typeControl] selectedSegmentIndex];
    NSUInteger quantity = [[[self quantityField] text] integerValue];
    
    
    if (quantity == 0) {
        [self displayErrorMessage:@"Invalid quantity"];
        
    } else if (quantity > [[self currentPart] instockAll] && transType == SaleTrans) {
        [self displayErrorMessage:[NSString stringWithFormat:@"Only %lu parts in stock.", (unsigned long)[[self currentPart] instockAll]]];
    } else {
        
        PMItem *item = [[PMItem alloc] initWithItemRow:0 part:_currentPart quantity:quantity transType:transType];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:item, @"item", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddItemNotification" object:nil userInfo:userInfo];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
            [self dismissViewControllerAnimated:true completion:nil];
        }
        
    }
}


@end
