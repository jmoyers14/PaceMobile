//
//  PMPart.m
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/13/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import "PMPart.h"

@implementation PMPart
@synthesize itemRow = _itemRow;
@synthesize partRow = _partRow;
@synthesize line = _line;
@synthesize part = _part;
@synthesize partDesc = _partDesc;
@synthesize longDesc = _longDesc;
@synthesize manuf = _manuf;
@synthesize price = _price;
@synthesize core = _core;
@synthesize instock = _instock;

- (id) initWithItemRow:(NSUInteger)itemRow partRow:(NSUInteger)partRow line:(NSUInteger)line part:(NSString *)part {
    self = [super init];
    if (self) {
        _itemRow = itemRow;
        _partRow = partRow;
        _line = line;
        _part = part;
    }
    return self;
}

- (id) initWithItemRow:(NSUInteger)itemRow partRow:(NSUInteger)partRow line:(NSUInteger)line part:(NSString *)part description:(NSString *)partDesc longDesciption:(NSString *)longDesc manuf:(NSString *)manuf price:(NSDecimalNumber *)price core:(NSDecimalNumber *)core instock:(NSUInteger)instock {
    self = [self initWithItemRow:itemRow partRow:partRow line:line part:part];
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
    return [self initWithItemRow:0 partRow:0 line:0 part:nil];
}

- (BOOL) isEqualToPart:(PMPart *)part {
    
    if((_itemRow == [part itemRow])&&
       (_partRow == [part partRow])&&
       (_line == [part line])&&
       ([_part isEqualToString:[part part]])) {
        return YES;
    } else {
        return NO;
    }
}

@end
