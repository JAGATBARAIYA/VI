//
//  User.h
//  TravellingApp
//
//  Created by Manish Dudharejia on 15/10/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (assign, nonatomic) NSInteger intUserID;
@property (strong, nonatomic) NSString *strMembershipID;

@property (strong, nonatomic) NSString *strUserName;
@property (strong, nonatomic) NSString *strFirstName;
@property (strong, nonatomic) NSString *strLastName;
@property (strong, nonatomic) NSString *strEmail;
@property (strong, nonatomic) NSString *strDeviceToken;
@property (strong, nonatomic) NSString *strCountryCode;
@property (strong, nonatomic) NSString *strCountryName;
@property (strong, nonatomic) NSString *strCityName;
@property (strong, nonatomic) NSMutableArray *arryNotificatioInfo;
@property (strong, nonatomic) NSMutableDictionary *dictNotificatioInfo;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@property (assign, nonatomic) NSInteger bookmarkCount;

@property (assign, nonatomic, getter=isRememberMe) BOOL rememberMe;
@property (assign, nonatomic, getter=isLogin) BOOL login;
@property (assign, nonatomic, getter=isPushNotification) BOOL pushNotification;
@property (assign, nonatomic, getter=isAlloc) BOOL alloc;

+ (User*)sharedUser;

+ (User *)dataWithInfo:(NSDictionary*)dict;
- (void)initWithDictionary:(NSDictionary*)dict;

+ (BOOL)saveCredentials:(NSDictionary*)json;

@end
