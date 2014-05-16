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
@synthesize orders = _orders;
@synthesize currentOrder = _currentOrder;

NSUInteger _currentOrderIndex;

//Designated initializer
- (id) initWithName:(NSString *)name row:(NSUInteger)acctRow num:(NSUInteger)anum {
    self = [super init];
    if(self) {
        self.name = name;
        self.acctRow = acctRow;
        self.anum = anum;
        _orders = [[NSMutableArray alloc] init];
        _currentOrderIndex = 0;
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

- (void) setOrders:(NSMutableArray *)orders {
    _currentOrderIndex = 0;
    _orders = orders;
}

- (void) setCurrentOrder:(PMOrder *)currentOrder {
    if([_orders containsObject:currentOrder]) {
        _currentOrderIndex = [_orders indexOfObject:currentOrder];
    } else {
        NSLog(@"%d currentOrderIndex out of bounds", _currentOrderIndex);
    }
}

- (PMOrder *) currentOrder {
    if(_currentOrderIndex < [_orders count]) {
        return [_orders objectAtIndex:_currentOrderIndex];
    } else {
        NSLog(@"%d currentOrderIndex out of bounds", _currentOrderIndex);
        return nil;
    }
}


//add order to account
- (void) addOrder:(PMOrder *)order {
    [_orders addObject:order];
}

//returns an array of key values that will be found in dictionaries
//containing the values used to initialize an account
+ (NSArray *) dictionaryKeys {
    
    return [NSArray arrayWithObjects:@"anum",
            @"name",
            @"addr1",
            @"addr2",
            @"city",
            @"state",
            @"zip",
            @"phone",
            @"fax",
            @"contact",
            @"email", nil];
}


@end
