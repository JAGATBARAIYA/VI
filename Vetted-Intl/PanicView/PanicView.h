//
//  PanicView.h
//  Vetted-Intl
//
//  Created by Manish on 12/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString  *PanicType;
#define PanicTypePolice         @"Police"
#define PanicTypeFire           @"Fire"
#define PanicTypeEMS            @"EMS"

@interface PanicView : UIView

@property (strong, nonatomic) IBOutlet UIView *callView;
@property (strong, nonatomic) IBOutlet UIButton *btnPanic;

@property (copy, nonatomic) PanicType panicType;

@end
