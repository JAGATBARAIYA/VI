//
//  MenuViewController.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 20/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "Helper.h"
#import "User.h"
//#import "MFSideMenu.h"
#import "ViewController.h"
#import "HomeAlertsViewController.h"
#import "CurrencyViewController.h"
#import "GlobalInfoViewController.h"
#import "MyDocumentsViewController.h"
#import "RegisteredTripViewController.h"
#import "MembersViewController.h"
#import "ProfileViewController.h"
#import "AboutUsViewController.h"
#import "DEMONavigationController.h"
#import "WebClient.h"

@interface MenuViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UISwitch *switchPushNotification;

@property (strong, nonatomic) NSArray *arrMenuItems;

@end

@implementation MenuViewController

#pragma mark - View life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    _lblUserName.text = [[User sharedUser].strFirstName uppercaseString];
    _switchPushNotification.on = [User sharedUser].isPushNotification;
    [_tblList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _arrMenuItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"]];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_switchPushNotification addTarget:self action:@selector(setNotification:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _tblList.bounds.size.height/_arrMenuItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrMenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil] objectAtIndex:0];
    
    NSDictionary *dict = _arrMenuItems[indexPath.row];
    if (indexPath.row == 5) {
        cell.lblMenuName.frame = CGRectMake(73, cell.lblMenuName.frame.origin.y, cell.lblMenuName.frame.size.width, cell.frame.size.height);
        
        cell.imgMenu.frame = CGRectMake(35, cell.imgMenu.frame.origin.y, cell.imgMenu.frame.size.width, cell.imgMenu.frame.size.height);
    }
    cell.lblMenuName.text = dict[@"name"];
    cell.imgMenu.image = [UIImage imageNamed:dict[@"ImgName"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    //    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    switch (indexPath.row) {
        case 0:
        {
            HomeAlertsViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeAlertsViewController"];
            navigationController.viewControllers = @[homeViewController];
            
        }
            break;
        case 1:
        {
            CurrencyViewController *currencyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrencyViewController"];
            navigationController.viewControllers = @[currencyViewController];
        }
            break;
        case 2:
        {
            GlobalInfoViewController *globalInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GlobalInfoViewController"];
            navigationController.viewControllers = @[globalInfoViewController];
        }
            break;
        case 3:
        {
            MyDocumentsViewController *myDocumentsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyDocumentsViewController"];
            navigationController.viewControllers = @[myDocumentsViewController];
        }
            break;
        case 4:
        {
            RegisteredTripViewController *registeredTripViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisteredTripViewController"];
            navigationController.viewControllers = @[registeredTripViewController];
        }
            break;
        case 5:
        {
            MembersViewController *membersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MembersViewController"];
            navigationController.viewControllers = @[membersViewController];
        }
            break;
        case 6:
        {
            ProfileViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            navigationController.viewControllers = @[profileViewController];
        }
            break;
        case 7:
        {
            AboutUsViewController *aboutUsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
            navigationController.viewControllers = @[aboutUsViewController];
        }
            break;
        case 8:
        {
            [User sharedUser].login = NO;
            [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
            //            ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
            //            navigationController.viewControllers = @[viewController];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [_tblList reloadData];
        }
            break;
            
        default:
            break;
    }
    //if(indexPath.row!=_arrMenuItems.count - 1){
    //    navigationController.viewControllers = controllers;
    //    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    
    //}
}

#pragma mark - Set Push Notification

- (void)setNotification:(id)sender{
    BOOL state = [_switchPushNotification isOn];
    NSString *status = state == YES ? @"1" : @"0";
    [[WebClient sharedClient]setNotification:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"status":status} success:^(NSDictionary *dictionary) {
        if ([dictionary[@"success"] boolValue] == YES) {
            //[[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
            [User sharedUser].pushNotification = state;
            [Helper addCustomObjectToUserDefaults:[User sharedUser] key:kUserInformation];
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
        }
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

@end
