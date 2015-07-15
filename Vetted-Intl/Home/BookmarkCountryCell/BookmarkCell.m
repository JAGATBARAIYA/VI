//
//  BookmarkCell.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 25/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "BookmarkCell.h"

@implementation BookmarkCell

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
