//
//  FindPartViewControllerTableViewController.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/18/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "FindPartViewControllerTableViewController.h"
#import "PMUser.h"
#import "UIView+Theme.h"
#import "NoDataCell.h"
@interface FindPartViewControllerTableViewController () {
    PMUser *_user;
    NSOperationQueue *_operations;
    NSArray *_parts;
    
    AVCaptureSession *_session;
    AVCaptureDevice  *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
}

@end

@implementation FindPartViewControllerTableViewController
@synthesize partNumTextField = _partNumTextField;
@synthesize spinner = _spinner;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    _user = [PMUser sharedInstance];
    _operations = [[NSOperationQueue alloc] init];
    [_operations setMaxConcurrentOperationCount:1];
    [_operations setName:@"findpart operations"];
    _parts = [[NSArray alloc] init];
    [self hideSpinner];
    
    [[self tableView] registerClass:[NoDataCell class] forCellReuseIdentifier:[NoDataCell cellIdentifier]];
    [[self tableView] setRowHeight:UITableViewAutomaticDimension];
    [[self tableView] setEstimatedRowHeight:60.0f];
    [[self partNumTextField] becomeFirstResponder];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
   // [[self partNumTextField] becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_parts count] > 0 ? [_parts count] : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_parts count] > 0) {
        PartDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"partDescCell"];
        [cell setPart:[_parts objectAtIndex:[indexPath row]]];
        return cell;
    } else {
        NoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:[NoDataCell cellIdentifier]];
        return cell;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([_parts count] > 0) {
        return [UIView partTableViewHeader];
    } else {
        return nil;
    }
}
#pragma mark - AVCaptureMetaDataDelegate

- (IBAction)scanPart:(UIBarButtonItem *)sender {
    [[self partNumTextField] resignFirstResponder];
    
    _session = [[AVCaptureSession alloc] init];
    _device  = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    [_output setMetadataObjectTypes:[_output availableMetadataObjectTypes]];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    [_prevLayer setFrame:[[self view] bounds]];
    [_prevLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [[[self view] layer] addSublayer:_prevLayer];
    
    
    [_session startRunning];
    
}

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
}


#pragma mark - PMNetworkOperationDelegate
- (void) networkRequestOperationDidFinish:(PMNetworkOperation *)operation {
    if (![operation failed]) {
        if ([[operation identifier] isEqualToString:@"findpart"]) {
            NSDictionary *response = [PMNetwork parseFindPartReply:[operation responseXML]];
            if (response) {
                if ([[response objectForKey:@"error"] length] > 0) {
                    [self displayErrorMessage:[response objectForKey:@"error"]];
                } else {
                    
                    if (!([[response objectForKey:@"partCnt"] integerValue] > 0)) {
                        [self displayErrorMessage:@"Not parts found"];
                    }
                    _parts = [response objectForKey:@"parts"];
                    [self.tableView reloadData];
                }
            } else {
                [self displayErrorMessage:@"Network Error: Check connection or ip configuration"];
            }
        }
    } else {
        NSLog(@"%@ operation failed", [operation identifier]);
    }
    [self hideSpinner];
}

#pragma mark - UITextFieldDelegate 

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.partNumTextField) {
        if ([[textField text] length] > 0) {
            [self showSpinner];
            NSLog(@"search");
            NSString *xml = [PMXMLBuilder findpartXMLWithUsername:[_user username] password:[_user password] accountRow:[[[_user currentStore] currentAccount] acctRow] lineNumber:@"" partNumber:[textField text]];
            PMNetworkOperation *findpart = [[PMNetworkOperation alloc] initWithIdentifier:@"findpart" XML:xml andURL:[_user url]];
            [findpart setDelegate:self];
            [_operations addOperation:findpart];
            [textField resignFirstResponder];
        }
    }
    
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[PartDescCell class]]) {
        PartDescCell *cell = (PartDescCell *)sender;
        [((PartTableViewController *)[segue destinationViewController]) setCurrentPart:[cell part]];
    }
}

- (IBAction)cancel:(id)sender {
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        
        
        if (_prevLayer != nil && [[[[self view] layer] sublayers] containsObject:_prevLayer]) {
            [_prevLayer removeFromSuperlayer];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


@end
