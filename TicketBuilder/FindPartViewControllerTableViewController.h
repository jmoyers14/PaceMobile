//
//  FindPartViewControllerTableViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/18/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkViewController.h"
#import "PartTableViewController.h"
#import "PartDescCell.h"
#import <AVFoundation/AVFoundation.h>



@interface FindPartViewControllerTableViewController : UITableViewController <PMNetworkOperationDelegate, UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) IBOutlet UITextField *partNumTextField;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@end
