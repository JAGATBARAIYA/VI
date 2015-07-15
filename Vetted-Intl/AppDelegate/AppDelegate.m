//
//  AppDelegate.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 20/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AppDelegate.h"
#import "SQLiteManager.h"
#import "MFSideMenuContainerViewController.h"
#import "BNEasyGoogleAnalyticsTracker.h"
#import "ViewController.h"
#import "User.h"
#import "SIAlertView.h"
#import "Helper.h"
#import "HomeAlertsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [SQLiteManager singleton];
    
    
   // NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"1",@"country_id",@"india",@"country_name", nil];
   // NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"2",@"country_id",@"bb",@"country_name", nil];
    
   // [[SQLiteManager singleton] save:dict1 into:kNotificationtableName];
//    [[SQLiteManager singleton] save:dict2 into:kNotificationtableName];
    
    
    NSLog(@"path:%@",[Helper getDocumentDirectoryPath:@"path"]);
//    if(![Helper getBoolFromUserDefaults:@"isAlloc"]){
//        [User sharedUser].alloc = YES;
//        [User sharedUser].arryNotificatioInfo = [[NSMutableArray alloc]init];
//        [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
//        
//        [Helper addBoolToUserDefaults:YES forKey:@"isAlloc"];
//    }
//    
//    if ([Helper getBoolFromUserDefaults:@"isAlloc"] == YES) {
//        
//        User *uu = [Helper getCustomObjectToUserDefaults:kUserInformation];
//        
//        [uu.arryNotificatioInfo addObject:dict1];
//        [Helper addCustomObjectToUserDefaults:uu key:kUserInformation];
//    }
    
    //[Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
    
    
    
    
    
    [User sharedUser].strDeviceToken = @"";
    application.statusBarHidden = NO;
    
    [BNEasyGoogleAnalyticsTracker startWithTrackingId:@"UA-60190215-1"];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName, [UIFont fontWithName:@"Roboto-Regular" size:15.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName, [UIFont fontWithName:@"Roboto-Bold" size:19.0], NSFontAttributeName, nil]];
    
   
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    
    return YES;
}


//----------------

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *strDevicetoken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSLog(@"devicetoken = %@",strDevicetoken);
    [User sharedUser].strDeviceToken = strDevicetoken;
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Error %@",error.localizedDescription);
}

#ifdef isAtLeastiOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler{
    if ([identifier isEqualToString:@"declineAction"]){
    } else if ([identifier isEqualToString:@"answerAction"]){
    }
}

#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [self applicationBadgeUpdate:userInfo];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
   
    [self applicationBadgeUpdate:userInfo];
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getListOfNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadtableview" object:nil];
       
        completionHandler(UIBackgroundFetchResultNewData);
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getListOfNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"navigatetoAlertViewcontroller" object:nil];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadtableview" object:nil];
        // Push Notification received in the background
    }
}

- (void)applicationBadgeUpdate:(NSDictionary*)userInfo{
    if(userInfo[@"aps"]!=[NSNull null])
    {
         NSInteger oneValue = [[[User sharedUser].dictNotificatioInfo valueForKey:@"countryid"] integerValue];

         [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
         [User sharedUser].dictNotificatioInfo =[[NSMutableDictionary alloc]initWithDictionary:userInfo];
         [[User sharedUser].arryNotificatioInfo addObject:[NSNumber numberWithInteger:oneValue]];
         [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
         //[[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationBadgeObserver" object:nil];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveMessage" object:nil];
        
        
        NSMutableDictionary *dictUserinfo =[[NSMutableDictionary alloc]initWithObjectsAndKeys:userInfo[@"countryid"],@"country_id",userInfo[@"countryname"],@"country_name", nil];
    
        [[SQLiteManager singleton] save:dictUserinfo into:kNotificationtableName];
      
      [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
    
  }
}

//------------------


+ (AppDelegate*)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)callEmergency{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Call" andMessage:@"Need Emergency Assistance?"];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"Confirm"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [Helper callTheNumber:kCallNumber];
                          }];
    [alertView addButtonWithTitle:@"Cancel"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.window.rootViewController;
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"getListOfNotification" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadtableview" object:nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
