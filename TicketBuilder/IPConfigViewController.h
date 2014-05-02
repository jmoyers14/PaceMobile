//
//  IPConfigurationViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/1/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPConfigDelegate <NSObject>

@required
- (void) didEditIP:(NSString *)ip;
- (void) didEditPort:(NSString *)port;
@end

@interface IPConfigViewController : UIViewController
@property (nonatomic, weak) id<IPConfigDelegate>delegate;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *urlPort;

@property IBOutlet UITextField *ipTextField;
@property IBOutlet UITextField *portTextField;

@end
