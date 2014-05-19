//
//  TBXMLBuilder.h
//  TicketBuilder
//
//  Created by Jeremy Moyers on 4/28/14.
//  Copyright (c) 2014 Bluesage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLWriter.h"
#import "PMItem.h"
@interface PMXMLBuilder : NSObject
//xml to log user into MOE
+ (NSString *) loginXMLWithUsername:(NSString *)username
                        andPassword:(NSString *)password;


#pragma mark - Accounts and Customers
//XML used to lookup an account for a store
+ (NSString *) findacctXMLWithUsername:(NSString *)username
                              password:(NSString *)password
                               storeID:(NSUInteger)storeID
                         accountNumber:(NSUInteger)anum
                             storeName:(NSString *)name;

//XML used to check the account/customer record for a store
//customerNumber is customer phone number
+ (NSString *) checkcustXMLWithUsername:(NSString *)username
                              password:(NSString *)password
                               storeID:(NSUInteger)storeID
                         accountNumber:(NSUInteger)anum
                        customerNumber:(NSUInteger)cnum;

//XML to get enough data to confirm an account as the correct account
+ (NSString *) confacctXMLWithUsername:(NSString *)username
                              password:(NSString *)password
                            accountRow:(NSUInteger)acctRow;

//XML to get enough data to confirm a customer is correct
+ (NSString *) confcustXMLWithUsername:(NSString *)username
                              password:(NSString *)password
                           customerRow:(NSUInteger)custRow;


#pragma mark - Parts

//XML to find parts that match the part#
// line optional
// acctRow optional
+ (NSString *) findpartXMLWithUsername:(NSString *)username
                              password:(NSString *)password
                            accountRow:(NSUInteger)acctRow
                            lineNumber:(NSString *)line
                            partNumber:(NSString *)part;

//XML to get information about the part
+ (NSString *) inqpartXMLWithUsername:(NSString *)username
                             password:(NSString *)password
                           accountRow:(NSUInteger)acctRow
                              partRow:(NSUInteger)partRow;

#pragma mark - Orders

//XML to check if any orders are open for an account
+ (NSString *) checkordXMLWithUsername:(NSString *)username
                              password:(NSString *)password
                            accountRow:(NSUInteger)acctRow
                           customerRow:(NSUInteger)custRow;

//XML to create a new order with type open
+ (NSString *) createordXMLWithUsername:(NSString *)username
                               password:(NSString *)password
                             accountRow:(NSUInteger)acctRow
                            customerRow:(NSUInteger)custRow //0 if no customer
                           orderComment:(NSString *)ordComment
                       customerPONumber:(NSUInteger)custPoNum
                               shipText:(NSArray *)shipText
                            messageText:(NSArray *)messageText;


//XML to delete an open order with all of its order items
+ (NSString *) deleteordXMLWithUsername:(NSString *)username
                               password:(NSString *)password
                               orderRow:(NSUInteger)ordRow;

//XML to set the order status to final
+ (NSString *) finalordXMLWithUsername:(NSString *)username
                              password:(NSString *)password
                              orderRow:(NSUInteger)ordRow
                            orderTotal:(CGFloat)ordTot
                              orderTax:(CGFloat)ordTax
                             orderShip:(CGFloat)ordShip
                               payType:(NSString *)payType
                             payAmount:(CGFloat)payAmount
                          orderComment:(NSString *)ordComment
                      customerPONumber:(NSInteger)custPoNum;

//add a new order item to the current order
+ (NSString *) additemXMLWithUsername:(NSString *)username
                             password:(NSString *)password
                           accountRow:(NSUInteger)acctRow
                             orderRow:(NSUInteger)ordRow
                              partRow:(NSUInteger)partRow
                             quantity:(NSUInteger)qty
                             tranType:(PMTransactionType)tranType;

//XML to change the qty value of items from the current order
+ (NSString *) edititemXMLWithUsername:(NSString *)username
                              password:(NSString *)password
                            accountRow:(NSUInteger)acctRow
                              orderRow:(NSUInteger)ordRow
                               itemRow:(NSUInteger)itemRow
                              quantity:(NSUInteger)qty;

//XML to get taxable amout for the order
+ (NSString *) taxcalcXMLWithUsername:(NSString *)username
                              password:(NSString *)password
                           accountRow:(NSUInteger)acctRow
                         taxableTotal:(CGFloat)taxableTot;

//XML to remove item from the current order
+ (NSString *) deleteitemXMLWithUsername:(NSString *)username
                                password:(NSString *)password
                              accountRow:(NSUInteger)acctRow
                                orderRow:(NSUInteger)ordRow
                                 itemRow:(NSUInteger)itemRow;

//XML to retrieve all of the items for the current order
+ (NSString *) listitemsXMLWithUsername:(NSString *)username
                               password:(NSString *)password
                               orderRow:(NSUInteger)ordRow;

//get a list of years from the catalog
+ (NSString *) yearsXMLWithUsername:(NSString *)username
                           password:(NSString *)password;

//get a list of makes from the catalog
+ (NSString *) makesXMLWithUsername:(NSString *)username
                           password:(NSString *)password
                              years:(NSString *)years;

//get list of models from the catalog
+ (NSString *) modelsXMLWithUsername:(NSString *)username
                            password:(NSString *)password
                                year:(NSString *)year
                               make:(NSString *)make;

//get engine list from catalog
+ (NSString *) enginesXMLWithUsername:(NSString *)username
                             password:(NSString *)password
                                 year:(NSString *)year
                                 make:(NSString *)make
                                model:(NSString *)model;

//get list of groups from the catalog
+ (NSString *) groupsXMLWithUsername:(NSString *)username
                            password:(NSString *)password;

//get the second level of part groups that are desired
+ (NSString *) subgroupsXMLWithUsername:(NSString *)username
                               password:(NSString *)password
                                  group:(NSString *)group;

//get list of available parts for desired subgroup
+ (NSString *) partsWithUsername:(NSString *)username
                        password:(NSString *)password
                         acctRow:(NSUInteger)acctRow
                        subgroup:(NSString *)subgroup
                             vid:(NSString *)vid;

//XML to get account aged balances and sales for 2 history periods
/*
+ (NSString *) inqacctXMLWithUsername:(NSString *)username
                             password:(NSString *)password
                           accountRow:(NSUInteger)acctRow;
 */
@end
