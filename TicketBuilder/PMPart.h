//
//  PMPart.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/13/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    PMTypeMain,
    PMTypeSupresed,
    PMTypeAlternate,
    PMTypeXref
} PMType;

@interface PMPart : NSObject
//Required attributes for a part
@property (nonatomic, assign, readonly) NSUInteger partRow;
@property (nonatomic, strong, readonly) NSString* line;
@property (nonatomic, assign, readonly) NSUInteger list;
@property (nonatomic, strong, readonly) NSString *part;

//other part attribs
@property (nonatomic, strong) NSString *partDesc;
@property (nonatomic, strong) NSString *longDesc;
@property (nonatomic, strong) NSString *manuf;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, strong) NSDecimalNumber *core;
@property (nonatomic, strong) NSDecimalNumber *weight;
@property (nonatomic, assign) NSUInteger instock;
@property (nonatomic, assign) NSUInteger instockAll;
@property (nonatomic, assign) BOOL taxpart;
@property (nonatomic, assign) BOOL taxcore;
@property (nonatomic, assign) BOOL stateTaxPart;
@property (nonatomic, assign) BOOL stateTaxCore;
@property (nonatomic, assign) BOOL localTaxPart;
@property (nonatomic, assign) BOOL localTaxCore;
@property (nonatomic, assign) PMType partType;

- (id) initWithPartRow:(NSUInteger)partRow line:(NSString *)line part:(NSString *)part;
- (id) initWithPartRow:(NSUInteger)partRow line:(NSString *)line part:(NSString *)part description:(NSString *)partDesc longDesciption:(NSString *)longDesc manuf:(NSString *)manuf list:(NSUInteger)list price:(NSDecimalNumber *)price core:(NSDecimalNumber *)core instock:(NSUInteger)instock;
- (BOOL) isEqualToPart:(PMPart *)part;
@end
