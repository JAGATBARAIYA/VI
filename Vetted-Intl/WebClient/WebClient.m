//
//  WebClient.m
//  iPhoneStructure
//
//  Created by Marvin on 29/04/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#import "WebClient.h"
#import "NSString+extras.h"
#import "Loader.h"
#import "Common.h"
#import "TKAlertCenter.h"
#import "AppDelegate.h"

@interface WebClient()

@end

@implementation WebClient

#pragma mark - Shared Client

+ (id)sharedClient {
    static WebClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

#pragma mark - Get generic Path

- (void)getAtPath:(NSString *)path withParams:(NSDictionary *)params :(void(^)(id jsonData))onComplete failure:(void (^)(NSError *error))failure {
    [[Loader defaultLoader] displayLoadingView:msgLoading];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error= nil;
        if(responseObject){
            NSString *json = [[[NSString alloc] initWithData:(NSData*)responseObject encoding:NSASCIIStringEncoding] trimWhiteSpace];
            NSArray *dictArray = [json componentsSeparatedByString:@"<!-- Hosting24"];
            NSData *data = [dictArray[0] dataUsingEncoding:NSUTF8StringEncoding];
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (error){
                NSLog(@"%@",error.localizedDescription);
                NSLog(@"JSON parsing error in %@", NSStringFromSelector(_cmd));
                [[Loader defaultLoader] hideLoadingView];
                failure(error);
            } else {
                [[Loader defaultLoader] hideLoadingView];
                onComplete(jsonData);
            }
        }else{
            [[Loader defaultLoader] hideLoadingView];
            onComplete(nil);
            return;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request failed %@ (%li)", operation.request.URL, (long)operation.response.statusCode);
        [[Loader defaultLoader] hideLoadingView];
        failure(error);
    }];
}

#pragma mark - Login Call

- (void)loginIntoApplication:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kUserLogin fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Forgot Password Call

- (void)forgotPassword:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kForgotPassword fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)currencyConversion:(NSString*)path success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:path withParams:nil:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Get All Country List

- (void)allCountryList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kGetAllCountries fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Get Bookmark Country List

- (void)bookmarkCountryList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kBookmarkCountries fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)addBookmark:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kAddBookmark fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)deleteBookmark:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kDeleteBookmark fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];    
}

#pragma mark - Get Alerts from Bookmark Country List

- (void)getAlertsFromBookmark:(NSDictionary*)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kAlertsForBookmark fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Save Location

- (void)saveLocation:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kSaveLocation fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Global Information

- (void)globalInfoList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kGlobalInfo fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Get Category List

- (void)getCategoryList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kGetCategory fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Get My Documents List

- (void)getMyDocumentsList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kMyDocuments fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Registered Trip

- (void)registeredTrip:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kRegisteredTrip fullPath] withParams:params :^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getTrip:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kGetTrip fullPath] withParams:params :^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)editTrip:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kEditTrip fullPath] withParams:params :^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)deleteTrip:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kDeleteTrip fullPath] withParams:params :^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];   
}

#pragma mark - Member

- (void)addMember:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kAddMember fullPath] withParams:params :^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getMembers:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kGetMembers fullPath] withParams:params :^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)editMember:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kEditMember fullPath] withParams:params :^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)deleteMember:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kDeleteMember fullPath] withParams:params :^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Edit Profile

- (void)editProfile:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kEditProfile fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)changePassword:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kChangePassword fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Notification

- (void)notification:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kNotification fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)setNotification:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kSetNotification fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
