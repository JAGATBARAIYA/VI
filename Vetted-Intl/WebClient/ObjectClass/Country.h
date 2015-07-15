//
//  Country.h
//
//
//  Created by Manish Dudharejia on 25/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (assign, nonatomic) NSInteger countryId;
@property (strong, nonatomic) NSString *strCountryName;
@property (strong, nonatomic) NSString *strCountryCode;

@property (assign, nonatomic) BOOL isBookmark;
@property (assign, nonatomic) BOOL isSelected;

+ (Country *)dataWithInfo:(NSDictionary*)dict;
- (Country *)initWithDictionary:(NSDictionary*)dict;

@end
