//
//  WebKit.h
//  iPhoneStructure
//
//  Created by Marvin on 29/04/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#ifndef iPhoneStructure_WebKit_h
#define iPhoneStructure_WebKit_h

//Live Server

#define kWebserviceURL                          @"https://admin.travelassistnow.com/Webservices/"
//#define kWebserviceURL                          @"http://dev-imaginovation.net/vettedintl/Webservices/"


//Login/Register
#define kUserLogin                              @"login.php"
#define kForgotPassword                         @"forgot_password.php"

//Location
#define kSaveLocation                           @"save_location.php"

//Get All//Bookmark Countries
#define kGetAllCountries                        @"get_countries.php"
#define kBookmarkCountries                      @"get_bookmark_countries.php"

//Alerts for Bookmark Country
#define kAlertsForBookmark                      @"get_alerts.php"

//Bookmark
#define kAddBookmark                            @"save_bookmark.php"
#define kDeleteBookmark                         @"delete_bookmark.php"

//Global Information
#define kGlobalInfo                             @"get_globalinfo_countries.php"

//Category
#define kGetCategory                            @"get_globalinfo.php"

//My Documents
#define kMyDocuments                            @"file_list.php"

//Registered Trip
#define kRegisteredTrip                         @"register_trip.php"
#define kGetTrip                                @"get_trip.php"
#define kEditTrip                               @"edit_trip.php"
#define kDeleteTrip                             @"delete_trip.php"

//Member
#define kAddMember                              @"add_member.php"
#define kGetMembers                             @"get_members.php"
#define kEditMember                             @"edit_member.php"
#define kDeleteMember                           @"delete_member.php"

//Edit Profile
#define kEditProfile                            @"editprofile.php"
#define kChangePassword                         @"editpassword.php"

//Notification
#define kNotification                           @"notification.php"

//Set Notification
#define kSetNotification                        @"set_pushnotification.php"

#import "AFNetworking.h"
#import "WebClient.h"
#import "User.h"
#import "AppDelegate.h"

#endif
