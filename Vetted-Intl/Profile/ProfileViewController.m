//
//  ProfileViewController.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 26/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "ProfileViewController.h"
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
#import "ChangePasswordViewController.h"

@interface ProfileViewController ()

@property (strong, nonatomic) IBOutlet MSTextField *txtFirstname;
@property (strong, nonatomic) IBOutlet MSTextField *txtLastname;
@property (strong, nonatomic) IBOutlet MSTextField *txtEmail;

@end

@implementation ProfileViewController

#pragma mark - View life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [[BNEasyGoogleAnalyticsTracker sharedTracker] trackScreenNamed:msgProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    [self addPanicView];
    [self fillData];
}

- (void)fillData{
    _txtEmail.text = [User sharedUser].strEmail;
    _txtFirstname.text = [User sharedUser].strFirstName;
    _txtLastname.text = [User sharedUser].strLastName;
}

#pragma mark - Button tap events

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnDoneTapped:(id)sender{
    [self.view endEditing:YES];
    if([self validateProfileInfo]){
        [[WebClient sharedClient]editProfile:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"firstname":_txtFirstname.text,@"lastname":_txtLastname.text,@"email":_txtEmail.text} success:^(NSDictionary *dictionary) {
            BOOL success = [dictionary[@"success"] boolValue];
            if(success){
                if ([User sharedUser].rememberMe) {
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                    [User sharedUser].strFirstName = _txtFirstname.text;
                    [User sharedUser].strEmail = _txtEmail.text;
                    
                    if(![_txtEmail.text isEmptyString]  && [User sharedUser].rememberMe){
                        [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
                    }
                }
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:error.localizedDescription image:kErrorImage];
        }];
    }
    
}

- (IBAction)btnMenuTapped:(id)sender{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)btnChangePasswordTapped:(id)sender{
    ChangePasswordViewController *changePasswordViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self.navigationController pushViewController:changePasswordViewController animated:YES];
}

#pragma mark - Validate Profile Information

- (BOOL)validateProfileInfo{
    if([_txtFirstname.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterFirstName image:kErrorImage];
        return NO;
    } else if([_txtLastname.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterLastName image:kErrorImage];
        return NO;
    } else if([_txtEmail.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:kErrorImage];
        return NO;
    } else if(![_txtEmail.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
