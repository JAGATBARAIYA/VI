//
//  CategoryCell.m
//  Vetted-Intl
//
//  Created by Manish on 26/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "CategoryCell.h"
#import "UILabel+extras.h"
#import "AFBlockAttributedLabel.h"

@implementation CategoryCell

- (void)awakeFromNib {

}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setGlobalInfo:(GlobalInfo *)globalInfo{
    _globalInfo = globalInfo;
    _lblDescription.attributedText = globalInfo.attributedString;
}

@end
