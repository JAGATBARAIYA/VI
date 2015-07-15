//
//  AllCountryViewController.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 25/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AllCountryViewController.h"
#import "WebClient.h"
#import "Helper.h"
#import "Common.h"
#import "TKAlertCenter.h"
#import "AllCountryCell.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"
#import "Country.h"
#import "User.h"

@interface AllCountryViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblList;

@property (strong, nonatomic) NSMutableArray *arrCountries;
@property (strong, nonatomic) NSMutableArray *filteredCountries;

@property(strong, nonatomic) IBOutlet UITextField *txtSearch;

@property(assign, nonatomic) BOOL isTextfieldLoded;

@end

@implementation AllCountryViewController

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
    _arrCountries = [[NSMutableArray alloc] init];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getAllCountryList];
}

- (void)getAllCountryList{
    [[WebClient sharedClient] allCountryList:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID]} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                NSArray *data = dictionary[@"countries"];
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
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

#pragma mark - Button tap events

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnDoneTapped:(id)sender {
    NSMutableArray *data = [[NSMutableArray alloc] init];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected = 1"];
    NSArray *selectedData = [_arrCountries filteredArrayUsingPredicate:predicate];
    
    if(selectedData.count!=0){
        [selectedData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Country *country = (Country*)obj;
            [data addObject:[NSNumber numberWithInteger:country.countryId]];
        }];
        NSString *strCountryId = [data componentsJoinedByString:@","];
        NSDictionary *dict = @{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"countryid":strCountryId};
        [[WebClient sharedClient] addBookmark:dict success:^(NSDictionary *dictionary) {
            if(dictionary){
                if([dictionary[@"success"] boolValue]==1){
                    [User sharedUser].bookmarkCount = [dictionary[@"bookmark_country_count"] integerValue];
                    [Helper addCustomObjectToUserDefaults:[User sharedUser] key:msgUserInfo];
                    //[[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:error.localizedDescription image:kErrorImage];
        }];
    }else{
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgSelectCountries image:kErrorImage];
    }
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
    static NSString *CellIdentifier = @"AllCountryCell";
    AllCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AllCountryCell" owner:self options:nil] objectAtIndex:0];
    
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

@end
