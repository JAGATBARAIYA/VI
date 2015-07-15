//
//  CategoryHeaderView.h
//  Vetted-Intl
//
//  Created by Manish on 20/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalInfo.h"

@class CategoryHeaderView;

@protocol CategoryHeaderViewDelegate <NSObject>
- (void)categoryHeaderView:(CategoryHeaderView*)view sectionOpened:(NSInteger)section;
- (void)categoryHeaderView:(CategoryHeaderView*)view sectionClosed:(NSInteger)section;
@end

@interface CategoryHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnToggleIcon;

@property (strong, nonatomic) GlobalInfo *globalInfo;
@property (assign, nonatomic) id<CategoryHeaderViewDelegate> delegate;

- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end
