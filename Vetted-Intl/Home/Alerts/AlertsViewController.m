//
//  AlertsViewController.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 25/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AlertsViewController.h"
#import "WebClient.h"
#import "TKAlertCenter.h"
#import "Helper.h"
#import "User.h"
#import "Alert.h"
#import "AlertCell.h"
#import "AlertHeaderView.h"
#import "NSString+extras.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"
#import "SIAlertView.h"
#import "NSObject+Extras.h"
#import "Loader.h"

@interface AlertsViewController ()<AlertHeaderViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UILabel *lblCountryName;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;

@property (strong, nonatomic) NSMutableArray *arrCategory;
@property (nonatomic) NSInteger openSectionIndex;

@end

@implementation AlertsViewController

#pragma mark - View life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    [self addPanicView];
//    _lblCountryName.text = [_country.strCountryName uppercaseString];
     _lblCountryName.text = [_strCountryName uppercaseString];
    _arrCategory = [[NSMutableArray alloc]init];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getAlertsForCountry];
}

- (void)getAlertsForCountry{
    //_country.countryId
    
    
    self.openSectionIndex = NSNotFound;
    [[WebClient sharedClient] getAlertsFromBookmark:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"countryid":[NSNumber numberWithInteger:_countryId]} success:^(NSDictionary *dictionary) {
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                [[Loader defaultLoader] displayLoadingView:msgLoading];
                NSArray *data = dictionary[@"alerts"];
                if(data.count!=0){
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        Alert *alert = [Alert dataWithInfo:obj];
                        if(idx==0){
                            alert.open = YES;
                        }
                        [_arrCategory addObject:alert];
                        _openSectionIndex = 0;
                    }];
                }
                _lblNoRecordFound.hidden = _arrCategory.count!=0;
                [[Loader defaultLoader] hideLoadingView];
                [_tblList reloadData];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
    } failure:^(NSError *error) {
        _lblNoRecordFound.hidden = _arrCategory.count!=0;
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

#pragma mark - Button Click event

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnUnBookmarkTapped:(id)sender{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:msgDelete andMessage:msgUnfavouriteConfirmation];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"YES"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [self unBookmarkCountry];
                          }];
    [alertView addButtonWithTitle:@"NO"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

- (void)unBookmarkCountry{
    [[WebClient sharedClient] deleteBookmark:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"countryid":[NSNumber numberWithInteger:_countryId]} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if([dictionary[@"success"] boolValue] == YES){
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
        }
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AlertHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"AlertHeaderView"];
    if(!headerView){
        headerView = [[NSBundle mainBundle] loadNibNamed:@"AlertHeaderView" owner:self options:nil][0];
    }
    Alert *alert = _arrCategory[section];
    headerView.alert = alert;
    headerView.delegate = self;
    headerView.tag = section;
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrCategory.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Alert *alert = _arrCategory[section];
    return alert.open?1:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Alert *alert = _arrCategory[indexPath.section];
    
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.attributedText = alert.attributedDescString;
    gettingSizeLabel.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-16, 9999);
    CGSize expectedSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    return expectedSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AlertCell";
    AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[NSBundle mainBundle] loadNibNamed:@"AlertCell" owner:self options:nil][0];
    
    Alert *alert = _arrCategory[indexPath.section];
    cell.alert = alert;
    
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.attributedText = alert.attributedDescString;
    gettingSizeLabel.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-16, 9999);
    CGSize expectedSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    
    CGRect frame = cell.lblAlertText.frame;
    frame.size.height= expectedSize.height;
    cell.lblAlertText.frame = frame;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

#pragma mark - Alert Cell Delegate Method

- (void)alertHeaderView:(AlertHeaderView *)view sectionOpened:(NSInteger)section{
    view.separatorView.hidden = YES;
    Alert *alert = _arrCategory[section];
    alert.open = YES;
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    
    if (previousOpenSectionIndex != NSNotFound) {
        Alert *alert = _arrCategory[previousOpenSectionIndex];
        alert.open = NO;
        
        AlertHeaderView *headerView = (AlertHeaderView*)[_tblList headerViewForSection:previousOpenSectionIndex];
        [headerView toggleOpenWithUserAction:NO];
        if (alert.open) {
            [headerView.btnToggleIcon setImage:[UIImage imageNamed:@"green_arow_up"] forState:UIControlStateNormal];
        }else{
            [headerView.btnToggleIcon setImage:[UIImage imageNamed:@"down_arow"] forState:UIControlStateNormal];
        }

        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:0 inSection:previousOpenSectionIndex]];
    }
    
   [_tblList beginUpdates];
   [_tblList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
   [_tblList deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
   [_tblList endUpdates];
   [_tblList reloadData];
    
    self.openSectionIndex = section;
}



- (void)alertHeaderView:(AlertHeaderView *)view sectionClosed:(NSInteger)section{
    view.separatorView.hidden = NO;
    Alert *alert = _arrCategory[section];
    alert.open = NO;
    
    [_tblList beginUpdates];
    [_tblList deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
    [_tblList endUpdates];
    [_tblList reloadData];
    
    self.openSectionIndex = NSNotFound;
}

@end
