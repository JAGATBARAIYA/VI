//
//  MyDocuments.m
//  Vetted-Intl
//
//  Created by Manish on 27/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "MyDocuments.h"

@implementation MyDocuments

+ (MyDocuments *)dataWithInfo:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (MyDocuments *)initWithDictionary:(NSDictionary*)dict{
    
    if(dict[@"folder_name"]!=[NSNull null])
        self.strFolderName = dict[@"folder_name"];
    
    if(dict[@"url"]!=[NSNull null])
        self.arrURL = dict[@"url"];
    
    return self;
}

@end
