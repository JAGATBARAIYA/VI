//
//  notifiedCopuntry.h
//  Vetted-Intl
//
//  Created by Manish on 06/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface notifiedCopuntry : NSObject

@property (assign, nonatomic) NSInteger Id;
@property (strong, nonatomic) NSString *countryName;
@property (assign, nonatomic) NSInteger countryId;

+ (notifiedCopuntry *)dataWithInfo:(NSDictionary*)dict;
- (notifiedCopuntry *)initWithDictionary:(NSDictionary*)dict;

@end
