//
//  PMPart.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/13/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMPart.h"

@implementation PMPart
@synthesize partRow = _partRow;
@synthesize line = _line;
@synthesize part = _part;
@synthesize partDesc = _partDesc;
@synthesize longDesc = _longDesc;
@synthesize manuf = _manuf;
@synthesize price = _price;
@synthesize core = _core;
@synthesize instock = _instock;
@synthesize list = _list;
@synthesize instockAll = _instockAll;
@synthesize weight = _weight;
@synthesize stateTaxPart = _stateTaxPart;
@synthesize taxcore = _taxcore;
@synthesize taxpart = _taxpart;
@synthesize localTaxCore = _localTaxCore;
@synthesize localTaxPart = _localTaxPart;
@synthesize stateTaxCore = _stateTaxCore;

- (id) initWithPartRow:(NSUInteger)partRow line:(NSString *)line part:(NSString *)part {
    self = [super init];
    if (self) {
        _partRow = partRow;
        _line = line;
        _part = part;
    }
    return self;
}

- (id) initWithPartRow:(NSUInteger)partRow line:(NSString *)line part:(NSString *)part description:(NSString *)partDesc longDesciption:(NSString *)longDesc manuf:(NSString *)manuf list:(NSUInteger)list price:(NSDecimalNumber *)price core:(NSDecimalNumber *)core instock:(NSUInteger)instock {
    self = [self initWithPartRow:partRow line:line part:part];
    if(self) {
        _partDesc = partDesc;
        _longDesc = longDesc;
        _manuf    = manuf;
        _price    = price;
        _core     = core;
        _instock  = instock;
    }
    return self;
}

- (id) init {
    //call to designated initializer
    return [self initWithPartRow:0 line:0 part:nil];
}

- (BOOL) isEqualToPart:(PMPart *)part {
    
    if((_partRow == [part partRow])&&
       ([_line isEqualToString:[part line]])&&
       ([_part isEqualToString:[part part]])) {
        return YES;
    } else {
        return NO;
    }
}

@end
