//
//  AlertHeaderView.m
//  Vetted-Intl
//
//  Created by Manish on 17/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AlertHeaderView.h"

#define commonColorRed      [UIColor colorWithRed:(231.0/255.0) green:(78.0/255.0) blue:(85.0/255.0) alpha:1.0];
#define commonColorYellow   [UIColor colorWithRed:(244.0/255.0) green:(201.0/255.0) blue:(14.0/255.0) alpha:1.0];

@interface AlertHeaderView ()

@end

@implementation AlertHeaderView

- (void)awakeFromNib{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
    [self addGestureRecognizer:tapGesture];
}

- (IBAction)toggleOpen:(id)sender {
    [self toggleOpenWithUserAction:YES];
}

- (void)setAlert:(Alert *)alert{
    _alert = alert;
    _lblTitle.text = _alert.strTitle;
    _lblUpdatedDate.text = [@"Updated: " stringByAppendingString:_alert.strUpdatedDate];
    _btnToggleIcon.selected = _alert.open;
    if (_alert.open) {
        [_btnToggleIcon setImage:[UIImage imageNamed:@"green_arow_up"] forState:UIControlStateNormal];
    }else{
        [_btnToggleIcon setImage:[UIImage imageNamed:@"down_arow"] forState:UIControlStateNormal];
    }
    if ([_alert.strAlertType isEqualToString:@"alert"]) {
        _viewColor.backgroundColor = commonColorYellow;
    }else{
        _viewColor.backgroundColor = commonColorRed;
    }
    
    if([alert.strCategory isEqualToString:@"Travel/Security"]){
        _lblIcon.image = [UIImage imageNamed:@"us_icon2"];
    }else if([alert.strCategory isEqualToString:@"Medical"]){
        _lblIcon.image = [UIImage imageNamed:@"us_icon1"];
    } else if([alert.strCategory isEqualToString:@"Weather"]){
        _lblIcon.image = [UIImage imageNamed:@"us_icon3"];
    }else {
        _lblIcon.image = [UIImage imageNamed:@"us_icon4"];
    }
}

- (void)toggleOpenWithUserAction:(BOOL)userAction {
    if(userAction){
        _btnToggleIcon.selected = _alert.open;
        if(!_alert.open){
            [_btnToggleIcon setImage:[UIImage imageNamed:@"green_arow_up"] forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(alertHeaderView:sectionOpened:)]) {
                [_delegate alertHeaderView:self sectionOpened:self.tag];
            }
        }else {
            [_btnToggleIcon setImage:[UIImage imageNamed:@"down_arow"] forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(alertHeaderView:sectionClosed:)]) {
                [_delegate alertHeaderView:self sectionClosed:self.tag];
            }
        }
    }
}

@end
