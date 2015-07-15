//
//  WebClient.h
//  iPhoneStructure
//
//  Created by Marvin on 29/04/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebKit.h"

typedef void(^WebClientCallbackSuccess)(NSDictionary *dictionary);
typedef void(^WebClientCallbackFailure)(NSError *error);

@interface WebClient : NSObject

//Shared Client method
+ (id)sharedClient;

- (void)getAtPath:(NSString *)path withParams:(NSDictionary *)params :(void(^)(id jsonData))onComplete failure:(void (^)(NSError *error))failure;

//Login
- (void)loginIntoApplication:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)forgotPassword:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Location
- (void)saveLocation:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Currency
- (void)currencyConversion:(NSString*)path success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Get all/bookmark Countries
- (void)allCountryList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)bookmarkCountryList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Get Alerts from Bookmark Country List
- (void)getAlertsFromBookmark:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Bookmark
- (void)addBookmark:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)deleteBookmark:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Global Information
- (void)globalInfoList:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Category
- (void)getCategoryList:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//My Documents
- (void)getMyDocumentsList:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Registered Trip
- (void)registeredTrip:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)getTrip:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)editTrip:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)deleteTrip:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Member
- (void)addMember:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)getMembers:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)editMember:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)deleteMember:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Edit Profile
- (void)editProfile:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)changePassword:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Notification
- (void)notification:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Set Notification
- (void)setNotification:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

@end
