//
//  Country.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 25/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "Country.h"

@implementation Country

+ (Country *)dataWithInfo:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (Country *)initWithDictionary:(NSDictionary*)dict{
    if(dict[@"countryid"]!=[NSNull null])
        self.countryId = [dict[@"countryid"] integerValue];
    
    if(dict[@"name"]!=[NSNull null])
        self.strCountryName = dict[@"name"];

    if(dict[@"alpha_2"]!=[NSNull null])
        self.strCountryCode = dict[@"alpha_2"];

    return self;
}

@end
