//
//  ChangePasswordViewController.m
//  Vetted-Intl
//
//  Created by Manish on 23/04/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Helper.h"
#import "MSTextField.h"
#import "User.h"
#import "TKAlertCenter.h"
#import "MFSideMenu.h"
#import "Common.h"
#import "SFHFKeychainUtils.h"
#import "BNEasyGoogleAnalyticsTracker.h"
#import "REFrostedViewController.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"


@interface ChangePasswordViewController ()

@property (strong, nonatomic) IBOutlet MSTextField *txtOldPassword;
@property (strong, nonatomic) IBOutlet MSTextField *txtNewPassword;
@property (strong, nonatomic) IBOutlet MSTextField *txtConfirmPassword;

@end

@implementation ChangePasswordViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    [self addPanicView];
}

//editpassword.php: userid,password,oldpassword
#pragma mark - Button Click Event

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDoneTapped:(id)sender{
    [self save:YES];
}

- (IBAction)btnSaveTapped:(id)sender{
    [self save:NO];
}

- (void)save:(BOOL)value{
    if([self validateProfileInfo]){
        [[WebClient sharedClient]changePassword:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"password":(_txtNewPassword.text==nil)?@"":_txtNewPassword.text,@"oldpassword":_txtOldPassword.text} success:^(NSDictionary *dictionary) {
            BOOL success = [dictionary[@"success"] boolValue];
            if(success){
                if ([User sharedUser].rememberMe) {
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                    if ([_txtNewPassword.text trimWhiteSpace].length != 0) {
                        [SFHFKeychainUtils storeUsername:[User sharedUser].strEmail andPassword:_txtNewPassword.text forServiceName:[User sharedUser].strEmail updateExisting:YES error:nil];
                    }
                    [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
                    [self clearFields];
                }
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
            if (value) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:error.localizedDescription image:kErrorImage];
        }];
    }
}

- (BOOL)validateProfileInfo{
    if([_txtOldPassword.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterOldPassword image:kErrorImage];
        return NO;
    } else if([_txtOldPassword.text isEmptyString] && (![_txtNewPassword.text isEmptyString] || ![_txtConfirmPassword.text isEmptyString])){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterOldPassword image:kErrorImage];
        return NO;
    } else if (![_txtOldPassword.text isEmptyString]){
        if(![_txtNewPassword.text isEmptyString] && ![_txtConfirmPassword.text isEmptyString]){
            if(![_txtNewPassword.text isEqualToString:_txtConfirmPassword.text]){
                [[TKAlertCenter defaultCenter] postAlertWithMessage:msgPasswordAndConfirmPasswordMatch image:kErrorImage];
                return NO;
            }
        }else if([_txtNewPassword.text isEmptyString] || [_txtConfirmPassword.text isEmptyString]){
            [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidPassword image:kErrorImage];
            return NO;
        }
    }
    if(![_txtOldPassword.text isEmptyString]  && [User sharedUser].rememberMe){
        NSString *password = [SFHFKeychainUtils getPasswordForUsername:[User sharedUser].strEmail andServiceName:[User sharedUser].strEmail error:nil];
        if(![password isEqualToString:_txtOldPassword.text]){
            [[TKAlertCenter defaultCenter] postAlertWithMessage:msgOldPasswordNotMatch image:kErrorImage];
            return NO;
        }
    }
    return YES;
}

- (void)clearFields{
    _txtOldPassword.text = @"";
    _txtNewPassword.text = @"";
    _txtConfirmPassword.text = @"";
}

@end
