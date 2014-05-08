//
//  PMAccount.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/1/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMAccount.h"

@implementation PMAccount
@synthesize name = _name;
@synthesize acctRow = _acctRow;
@synthesize anum = _anum;
@synthesize address = _address;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;
@synthesize phone = _phone;
@synthesize fax = _fax;
@synthesize contact = _contact;
@synthesize email = _email;

//Designated initializer
- (id) initWithName:(NSString *)name row:(NSUInteger)acctRow num:(NSUInteger)anum {
    self = [super init];
    if(self) {
        self.name = name;
        self.acctRow = acctRow;
        self.anum = anum;
    }
    return self;
}

- (id) init {
    //call to designated initializer
    return [self initWithName:@"Unnamed account" row:0 num:0];
}


//WARNING only compares account name, row, and number!
- (BOOL) isEqualToAccount:(PMAccount *)account {
    if([_name isEqualToString:[account name]] &&
       (_acctRow == [account acctRow]) &&
       (_anum == [account anum])) {
        return YES;
    } else {
        return NO;
    }
}


@end
