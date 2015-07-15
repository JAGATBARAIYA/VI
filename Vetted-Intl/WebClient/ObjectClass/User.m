//
//  User.m
//  TravellingApp
//
//  Created by Manish Dudharejia on 15/10/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#define kIsRememberMe           @"RememberMe"
#define kUserID                 @"UserID"
#define kUserName               @"UserName"
#define kFirstName              @"FirstName"
#define kLastName               @"LastName"
#define kUserEmail              @"UserEmail"
#define kPassword               @"Password"
#define kIsLogin                @"IsLogin"
#define kDeviceToken            @"DeviceToken"
#define kBookmarkCount          @"BookmarkCount"
#define kMembershipID           @"MembershipID"
#define kIsPushNotification     @"PushNotification"

#import "User.h"
#import "Common.h"
#import "Helper.h"

@implementation User

+ (User*)sharedUser{
    static User *sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        User *user = [Helper getCustomObjectToUserDefaults:kUserInformation];
        if(!user){
            sharedUser = [[User alloc] init];
        }else {
            sharedUser = user;
        }
    });
    return sharedUser;
}

- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (User *)dataWithInfo:(NSDictionary*)dict{
    return [[self alloc] initWithDict:dict];
}

- (void)initWithDictionary:(NSDictionary*)dict{
    User *user = [User sharedUser];
    if(dict[@"userid"]!=[NSNull null])
        user.intUserID = [dict[@"userid"] integerValue];
    
    if(dict[@"email"]!=[NSNull null])
        user.strEmail = dict[@"email"];
    
    if(dict[@"membershipid"]!=[NSNull null])
        user.strMembershipID = dict[@"membershipid"];
    
    if(dict[@"username"]!=[NSNull null])
        user.strUserName = dict[@"username"];

    if(dict[@"firstname"]!=[NSNull null])
        user.strFirstName = dict[@"firstname"];
    
    if(dict[@"lastname"]!=[NSNull null])
        user.strLastName = dict[@"lastname"];

    if(dict[@"bookmark_country_count"]!=[NSNull null])
        user.bookmarkCount = [dict[@"bookmark_country_count"] integerValue];
    
    if(dict[@"status"]!=[NSNull null])
        user.pushNotification = [dict[@"status"] integerValue];




}


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeBool:self.rememberMe forKey:kIsRememberMe];
    [encoder encodeBool:self.login forKey:kIsLogin];
    [encoder encodeInteger:self.intUserID forKey:kUserID];
    [encoder encodeObject:self.strEmail forKey:kUserEmail];
    [encoder encodeObject:self.strMembershipID forKey:kMembershipID];
    [encoder encodeObject:self.strUserName forKey:kUserName];
    [encoder encodeObject:self.strFirstName forKey:kFirstName];
    [encoder encodeObject:self.strLastName forKey:kLastName];
    [encoder encodeObject:self.strDeviceToken forKey:kDeviceToken];
    [encoder encodeInteger:self.bookmarkCount forKey:kBookmarkCount];
    [encoder encodeBool:self.pushNotification forKey:kIsPushNotification];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if( self != nil ) {
        self.rememberMe = [decoder decodeBoolForKey:kIsRememberMe];
        self.login = [decoder decodeBoolForKey:kIsLogin];
        self.intUserID = [decoder decodeIntegerForKey:kUserID];
        self.strUserName = [decoder decodeObjectForKey:kUserName];
        self.strFirstName = [decoder decodeObjectForKey:kFirstName];
        self.strLastName = [decoder decodeObjectForKey:kLastName];
        self.strEmail = [decoder decodeObjectForKey:kUserEmail];
        self.strMembershipID = [decoder decodeObjectForKey:kMembershipID];
        self.strDeviceToken = [decoder decodeObjectForKey:kDeviceToken];
        self.bookmarkCount = [decoder decodeIntegerForKey:kBookmarkCount];
        self.pushNotification = [decoder decodeBoolForKey:kIsPushNotification];
    }
    return self;
}

+ (BOOL)saveCredentials:(NSDictionary*)json{
    BOOL success = [json[@"success"] boolValue];
    if (success) {
        [[User sharedUser] initWithDictionary:json[@"userdata"]];
    }else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:json[@"message"] image:kErrorImage];
    }
    return success;
}

@end
