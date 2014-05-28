//
//  QuantityViewController.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/26/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuantityDelegate <NSObject>
@required
- (void) quantityChanged:(NSUInteger)quantity;
@end

@interface QuantityViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <QuantityDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UITextField *qntyField;

- (IBAction)cancel:(id)sender;

@end
