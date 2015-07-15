//
//  CountryCell.m
//  Vetted-Intl
//
//  Created by Manish on 23/04/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "CountryCell.h"

@implementation CountryCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCountry:(Country *)country{
    _country = country;
    _lblCountryName.text = _country.strCountryName;
}

@end
