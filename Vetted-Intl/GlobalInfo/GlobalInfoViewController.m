//
//  GlobalInfoViewController.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 25/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "GlobalInfoViewController.h"
#import "GlobalInfoCountryCell.h"
#import "CategoryViewController.h"
#import "BNEasyGoogleAnalyticsTracker.h"
#import "MFSideMenu.h"
#import "Helper.h"
#import "WebClient.h"
#import "Country.h"
#import "User.h"
#import "REFrostedViewController.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"

@interface GlobalInfoViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property(strong, nonatomic) IBOutlet UITextField *txtSearch;
@property(strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;

@property (strong, nonatomic) NSMutableArray *arrCountries;
@property (strong, nonatomic) NSMutableArray *filteredCountries;


@property(assign, nonatomic) BOOL isTextfieldLoded;

@end

@implementation GlobalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[[BNEasyGoogleAnalyticsTracker sharedTracker] trackScreenNamed:msgGlobalInformation];
    [self getGlobalInfoCountryList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    [self addPanicView];
    _arrCountries = [[NSMutableArray alloc] init];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)getGlobalInfoCountryList{
    [_arrCountries removeAllObjects];
    [[WebClient sharedClient] globalInfoList:nil success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                NSArray *data = dictionary[@"globalinfocountries"];
                if(data.count!=0){
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        Country *country = [Country dataWithInfo:obj];
                        [_arrCountries addObject:country];
                    }];
                    _filteredCountries = _arrCountries;
                }
                [_tblList reloadData];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
        _lblNoRecordFound.hidden = _arrCountries.count!=0;
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
        _lblNoRecordFound.hidden = _arrCountries.count!=0;
    }];
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isTextfieldLoded == YES)
        return _filteredCountries.count;

    return _arrCountries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"GlobalInfoCountryCell";
    GlobalInfoCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GlobalInfoCountryCell" owner:self options:nil] objectAtIndex:0];
    
    Country *country = nil;
    if (_isTextfieldLoded == YES) {
        country = _filteredCountries[indexPath.row];
    }else {
        country = _arrCountries[indexPath.row];
    }
    cell.country = country;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Country *country = nil;
    if (_isTextfieldLoded == YES) {
        country = _filteredCountries[indexPath.row];
    }else {
        country = _arrCountries[indexPath.row];
    }
    CategoryViewController *categoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    categoryViewController.country = country;
    [self.navigationController pushViewController:categoryViewController animated:YES];
}

#pragma mark - TextField Delegate Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"strCountryName contains[cd] %@", textField.text];
    _filteredCountries = [NSMutableArray arrayWithArray:[_arrCountries filteredArrayUsingPredicate:resultPredicate]];
    if (self.txtSearch.text.length!=0) {
        self.isTextfieldLoded=YES;
    }
    else{
        self.isTextfieldLoded=NO;
    }
    [_tblList reloadData];
    return NO;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _txtSearch.text = @"";
    [_txtSearch resignFirstResponder];
    self.isTextfieldLoded=NO;
    [_tblList reloadData];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_txtSearch becomeFirstResponder];
}

#pragma mark - Button tap events

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnMenuTapped:(id)sender{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

@end
