//
//  AlertCell.m
//  Vetted-Intl
//
//  Created by Manish on 17/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AlertCell.h"

@implementation AlertCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)setAlert:(Alert *)alert{
    _alert = alert;
    _lblAlertText.attributedText = _alert.attributedDescString;
}

@end
