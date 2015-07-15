//
//  CurrencyListCell.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 21/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "CurrencyListCell.h"

@implementation CurrencyListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)setCurrency:(Currency *)currency{
    _currency = currency;
    _lblCurrency.text = currency.strName;
    _lblCurrencyCode.text = currency.strCode;
    
    _btnFrom.selected = _currency.isFromCode;
    _btnTo.selected = _currency.isToCode;
}

- (IBAction)btnToTapped:(UIButton*)sender {
    if([_delegate respondsToSelector:@selector(selectToCurrency:currency:)]){
        [_delegate selectToCurrency:self currency:_currency];
    }
}

@end
