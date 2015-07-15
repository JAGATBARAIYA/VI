//
//  Member.h
//  Vetted-Intl
//
//  Created by Manish on 10/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

@property (assign, nonatomic) NSInteger intAge;
@property (assign, nonatomic) NSInteger intMemberID;

@property (strong, nonatomic) NSString *strName;
@property (strong, nonatomic) NSString *strRelationship;
@property (strong, nonatomic) NSString *strPhoneNumber;
@property (strong, nonatomic) NSString *strEmail;

@property (assign, nonatomic) BOOL isAssistmember;
@property (assign, nonatomic) BOOL isHide;
@property (assign, nonatomic) BOOL isSelected;

+ (Member *)dataWithInfo:(NSDictionary *)dict;
- (Member *)initWithDictionary:(NSDictionary *)dict;

@end
