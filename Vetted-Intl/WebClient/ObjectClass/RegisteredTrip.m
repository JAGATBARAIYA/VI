//
//  RegisteredTrip.m
//  Vetted-Intl
//
//  Created by Manish on 07/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "RegisteredTrip.h"
#import "Member.h"

@implementation RegisteredTrip

+ (RegisteredTrip *)dataWithInfo:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (dict[@"tripid"] != [NSNull null])
        self.intTripID = [dict[@"tripid"]integerValue];

    if (dict[@"countryid"] != [NSNull null])
        self.intCountryID = [dict[@"countryid"]integerValue];

    if (dict[@"fromdate"] != [NSNull null])
        self.strFromDate = dict[@"fromdate"];

    if (dict[@"todate"] != [NSNull null])
        self.strToDate = dict[@"todate"];

    if (dict[@"destination"] != [NSNull null])
        self.strDestination = dict[@"destination"];

    if (dict[@"city"] != [NSNull null])
        self.strCity = dict[@"city"];

//    if (dict[@"state"] != [NSNull null])
//        self.strState = dict[@"state"];

    _isHide = YES;
    NSArray *arrTrip  = dict[@"members"];
    if(arrTrip.count!=0){
        self.arrMembers = [[NSMutableArray alloc] init];
        [arrTrip enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Member *members = [Member dataWithInfo:obj];
            [self.arrMembers addObject:members];
        }];
    }
    
    return self;
}

@end
