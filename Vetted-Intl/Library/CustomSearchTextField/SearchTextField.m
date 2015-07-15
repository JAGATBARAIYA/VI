//
//  SearchTextField.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 21/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "SearchTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.clipsToBounds = YES;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
        self.layer.sublayerTransform = CATransform3DMakeTranslation(8.0f, 0.0f, 0.0f);
    }
    return self;
}

//- (CGRect) rightViewRectForBounds:(CGRect)bounds {
//    CGRect textRect = [super rightViewRectForBounds:bounds];
//    textRect.origin.x = 20;
//    return textRect;
//}

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds ,20, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds ,20, 0);
}

@end
