//
//  CurrencyListViewController.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 21/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "CurrencyListViewController.h"
#import "SQLiteManager.h"
#import "Currency.h"
#import "CurrencyListCell.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"
#import "Helper.h"
#import "AppDelegate.h"

@interface CurrencyListViewController () <CurrencyListCellDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@property (strong, nonatomic) NSMutableArray *arrCurrency;
@property (strong, nonatomic) NSMutableArray *arrFilteredCurrency;

@property(assign, nonatomic) BOOL isTextfieldLoded;

@end

@implementation CurrencyListViewController

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
    _arrCurrency = [[NSMutableArray alloc] init];
    
    NSString *sql = @"SELECT * FROM Currency";
    NSArray *data = [[SQLiteManager singleton] executeSql:sql];
    
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_arrCurrency addObject:[Currency dataWithInfo:obj]];
    }];
    
    _arrFilteredCurrency = _arrCurrency;
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5;
    lpgr.delegate = self;
    [_tblList addGestureRecognizer:lpgr];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap.numberOfTapsRequired = 2;
    tap.delegate = self;
    [_tblList addGestureRecognizer:tap];

    BOOL isInfo = [Helper getBoolFromUserDefaults:@"IsInfoDone"];
    if(!isInfo){
        _infoView.alpha = 0.0;
        [self.view addSubview:_infoView];
        _infoView.frame = self.view.bounds;
        [UIView animateWithDuration:0.3 animations:^{
            _infoView.alpha = 1.0;
        }];
    }
}

#pragma mark - Button tap events

- (IBAction)btnInfoDoneTapped:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _infoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_infoView removeFromSuperview];
    }];
    [Helper addBoolToUserDefaults:YES forKey:@"IsInfoDone"];
}

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnDoneTapped:(id)sender {
    
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isTextfieldLoded == YES)
        return _arrFilteredCurrency.count;
    
    return _arrCurrency.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CurrencyListCell";
    CurrencyListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CurrencyListCell" owner:self options:nil] objectAtIndex:0];
    
    Currency *currency = nil;
    if (_isTextfieldLoded == YES) {
        currency = _arrFilteredCurrency[indexPath.row];
    }else {
        currency = _arrCurrency[indexPath.row];
    }
    cell.currency = currency;
    cell.delegate = self;
    if (currency.isFromCode) {
        cell.backgroundColor = [UIColor colorWithRed:9/255.0 green:130.0/255.0 blue:242.0/255.0 alpha:1.0];
        cell.lblCurrency.textColor = cell.lblCurrencyCode.textColor = [UIColor whiteColor];
        cell.btnTo.hidden = YES;
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        cell.lblCurrency.textColor = cell.lblCurrencyCode.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

#pragma mark - Long Press Gesture

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:_tblList];
    NSIndexPath *indexPath = [_tblList indexPathForRowAtPoint:p];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self selectBaseCurrency:indexPath];
    }
}

-(void)doubleTap:(UITapGestureRecognizer *)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:_tblList];
    NSIndexPath *indexPath = [_tblList indexPathForRowAtPoint:p];
    [self selectBaseCurrency:indexPath];
}

- (void)selectBaseCurrency:(NSIndexPath*)indexPath{
    Currency *currency = nil;
    if (_isTextfieldLoded == YES) {
        currency = _arrFilteredCurrency[indexPath.row];
    }else {
        currency = _arrCurrency[indexPath.row];
    }
    [_arrCurrency enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Currency *currency = (Currency*)obj;
        currency.isFromCode = NO;
        
        CurrencyListCell *cell = (CurrencyListCell*)[_tblList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        cell.btnFrom.selected = NO;
    }];
    
    currency.isFromCode = YES;
    
    NSString *sql = @"UPDATE Currency SET fromCode = 0";
    [[SQLiteManager singleton] executeSql:sql];
    
    NSString *sql2 = [NSString stringWithFormat:@"UPDATE Currency SET fromCode = %d WHERE Id=%ld", currency.isFromCode,(long)currency.Id];
    [[SQLiteManager singleton] executeSql:sql2];
    
    currency.isFromCode = YES;
    currency.isToCode = NO;
    
    [_tblList reloadData];
}

#pragma mark - TextField Delegate Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"strName contains[cd] %@", textField.text];
    _arrFilteredCurrency = [NSMutableArray arrayWithArray:[_arrCurrency filteredArrayUsingPredicate:resultPredicate]];
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

#pragma mark - Currency Cell delegate methods

- (void)selectToCurrency:(CurrencyListCell*)cell currency:(Currency*)currency{
    currency.isToCode=!currency.isToCode;
    cell.btnTo.selected = currency.isToCode;
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE Currency SET toCode = %d WHERE Id=%ld", currency.isToCode,(long)currency.Id];
    [[SQLiteManager singleton] executeSql:sql];
}

@end
