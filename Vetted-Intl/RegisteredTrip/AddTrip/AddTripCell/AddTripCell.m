//
//  AddTripCell.m
//  Vetted-Intl
//
//  Created by Manish on 10/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AddTripCell.h"

@implementation AddTripCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMember:(Member *)member{
    _member = member;
    _lblName.text = [member.strName uppercaseString];
    _lblMobileNumber.text = member.strPhoneNumber;
}

- (IBAction)btnCheckTapped:(UIButton*)sender{
    if([_delegate respondsToSelector:@selector(selectMember:member:)]){
        [_delegate selectMember:self member:_member];
    }
}

@end
