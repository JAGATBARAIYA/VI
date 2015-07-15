//
//  Common.h
//  FlipIn
//
//  Created by Marvin on 20/11/13.
//  Copyright (c) 2013 Marvin. All rights reserved.
//

#ifndef iPhoneStructure_Common_h
#define iPhoneStructure_Common_h

#pragma mark - All Common Macros

#define isiPhone5                               (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define kUserDirectoryPath                      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
#define IS_IOS7_OR_GREATER                      [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ? YES : NO
#define PLAYER                                  [MPMusicPlayerController iPodMusicPlayer]

//#define IPHONE4                                 [UIScreen mainScreen].bounds.size.height==480
//#define IPHONE5                                 [UIScreen mainScreen].bounds.size.height==568
//#define IPHONE6                                 [UIScreen mainScreen].bounds.size.height==667
//#define IPHONE6PLUS                             [UIScreen mainScreen].bounds.size.height==737

#define IS_IPHONE                               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH                            ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                           ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH                       (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH                       (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IPHONE4                                 (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IPHONE5                                 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IPHONE6                                 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IPHONE6PLUS                             (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kRandomPasswordString                   @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

#define DegreesToRadians(degrees)               (degrees * M_PI / 180)
#define RadiansToDegrees(radians)               (radians * 180/M_PI)

#define kGeoCodingString                        @"http://maps.google.com/maps/geo?q=%f,%f&output=csv"
#define kNotificationMessage                    @"Notification Message."
#define kRemindMeNotificationDataKey            @"kRemindMeNotificationDataKey"

#define kDateFormat                             @"MMM dd, yyyy"
#define kNotificationtableName                  @"tbl_CountryNotification"
#define kErrorImage                             [UIImage imageNamed:@"error"]
#define kRightImage                             [UIImage imageNamed:@"right"]

#define kUserInformation                        @"UserInformation"

#define msgLoading                              @"Loading"
#define msgPleaseWait                           @"Please wait..."

#define msgCameraNotAvailable                   @"Camera not available"           
#define msgNoDataFound                          @"No Record Found"           

#define titleCalling                            @"Calling"
#define msgCallingAlert                         @"is not supported on this device."           
#define kCallNumber                             @"+1 (919) 324-5149"

#define titleFail                               @"Fail"           
#define titleSuccess                            @"Success"           

#define msgFailedResponse                       @"Request processing failed. Please try again."
#define msgNoBookmarkCountry                    @"There are no any bookmark country."
#define msgUserInfo                             @"UserInformation"

//#define msgHomeAlert                            @"Home/Alert"
//#define msgCurrenceyConveter                    @"Currency Conversion"
//#define msgGlobalInformation                    @"Global Information"
//#define msgMyDocument                           @"My Documents"
//#define msgProfile                              @"Profile"

//Login
#define msgEnterEmail                           @"Please enter email address."
#define msgEnterValidEmail                      @"Please enter a valid email address."
#define msgEnterValidPassword                   @"Please enter password."

//Validation
#define msgDestinationEmpty                     @"Please enter destination."
#define msgCityEmpty                            @"Please enter city or state."
#define msgFromDateEmpty                        @"Please enter From date."
#define msgToDateEmpty                          @"Please enter To date."
#define msgDateDifference                       @"To Date should be greater than From Date."

#define msgEnterName                            @"Please enter traveler name."
#define msgEnterAge                             @"Please enter age."
#define msgEnterPhoneNumber                     @"Please enter phone number."
#define msgEnterRelationship                    @"Please enter relationship with traveler."

//Location
#define msgTimeOut                              @"Location request timed out. Current Location:\n%@"
#define msgLocationNotDetermine                 @"Location can not be determined. Please try again later."
#define msgUserDeniedPermission                 @"You have denied to access your device location."
#define msgUserRestrictedLocation               @"User is restricted using location services as per usage policy."
#define msgLocationTurnOff                      @"Location services are turned off for all apps on this device."
#define msgLocationError                        @"An unknown error occurred while retrieving current location. Please try again later."

//Messages
#define msgDelete                               @"Delete?"
#define msgDeleteConfirmation                   @"Are you sure you want to delete this registered trip?"
#define msgUnfavouriteConfirmation              @"Are you sure you want to remove this country from bookmark?"
#define msgDeleteMember                         @"Are you sure you want to delete this traveler?"

//Country
#define msgSelectCountries                      @"Please select countries to add bookmark."

//Profile
#define msgEnterFirstName                       @"Please enter first name."
#define msgEnterLastName                        @"Please enter last name."
#define msgEnterOldPassword                     @"Please enter old password."
#define msgOldPasswordNotMatch                  @"Old password does not match. Please try again."
#define msgPasswordAndConfirmPasswordMatch      @"Password and Confirm password must be same."

#endif
