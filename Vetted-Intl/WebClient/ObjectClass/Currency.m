//
//  Currency.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 21/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "Currency.h"

@implementation Currency

+ (Currency *)dataWithInfo:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (Currency *)initWithDictionary:(NSDictionary*)dict{
    if(dict[@"Id"]!=[NSNull null])
        self.Id = [dict[@"Id"] integerValue];
    
    if(dict[@"name"]!=[NSNull null])
        self.strName = dict[@"name"];
    
    if(dict[@"code"]!=[NSNull null])
        self.strCode = dict[@"code"];

    if(dict[@"symbol"]!=[NSNull null])
        self.strSymbol = dict[@"symbol"];

    if(dict[@"fromCode"]!=[NSNull null])
        self.isFromCode = [dict[@"fromCode"] integerValue];

    if(dict[@"toCode"]!=[NSNull null])
        self.isToCode = [dict[@"toCode"] integerValue];

    return self;
}

@end
