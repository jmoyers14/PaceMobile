//
//  PMAccount.h
//  PaceMobile
//
//  Created by Jeremy Moyers on 5/1/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMAccount : NSObject


@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger acctRow;
@property (nonatomic, assign) NSUInteger anum;
@property (nonatomic, strong) NSArray *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *fax;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *email;

-(id) initWithName:(NSString *)name row:(NSUInteger)acctRow num:(NSUInteger)anum;
-(BOOL) isEqualToAccount:(PMAccount *)account;

+(NSArray *) dictionaryKeys;
@end
