//
//  Alert.h
//  Vetted-Intl
//
//  Created by Manish on 17/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Alert : NSObject

@property (assign, nonatomic) NSInteger intAlertID;

@property (strong, nonatomic) NSString *strAlertText;
@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strAlertType;
@property (strong, nonatomic) NSString *strCategory;
@property (strong, nonatomic) NSString *strUpdatedDate;

@property (strong, nonatomic) NSAttributedString *attributedTitleString;
@property (strong, nonatomic) NSAttributedString *attributedDescString;

@property (assign, nonatomic, getter=isOpen) BOOL open;

+ (Alert *)dataWithInfo:(NSDictionary *)dict;
- (Alert *)initWithDictionary:(NSDictionary *)dict;

@end
