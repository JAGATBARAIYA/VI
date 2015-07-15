//
//  Member.m
//  Vetted-Intl
//
//  Created by Manish on 10/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "Member.h"

@implementation Member

+ (Member *)dataWithInfo:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (Member *)initWithDictionary:(NSDictionary *)dict{
    
    if(dict[@"memberid"]!=[NSNull null])
        self.intMemberID = [dict[@"memberid"] integerValue];
    
    if(dict[@"age"]!=[NSNull null])
        self.intAge = [dict[@"age"] integerValue];
    
    if(dict[@"email"]!=[NSNull null])
        self.strEmail = dict[@"email"];
    
    if(dict[@"name"]!=[NSNull null])
        self.strName = dict[@"name"];
    
    if(dict[@"phone"]!=[NSNull null])
        self.strPhoneNumber = dict[@"phone"];
    
    if(dict[@"relationship"]!=[NSNull null])
        self.strRelationship = dict[@"relationship"];

    if(dict[@"isAssistmember"]!=[NSNull null])
        self.isAssistmember = [dict[@"isAssistmember"]boolValue];
    
    _isHide = YES;
    
    return self;
}
@end
