//
//  RegisteredTrip.h
//  Vetted-Intl
//
//  Created by Manish on 07/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisteredTrip : NSObject

@property (assign, nonatomic) NSInteger intMemberID;
@property (assign, nonatomic) NSInteger intTripID;
@property (assign, nonatomic) NSInteger intCountryID;

@property (strong, nonatomic) NSString *strFromDate;
@property (strong, nonatomic) NSString *strToDate;
@property (strong, nonatomic) NSString *strDestination;
//@property (strong, nonatomic) NSString *strState;
@property (strong, nonatomic) NSString *strCity;

@property (strong, nonatomic) NSMutableArray *arrMembers;

@property (assign, nonatomic) BOOL isHide;
@property (assign, nonatomic) BOOL isSelected;

+ (RegisteredTrip *)dataWithInfo:(NSDictionary *)dict;
- (RegisteredTrip *)initWithDictionary:(NSDictionary *)dict;

@end
