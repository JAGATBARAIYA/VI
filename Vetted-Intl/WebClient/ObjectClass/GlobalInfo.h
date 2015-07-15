//
//  GlobalInfo.h
//  Vetted-Intl
//
//  Created by Manish on 27/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalInfo : NSObject

@property (assign, nonatomic) NSInteger intCategoryId;
@property (strong, nonatomic) NSString *strCategoryName;
@property (strong, nonatomic) NSString *strText;

@property (strong, nonatomic) NSAttributedString *attributedCatString;
@property (strong, nonatomic) NSAttributedString *attributedString;

@property (assign, nonatomic, getter=isOpen) BOOL open;

+ (GlobalInfo *)dataWithInfo:(NSDictionary*)dict;
- (GlobalInfo *)initWithDictionary:(NSDictionary*)dict;

@end
