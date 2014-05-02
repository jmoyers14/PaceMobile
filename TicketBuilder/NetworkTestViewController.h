//
//  NetworkTestViewController.h
//  TicketBuilder
//
//  Created by Jeremy Moyers on 4/29/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMNetwork.h"
#import "PMXMLBuilder.h"

@interface NetworkTestViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITextField *usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UITextField *urlTextField;
@property (nonatomic, strong) IBOutlet UITextView *responseLabel;
@property (nonatomic, strong) IBOutlet UITextView *requestLabel;
@property (nonatomic, strong) IBOutlet UILabel *codeLabel;


@end
