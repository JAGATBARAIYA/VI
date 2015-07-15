//
//  TermConditionViewController.m
//  Vetted-Intl
//
//  Created by Manish on 04/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "TermConditionViewController.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"
#import "AppDelegate.h"
#import "Loader.h"
#import "Common.h"

@interface TermConditionViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermConditionViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [self addPanicView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)commonInit{
    NSString *urlString = @"https://travelassistnow.com/docs/Travel%20Terms%20and%20Conditions.pdf";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

#pragma mark - Button tap events

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
