//
//  AddMemberViewController.m
//  Vetted-Intl
//
//  Created by Manish on 12/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AddMemberViewController.h"
#import "MSTextField.h"
#import "WebClient.h"
#import "Member.h"
#import "Helper.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"

@interface AddMemberViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet MSTextField *txtName;
@property (strong, nonatomic) IBOutlet MSTextField *txtAge;
@property (strong, nonatomic) IBOutlet MSTextField *txtRelationship;
@property (strong, nonatomic) IBOutlet MSTextField *txtPhoneNumber;
@property (strong, nonatomic) IBOutlet MSTextField *txtEmail;

@property (strong, nonatomic) IBOutlet UIButton *btnCheck;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UILabel *lblAddMember;
@property (strong, nonatomic) IBOutlet UILabel *lblUpdateMember;
@property (strong, nonatomic) IBOutlet UIView *memberView;
@property (strong, nonatomic) IBOutlet UIView *mainView;


@end

@implementation AddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    if(_member){
        _lblAddMember.text = @"UPDATE TRAVELER";
        _btnUpdate.hidden = NO;
        _btnSave.hidden = YES;
    }else {
        _lblAddMember.text = @"ADD TRAVELER";
        _btnUpdate.hidden = YES;
        _btnSave.hidden = NO;
    }
    
//    if (_member.isHide == YES) {
//        _btnUpdate.hidden = _lblUpdateMember.hidden = YES;
//        _btnSave.hidden = _lblAddMember.hidden = NO;
//    }else{
//        _btnUpdate.hidden = _lblUpdateMember.hidden = NO;
//        _btnSave.hidden = _lblAddMember.hidden = YES;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)commonInit{
    [self addPanicView];
    [Helper registerKeyboardNotification:self];
    if (_member.intAge!=0) {
        _txtAge.text = [NSString stringWithFormat:@"%ld",(long)_member.intAge];
    }
    _txtName.text = _member.strName;
    _txtRelationship.text = _member.strRelationship;
    _txtPhoneNumber.text = _member.strPhoneNumber;
    _txtEmail.text = _member.strEmail;
    _btnCheck.selected = _member.isAssistmember;
}

#pragma mark - Keyboard Notifications

//-(void)sfkeyboardWillShow:(NSNotification*)notification{
//    if (IPHONE4) {
//        CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGRect newFrame = _memberView.frame;
//        newFrame.origin.y = keyboardFrame.size.height-260;
//        _memberView.frame = newFrame;
//    }else{
//        CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGRect newFrame = _memberView.frame;
//        newFrame.origin.y = keyboardFrame.size.height-226;
//        _memberView.frame = newFrame;
//    }
//}
//
//-(void)sfkeyboardWillHide:(NSNotification*)notification{
//    CGRect newFrame = _memberView.frame;
//    newFrame.origin.y = 0;
//    _memberView.frame = newFrame;
//}

#pragma mark - Button tap events

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCheckTapped:(UIButton*)sender{
    sender.selected = !sender.selected;
    _btnCheck.tag = sender.selected;
}

- (IBAction)btnDoneTapped:(id)sender{
    [self resignFields];
    if (_member == nil) {
        [self saveMember:YES];
    }else{
        [self btnUpdateTapped:nil];
    }
}

- (IBAction)btnSaveTapped:(id)sender{
    [self resignFields];
    [self saveMember:NO];
}

- (IBAction)btnUpdateTapped:(id)sender{
    if ([self validation]) {
        [[WebClient sharedClient] editMember:@{@"memberid":[NSNumber numberWithInteger:_member.intMemberID ],@"name":_txtName.text,@"age":_txtAge.text,@"relationship":_txtRelationship.text,@"phone":_txtPhoneNumber.text,@"email":_txtEmail.text,@"isAssistmember":[NSNumber numberWithInteger:_btnCheck.tag]} success:^(NSDictionary *dictionary) {
            if([dictionary[@"success"] boolValue] == YES){
//                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        } failure:^(NSError *error) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
        }];
    }
}

- (void)saveMember:(BOOL)pDone{
    if ([self validation]) {
        [[WebClient sharedClient] addMember:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"name":_txtName.text,@"age":_txtAge.text,@"relationship":_txtRelationship.text,@"phone":_txtPhoneNumber.text,@"email":_txtEmail.text,@"isAssistmember":[NSNumber numberWithInteger:_btnCheck.tag]} success:^(NSDictionary *dictionary) {
            NSLog(@"%@",dictionary);
            if([dictionary[@"success"] boolValue] == YES){
                if(_delegate)
                    [self performSelector:@selector(getData) withObject:nil afterDelay:.5];

                if(pDone)
                    [self.navigationController popViewControllerAnimated:YES];
                else{
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                }
                [self clearTextFields];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        } failure:^(NSError *error) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
        }];
    }
}

- (void)getData{
    if([_delegate respondsToSelector:@selector(getMembersList)]){
        [_delegate getMembersList];
    }
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _txtAge) {
        if([string isNumeric]){
            return YES;
        }
        return NO;
    }
    if (textField == _txtPhoneNumber) {
        if([string isNumeric]){
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)resignFields{
    [_txtAge resignFirstResponder];
    [_txtName resignFirstResponder];
    [_txtRelationship resignFirstResponder];
    [_txtPhoneNumber resignFirstResponder];
    [_txtEmail resignFirstResponder];
}

- (void)clearTextFields{
    _txtAge.text = @"";
    _txtName.text = @"";
    _txtRelationship.text = @"";
    _txtPhoneNumber.text = @"";
    _txtEmail.text = @"";
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = _mainView.frame;
    if (IPHONE4) {
        frame.origin.y = -50;
    }else if (IPHONE5){
        frame.origin.y = -10;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        _mainView.frame = frame;
    }];
    [UIView commitAnimations];
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

- (BOOL)validation{
    if([_txtName.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterName image:nil];
        return NO;
    }else if ([_txtAge.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterAge image:nil];
        return NO;
    }else if ([_txtRelationship.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterRelationship image:nil];
        return NO;
    }else if ([_txtPhoneNumber.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterPhoneNumber image:nil];
        return NO;
    }else if ([_txtEmail.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:nil];
        return NO;
    }else if(![_txtEmail.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:nil];
        return NO;
    }
    return YES;
}

@end
