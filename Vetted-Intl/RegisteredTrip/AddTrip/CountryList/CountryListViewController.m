//
//  CountryListViewController.m
//  Vetted-Intl
//
//  Created by Manish on 23/04/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "CountryListViewController.h"
#import "CountryCell.h"
#import "Country.h"
#import "AppDelegate.h"

@interface CountryListViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

@property (strong, nonatomic) NSMutableArray *filteredCountries;

@property(assign, nonatomic) BOOL isTextfieldLoded;

@end

@implementation CountryListViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    NSLog(@"%@",_arrCountries);
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isTextfieldLoded == YES)
        return _filteredCountries.count;
    
    return _arrCountries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CountryCell";
    CountryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CountryCell" owner:self options:nil] objectAtIndex:0];
    
    Country *country = [self getCoutry:indexPath.row];
    cell.country = country;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Country *country = [self getCoutry:indexPath.row];
    
    if([_delegate respondsToSelector:@selector(countryListViewController:country:)]){
        [_delegate countryListViewController:self country:country];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (Country*)getCoutry:(NSInteger)index{
    Country *country = nil;
    if (_isTextfieldLoded == YES) {
        country = _filteredCountries[index];
    }else {
        country = _arrCountries[index];
    }
    return country;
}

#pragma mark - Button Click Event

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
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
