//
//  CategoryViewController.m
//  Vetted-Intl
//
//  Created by Manish on 26/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "CategoryViewController.h"
#import "BNEasyGoogleAnalyticsTracker.h"
#import "CategoryCell.h"
#import "WebClient.h"
#import "Helper.h"
#import "GlobalInfo.h"
#import "NSString+extras.h"
#import "CategoryHeaderView.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"

@interface CategoryViewController ()<CategoryHeaderViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UILabel *lblCountryName;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;

@property (strong, nonatomic) NSMutableArray *arrCategory;
@property (nonatomic) NSInteger openSectionIndex;

@end

@implementation CategoryViewController

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
    _arrCategory = [[NSMutableArray alloc] init];
    _lblCountryName.text = [_country.strCountryName uppercaseString];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getGlobalInfoCountryList];
}

- (void)getGlobalInfoCountryList{
    self.openSectionIndex = NSNotFound;
    [_arrCategory removeAllObjects];
    [[WebClient sharedClient] getCategoryList:@{@"countryid":[NSNumber numberWithInteger:_country.countryId]} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if(dictionary!=nil){
            if([dictionary[@"success"] boolValue] == YES){
                NSArray *data = dictionary[@"globalinfo"];
                if(data.count!=0){
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        GlobalInfo *globalInfo = [GlobalInfo dataWithInfo:obj];
                        if(idx==0){
                            globalInfo.open = YES;
                        }
                        [_arrCategory addObject:globalInfo];
                        _openSectionIndex = 0;
                    }];
                }
                [_tblList reloadData];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
        _lblNoRecordFound.hidden = _arrCategory.count!=0;
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
        _lblNoRecordFound.hidden = _arrCategory.count!=0;
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
    CategoryHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CategoryHeaderView"];
    if(!headerView){
        headerView = [[NSBundle mainBundle] loadNibNamed:@"CategoryHeaderView" owner:self options:nil][0];
    }
    GlobalInfo *globalInfo = _arrCategory[section];
    headerView.globalInfo = globalInfo;
    headerView.btnToggleIcon.selected = globalInfo.open;
    headerView.delegate = self;
    headerView.tag = section;
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrCategory.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GlobalInfo *globalInfo = _arrCategory[indexPath.section];
    
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.attributedText = globalInfo.attributedString;
    gettingSizeLabel.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-16, 9999);
    CGSize expectedSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    
    return expectedSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GlobalInfo *globalInfo = _arrCategory[section];
    return globalInfo.open?1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil][0];
    
    GlobalInfo *globalInfo = _arrCategory[indexPath.section];
    cell.globalInfo = globalInfo;
    
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.attributedText = globalInfo.attributedString;
    gettingSizeLabel.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-16, 9999);
    CGSize expectedSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    
    CGRect frame = cell.lblDescription.frame;
    frame.size.height= expectedSize.height;
    cell.lblDescription.frame = frame;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

#pragma mark - Alert Cell Delegate Method

- (void)categoryHeaderView:(CategoryHeaderView *)view sectionOpened:(NSInteger)section{
    GlobalInfo *globalInfo = _arrCategory[section];
    globalInfo.open = YES;
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    
    if (previousOpenSectionIndex != NSNotFound) {
        GlobalInfo *globalInfo = _arrCategory[previousOpenSectionIndex];
        globalInfo.open = NO;
        
        CategoryHeaderView *headerView = (CategoryHeaderView*)[_tblList headerViewForSection:previousOpenSectionIndex];
        [headerView toggleOpenWithUserAction:NO];
        if (globalInfo.open) {
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

- (void)categoryHeaderView:(CategoryHeaderView *)view sectionClosed:(NSInteger)section{
    GlobalInfo *globalInfo = _arrCategory[section];
    globalInfo.open = NO;
    
    [_tblList beginUpdates];
    [_tblList deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
    [_tblList endUpdates];
    [_tblList reloadData];
    
    self.openSectionIndex = NSNotFound;
}

#pragma mark - Button Click events

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
