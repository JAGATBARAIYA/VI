//
//  PanicView.m
//  Vetted-Intl
//
//  Created by Manish on 12/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "PanicView.h"
#import "WebClient.h"
#import "User.h"
#import "Helper.h"

@interface PanicView ()

@property (strong, nonatomic) NSString *strEvent;

@end

@implementation PanicView

- (void)awakeFromNib{
    _btnPanic.hidden = NO;
    _callView.hidden = YES;
}

#pragma mark - Button tap events

- (IBAction)btnPoliceTapped:(id)sender {
    _panicType = PanicTypePolice;
    [self callNotification];
}

- (IBAction)btnFireTapped:(id)sender {
    _panicType = PanicTypeFire;
    [self callNotification];
}

- (IBAction)btnEMSTapped:(id)sender {
    _panicType = PanicTypeEMS;
    [self callNotification];
}

- (IBAction)btnCancelTapped:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Notification

- (void)callNotification{
    [self btnCancelTapped:nil];
    
    [[WebClient sharedClient]notification:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"latitudes":[NSNumber numberWithDouble:[User sharedUser].latitude],@"longitudes":[NSNumber numberWithDouble:[User sharedUser].longitude],@"city":([User sharedUser].strCityName)==nil?@"":[User sharedUser].strCityName,@"country":([User sharedUser].strCountryName)==nil?@"":[User sharedUser].strCountryName,@"event":_panicType} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

@end
