//
//  CategoryHeaderView.m
//  Vetted-Intl
//
//  Created by Manish on 20/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "CategoryHeaderView.h"
#import "NSString+extras.h"
#import "UILabel+extras.h"

#define commonColorGreen      [UIColor colorWithRed:(5.0/255.0) green:(157.0/255.0) blue:(84.0/255.0) alpha:1.0];

@implementation CategoryHeaderView

- (void)awakeFromNib{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
    [self addGestureRecognizer:tapGesture];
}

- (IBAction)toggleOpen:(id)sender {
    [self toggleOpenWithUserAction:YES];
}

- (void)setGlobalInfo:(GlobalInfo *)globalInfo{
    _globalInfo = globalInfo;
    _btnToggleIcon.selected = _globalInfo.open;
    if (_globalInfo.open) {
        [_btnToggleIcon setImage:[UIImage imageNamed:@"green_arow_up"] forState:UIControlStateNormal];
    }else{
        [_btnToggleIcon setImage:[UIImage imageNamed:@"down_arow"] forState:UIControlStateNormal];
    }
    _lblTitle.text = globalInfo.strCategoryName;
    _lblTitle.textColor = commonColorGreen;
}

- (void)toggleOpenWithUserAction:(BOOL)userAction {
    if(userAction){
        _btnToggleIcon.selected = _globalInfo.open;
        if(!_globalInfo.open){
            [_btnToggleIcon setImage:[UIImage imageNamed:@"green_arow_up"] forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(categoryHeaderView:sectionOpened:)]) {
                [_delegate categoryHeaderView:self sectionOpened:self.tag];
            }
        }else {
            [_btnToggleIcon setImage:[UIImage imageNamed:@"down_arow"] forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(categoryHeaderView:sectionClosed:)]) {
                [_delegate categoryHeaderView:self sectionClosed:self.tag];
            }
        }
    }
}

@end
