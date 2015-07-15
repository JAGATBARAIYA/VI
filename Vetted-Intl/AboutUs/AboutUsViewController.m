//
//  AboutUsViewController.m
//  Vetted-Intl
//
//  Created by Manish on 27/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AboutUsViewController.h"
#import "MFSideMenu.h"
#import "REFrostedViewController.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"
#import "TermConditionViewController.h"
#import "AppDelegate.h"
 
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPanicView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button tap events

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnTermConditionTapped:(id)sender{
    TermConditionViewController *termViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TermConditionViewController"];
    [self.navigationController pushViewController:termViewController animated:YES];
}

- (IBAction)btnMenuTapped:(id)sender{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

@end
