//
//  PMItem.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/13/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMPart.h"

typedef enum {
    SaleTrans,
    ReturnTrans,
    CoreTrans,
    DefectTrans
} PMTransactionType;



@interface PMItem : NSObject
@property (nonatomic, assign, readonly) PMTransactionType transType;
@property (nonatomic, assign, readonly) NSUInteger qty;
@property (nonatomic, strong, readonly) PMPart *part;

- (id) initWithPart:(PMPart *)part quantity:(NSUInteger)qty transType:(PMTransactionType)transType;
- (BOOL) isEqualToItem:(PMItem *)item;
@end
