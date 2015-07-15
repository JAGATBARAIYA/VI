//
//  ViewController.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 20/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "Common.h"
#import "MSTextField.h"
#import "Helper.h"
#import "SFHFKeychainUtils.h"
#import "HomeAlertsViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet MSTextField *txtEmail;
@property (strong, nonatomic) IBOutlet MSTextField *txtPassword;
@property (strong, nonatomic) IBOutlet MSTextField *txtForgotEmail;

@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UILabel *lblLogin;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *forgotPasswordView;
@property (strong, nonatomic) IBOutlet UIView *upperView;
@property (strong, nonatomic) IBOutlet UIButton *btnRememberMe;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
@property (strong, nonatomic) IBOutlet UIButton *btnHelp;

@end

@implementation ViewController

#pragma mark - View life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self rememberMeInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    [_txtEmail setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txtPassword setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [Helper registerKeyboardNotification:self];

    [self rememberMeInformation];
    
    if(IPHONE4){
        _upperView.frame = CGRectMake(0, -20, _upperView.frame.size.width, _upperView.frame.size.height);
        _loginView.frame = CGRectMake(0, CGRectGetMaxY(_upperView.frame), _loginView.frame.size.width, _loginView.frame.size.height);
        
        _lblLogin.frame = CGRectMake(_lblLogin.frame.origin.x, 5, _lblLogin.frame.size.width, _lblLogin.frame.size.height);
        _txtEmail.frame = CGRectMake(_txtEmail.frame.origin.x, CGRectGetMaxY(_lblLogin.frame)+5, _txtEmail.frame.size.width, _txtEmail.frame.size.height);
        _txtPassword.frame = CGRectMake(_txtPassword.frame.origin.x, CGRectGetMaxY(_txtEmail.frame)+5, _txtPassword.frame.size.width, _txtPassword.frame.size.height);
        
        _btnRememberMe.frame = CGRectMake(_btnRememberMe.frame.origin.x, CGRectGetMaxY(_txtPassword.frame)+5, _btnRememberMe.frame.size.width, _btnRememberMe.frame.size.height);
        _btnForgotPassword.frame = CGRectMake(_btnForgotPassword.frame.origin.x, CGRectGetMaxY(_txtPassword.frame)+5, _btnForgotPassword.frame.size.width, _btnForgotPassword.frame.size.height);
        
        _btnSignIn.frame = CGRectMake(_btnSignIn.frame.origin.x, CGRectGetMaxY(_btnRememberMe.frame)+5, _btnSignIn.frame.size.width, _btnSignIn.frame.size.height);
        _btnHelp.frame = CGRectMake(_btnHelp.frame.origin.x, CGRectGetMaxY(_btnSignIn.frame)+5, _btnHelp.frame.size.width, _btnHelp.frame.size.height);
    }
}

- (void)rememberMeInformation{
    User *user = [Helper getCustomObjectToUserDefaults:kUserInformation];
    if(user){
        if(user.login){
            [UIApplication sharedApplication].statusBarHidden = NO;
            HomeAlertsViewController *homeAlertsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeAlertsViewController"];
            [self.navigationController pushViewController:homeAlertsViewController animated:NO];
        }else if(user.rememberMe){
            _txtEmail.text = user.strEmail;
            _txtPassword.text = [SFHFKeychainUtils getPasswordForUsername:user.strEmail andServiceName:user.strEmail error:nil];
            _btnRememberMe.selected = YES;
        }
    }else {
        _txtEmail.text = @"";
        _txtPassword.text = @"";
        _btnRememberMe.selected = NO;
    }
}

#pragma mark - Button tap events

- (IBAction)btnRememberMeTapped:(UIButton*)sender {
    sender.selected = !sender.selected;
    [User sharedUser].rememberMe = sender.selected;
}

- (IBAction)btnForgotPasswordTapped:(id)sender {
    [self resignFields];
    _loginView.hidden = YES;
    _forgotPasswordView.hidden = NO;
}

- (IBAction)btnSignInTapped:(id)sender {
    [self resignFields];
    if([self isValidLoginDetails]){
        [[WebClient sharedClient] loginIntoApplication:@{@"email": _txtEmail.text,@"password":_txtPassword.text,@"devicetype":@1,@"devicetoken":[User sharedUser].strDeviceToken} success:^(NSDictionary *dictionary) {
            if(dictionary!=nil){
                if([User saveCredentials:dictionary]) {
                    [User sharedUser].login = YES;
                    if(_btnRememberMe.selected){
                        [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
                        [User sharedUser].strEmail= _txtEmail.text;
                        [SFHFKeychainUtils storeUsername:[User sharedUser].strEmail andPassword:_txtPassword.text forServiceName:[User sharedUser].strEmail updateExisting:YES error:nil];
                    }
                     HomeAlertsViewController *homeAlertsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeAlertsViewController"];
                     [self.navigationController pushViewController:homeAlertsViewController animated:YES];
                }
            }
        } failure:^(NSError *error) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:error.localizedDescription image:kErrorImage];
        }];
    }
//    HomeAlertsViewController *homeAlertsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeAlertsViewController"];
//    [self.navigationController pushViewController:homeAlertsViewController animated:YES];
}

- (IBAction)btnSendTapped:(id)sender {
    [_txtForgotEmail resignFirstResponder];
    if([self isValidForgotDetails]){
        [[WebClient sharedClient] forgotPassword:@{@"email":_txtForgotEmail.text} success:^(NSDictionary *dictionary) {
            BOOL success = [dictionary[@"success"] boolValue];
            if (success) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                [self btnCancelTapped:nil];
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        } failure:^(NSError *error) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:error.localizedDescription image:kErrorImage];
        }];
    }
}

- (IBAction)btnCancelTapped:(id)sender {
    [_txtForgotEmail resignFirstResponder];
    _forgotPasswordView.hidden = YES;
    _loginView.hidden = NO;
}

- (IBAction)btnHelpTapped:(id)sender {
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnTermsAndConditionsTapped:(id)sender {
    
}

#pragma mark - Validate login Information

- (BOOL)isValidLoginDetails{
    if(!_txtEmail.text || [_txtEmail.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:kErrorImage];
        return NO;
    }
    if(![_txtEmail.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
        return NO;
    }
    if(!_txtPassword.text || [_txtPassword.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidPassword image:kErrorImage];
        return NO;
    }
    return YES;
}

- (BOOL)isValidForgotDetails{
    if(!_txtForgotEmail.text || [_txtForgotEmail.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:kErrorImage];
        return NO;
    }
    if(![_txtForgotEmail.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = _mainView.frame;
    if (IPHONE4) {
        frame.origin.y = -150;
    }else if (IPHONE5){
        frame.origin.y = -50;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];
}

- (void)resignFields{
    [_txtEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
}

#pragma mark - Keyboard Notifications

- (void)sfkeyboardWillHide:(NSNotification*)notification{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _mainView.frame;
        frame.origin.y = 0;
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];
}

- (void)sfkeyboardWillShow:(NSNotification*)notification{
    
}

@end


