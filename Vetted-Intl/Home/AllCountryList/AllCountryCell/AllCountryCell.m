//
//  AllCountryCell.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 25/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AllCountryCell.h"

@implementation AllCountryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)setCountry:(Country *)country{
    _country = country;
    _lblCountryName.text = country.strCountryName;
    _btnCheck.selected = country.isSelected;
}

- (IBAction)btnCheckTapped:(UIButton*)sender{
    sender.selected = !sender.selected;
    _country.isSelected = sender.selected;
}

@end
