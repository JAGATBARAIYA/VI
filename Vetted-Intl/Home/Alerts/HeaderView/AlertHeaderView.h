//
//  AlertHeaderView.h
//  Vetted-Intl
//
//  Created by Manish on 17/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alert.h"

@class AlertHeaderView;

@protocol AlertHeaderViewDelegate <NSObject>
- (void)alertHeaderView:(AlertHeaderView*)view sectionOpened:(NSInteger)section;
- (void)alertHeaderView:(AlertHeaderView*)view sectionClosed:(NSInteger)section;
@end

@interface AlertHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblUpdatedDate;
@property (strong, nonatomic) IBOutlet UIView *viewColor;
@property (strong, nonatomic) IBOutlet UIButton *btnToggleIcon;
@property (strong, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) IBOutlet UIImageView *lblIcon;

@property (strong, nonatomic) Alert *alert;

@property (assign, nonatomic) id<AlertHeaderViewDelegate> delegate;

- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end
