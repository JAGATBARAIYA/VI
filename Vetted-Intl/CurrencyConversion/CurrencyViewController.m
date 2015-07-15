//
//  CurrencyViewController.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 21/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "CurrencyViewController.h"
#import "MFSideMenu.h"
#import "SQLiteManager.h"
#import "Currency.h"
#import "CurrencyConvertedCell.h"
#import "BNEasyGoogleAnalyticsTracker.h"
#import "MSTextField.h"
#import "TKAlertCenter.h"
#import "Common.h"
#import "REFrostedViewController.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"
#import "NSString+extras.h"

@interface CurrencyViewController ()

@property (strong, nonatomic) IBOutlet MSTextField *txtField;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentCurrency;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentCurrencySymbol;
@property (strong, nonatomic) IBOutlet UILabel *lblNoDataFound;
@property (strong, nonatomic) IBOutlet UITableView *tblList;

@property (strong, nonatomic) NSMutableArray *arrSelectedCurrency;
@property (strong, nonatomic) Currency *currentCurrency;

@end

@implementation CurrencyViewController

#pragma mark - View life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPanicView];
    _arrSelectedCurrency = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[[BNEasyGoogleAnalyticsTracker sharedTracker] trackScreenNamed:msgCurrenceyConveter];

    [_arrSelectedCurrency removeAllObjects];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSString *sql = @"SELECT * FROM Currency WHERE fromCode = 1";
    NSArray *data = [[SQLiteManager singleton] executeSql:sql];
    
    NSDictionary *dict = [data lastObject];
    _currentCurrency = [Currency dataWithInfo:dict];
    
    if(_currentCurrency){
        _lblCurrentCurrency.text = [_currentCurrency.strCode stringByAppendingFormat:@" - %@",_currentCurrency.strName];
        _lblCurrentCurrencySymbol.text = _currentCurrency.strSymbol;
    }
    
    NSString *sql2 = @"SELECT * FROM Currency WHERE toCode = 1";
    NSArray *data2 = [[SQLiteManager singleton] executeSql:sql2];
    
    [data2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_arrSelectedCurrency addObject:[Currency dataWithInfo:obj]];
    }];
    
    _lblNoDataFound.hidden = _arrSelectedCurrency.count!=0;
    [self currencyConversion];
}

- (void)currencyConversion{
    if(_arrSelectedCurrency.count!=0){
        NSString *firstString = @"https://query.yahooapis.com/v1/public/yql?q=";
        NSString *lastString = @"&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";
        
        __block NSString *appendString = @"select * from yahoo.finance.xchange where pair in (";
        [_arrSelectedCurrency enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Currency *cur = (Currency*)obj;
            appendString = [appendString stringByAppendingString:[NSString stringWithFormat:@"\"%@%@\",",_currentCurrency.strCode,cur.strCode]];
        }];
        
        appendString = [appendString substringToIndex:appendString.length-1];
        appendString = [appendString stringByAppendingString:@")"];
        NSString *encodedString = [appendString urlencode];
        
        firstString = [firstString stringByAppendingString:encodedString];
        firstString = [firstString stringByAppendingString:lastString];
        
        [[WebClient sharedClient] currencyConversion:firstString success:^(NSDictionary *dictionary) {
            if(dictionary){
                if(dictionary[@"query"]!=[NSNull null]){
                    if(dictionary[@"query"][@"results"]!=[NSNull null]){
                        id data = dictionary[@"query"][@"results"][@"rate"];
                        if([data isKindOfClass:[NSArray class]]){
                            NSArray *array = (NSArray*)data;
                            if(array.count!=0){
                                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    NSDictionary *dict = (NSDictionary*)obj;
                                    [self changeToValueInSelectedCurrency:dict];
                                }];
                            }
                        }else {
                            NSDictionary *dict = (NSDictionary*)data;
                            [self changeToValueInSelectedCurrency:dict];
                        }
                    }
                }
            }
            [_tblList reloadData];
        } failure:^(NSError *error) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:error.localizedDescription image:kErrorImage];
        }];
    }
}

- (void)changeToValueInSelectedCurrency:(NSDictionary*)dict{
    NSString *name = dict[@"Name"];
    NSArray *array = [name componentsSeparatedByString:@"/"];
    NSString *code = [array[1] trimWhiteSpace];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strCode=%@",code];
    NSArray *currencies = [_arrSelectedCurrency filteredArrayUsingPredicate:predicate];
    Currency *currency = [currencies lastObject];
    currency.toValue = [dict[@"Rate"] doubleValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrSelectedCurrency.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CurrencyConvertedCell";
    CurrencyConvertedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CurrencyConvertedCell" owner:self options:nil] objectAtIndex:0];
    
    Currency *currency = _arrSelectedCurrency[indexPath.row];
    cell.lblCurrency.text = [currency.strCode stringByAppendingFormat:@" - %@",currency.strName];
    cell.lblValue.text = [_txtField.text stringByAppendingFormat:@" %@ ",_currentCurrency.strCode] ;
    cell.lblValue1.text = [NSString stringWithFormat:@"%.4f %@",[_txtField.text floatValue]*currency.toValue, currency.strCode];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

#pragma mark - UITextField Delegate methods

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    return YES;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isNumeric]){
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_tblList reloadData];
    return YES;
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
