//
//  MyDocuments.h
//  Vetted-Intl
//
//  Created by Manish on 27/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDocuments : NSObject

@property (strong, nonatomic) NSString *strFolderName;

@property (strong, nonatomic) NSMutableArray *arrURL;

+ (MyDocuments *)dataWithInfo:(NSDictionary*)dict;
- (MyDocuments *)initWithDictionary:(NSDictionary*)dict;

@end
