//
//  Currency.h
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 21/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Currency : NSObject

@property (assign, nonatomic) NSInteger Id;

@property (strong, nonatomic) NSString *strName;
@property (strong, nonatomic) NSString *strCode;
@property (strong, nonatomic) NSString *strSymbol;

@property (assign, nonatomic) BOOL isFromCode;
@property (assign, nonatomic) BOOL isToCode;

@property (assign, nonatomic) double toValue;

+ (Currency *)dataWithInfo:(NSDictionary*)dict;
- (Currency *)initWithDictionary:(NSDictionary*)dict;

@end
