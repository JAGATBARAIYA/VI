//
//  MyDocumentsCell.m
//  Vetted-Intl
//
//  Created by Manish on 27/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "MyDocumentsCell.h"

@implementation MyDocumentsCell

- (void)awakeFromNib {
    // Initialization code
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setMyDocuments:(MyDocuments *)myDocuments{
    _myDocuments = myDocuments;
}

@end
