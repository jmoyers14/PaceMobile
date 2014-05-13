//
//  PMPart.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/13/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMPart : NSObject
//Required attributes for a part
@property (nonatomic, assign, readonly) NSUInteger itemRow;
@property (nonatomic, assign, readonly) NSUInteger partRow;
@property (nonatomic, assign, readonly) NSUInteger line;
@property (nonatomic, strong, readonly) NSString *part;

//other part attribs
@property (nonatomic, strong) NSString *partDesc;
@property (nonatomic, strong) NSString *longDesc;
@property (nonatomic, strong) NSString *manuf;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, assign) NSDecimalNumber *core;
@property (nonatomic, assign) NSUInteger instock;

- (id) initWithItemRow:(NSUInteger)itemRow partRow:(NSUInteger)partRow line:(NSUInteger)line part:(NSString *)part;
- (id) initWithItemRow:(NSUInteger)itemRow partRow:(NSUInteger)partRow line:(NSUInteger)line part:(NSString *)part description:(NSString *)partDesc longDesciption:(NSString *)longDesc manuf:(NSString *)manuf price:(NSDecimalNumber *)price core:(NSDecimalNumber *)core instock:(NSUInteger)instock;
- (BOOL) isEqualToPart:(PMPart *)part;
@end
