//
//  PanicButton.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 21/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "PanicButton.h"
#import "PanicView.h"

@implementation PanicButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnPanicTapped:(id)sender{
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    PanicView *panicView = [[NSBundle mainBundle] loadNibNamed:@"PanicView" owner:nil options:nil][0];
    panicView.alpha = 0.0;
    panicView.frame = mainWindow.bounds;
    [mainWindow addSubview:panicView];
    [UIView animateWithDuration:0.3 animations:^{
        panicView.alpha = 1.0;
    }];
}

@end
