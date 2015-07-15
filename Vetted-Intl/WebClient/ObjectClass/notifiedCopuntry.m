//
//  notifiedCopuntry.m
//  Vetted-Intl
//
//  Created by Manish on 06/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "notifiedCopuntry.h"

@implementation notifiedCopuntry

+ (notifiedCopuntry *)dataWithInfo:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (notifiedCopuntry *)initWithDictionary:(NSDictionary*)dict{
    if(dict[@"id"]!=[NSNull null])
        self.Id = [dict[@"id"] integerValue];
       
                
                if(dict[@"country_name"]!=[NSNull null])
                    self.countryName = dict[@"country_name"];
                    
                    if(dict[@"country_id"]!=[NSNull null])
                        self.countryId = [dict[@"country_id"] integerValue];
                 
                            
                            return self;
}

@end
