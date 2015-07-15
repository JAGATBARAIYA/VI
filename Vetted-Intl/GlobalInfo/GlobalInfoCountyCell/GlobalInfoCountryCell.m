//
//  GlobalInfoCountryCell.m
//  Vetted-Intl
//
//  Created by Manish on 26/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "GlobalInfoCountryCell.h"

@implementation GlobalInfoCountryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)setCountry:(Country *)country{
    _country = country;
    _lblCountryName.text = country.strCountryName;
}

@end
