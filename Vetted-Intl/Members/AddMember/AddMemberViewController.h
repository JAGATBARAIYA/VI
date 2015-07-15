//
//  AddMemberViewController.h
//  Vetted-Intl
//
//  Created by Manish on 12/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"

@class AddMemberViewController;

@protocol AddMemberViewControllerDelegate <NSObject>
- (void)addMemberViewController:(AddMemberViewController *)controller;
- (void)getMembersList;
@end

@interface AddMemberViewController : UIViewController

@property (strong, nonatomic) Member *member;

@property (assign, nonatomic) id<AddMemberViewControllerDelegate> delegate;

@end
