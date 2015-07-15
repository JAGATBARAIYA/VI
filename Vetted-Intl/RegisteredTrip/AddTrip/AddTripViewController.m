//
//  AddTripViewController.m
//  Vetted-Intl
//
//  Created by Manish on 07/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "AddTripViewController.h"
#import "WebClient.h"
#import "AddTripCell.h"
#import "Member.h"
#import "Helper.h"
#import "User.h"
#import "MSTextField.h"
#import "Common.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"
#import "AddMemberViewController.h"
#import "CountryListViewController.h"
#import "RegisteredTrip.h"
#import "Country.h"

@interface AddTripViewController () <AddTripDelegate,CountryListViewControllerDeleagate,AddMemberViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblList;

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblMemberID;
@property (strong, nonatomic) IBOutlet UILabel *lblAddRegisterTrip;
@property (strong, nonatomic) IBOutlet UILabel *lblUpdateRegisterTrip;
@property (strong, nonatomic) IBOutlet UILabel *lblPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) IBOutlet MSTextField *txtDestination;
@property (strong, nonatomic) IBOutlet MSTextField *txtCity;
@property (strong, nonatomic) IBOutlet MSTextField *txtFromDate;
@property (strong, nonatomic) IBOutlet MSTextField *txtToDate;

@property (strong, nonatomic) NSMutableArray *arrMembers;
@property (strong, nonatomic) NSMutableArray *arrCountries;

@end

@implementation AddTripViewController

#pragma mark - View Life Cycle
 
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    _arrMembers = [[NSMutableArray alloc]init];
    _arrCountries = [[NSMutableArray alloc]init];

    [self getMembersList];
    [self getAllCountryList];
}

- (void)viewWillAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    NSLog(@"%ld",(long)_registeredTrip.intTripID);
    [self addPanicView];
 
    if(_registeredTrip){
        _lblAddRegisterTrip.text = @"UPDATE REGISTERED TRIP";
        _txtDestination.text = _registeredTrip.strDestination;
        _txtCity.text = _registeredTrip.strCity;
        _txtFromDate.text = [_registeredTrip.strFromDate uppercaseString];
        _txtToDate.text = [_registeredTrip.strToDate uppercaseString];
    }else {
        _lblAddRegisterTrip.text = @"ADD REGISTERED TRIP";
        _txtFromDate.text = [[Helper getStringFromDate:[NSDate date] withFormat:kDateFormat] uppercaseString];
    }
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
//    [dateFormatter setDateFormat:kDateFormat];
    
    [_datePicker setDate:[NSDate date]];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
//    NSString *value = [dateFormatter stringFromDate:_datePicker.date];
//    _txtFromDate.text = [NSString stringWithFormat:@"%@",value];

    [self.view bringSubviewToFront:_pickerView];
   
    //_lblName.text = ([User sharedUser].strFirstName)?[User sharedUser].strFirstName:@"";
    //_lblMemberID.text = ([User sharedUser].strMembershipID)?[User sharedUser].strMembershipID:@"";
    
    if([User sharedUser].strFirstName!=nil){
        _lblName.text = [User sharedUser].strFirstName;
    }
    if([User sharedUser].strMembershipID!=nil){
        _lblMemberID.text = [User sharedUser].strMembershipID;
    }
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)getMembersList{
    [_arrMembers removeAllObjects];
    [[WebClient sharedClient] getMembers:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID]} success:^(NSDictionary *dictionary) {
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                NSArray *data = dictionary[@"members"];
                if(data.count!=0){
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        Member *member = [Member dataWithInfo:obj];
                        [_arrMembers addObject:member];
                    }];
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

- (void)getAllCountryList{
    [[WebClient sharedClient] allCountryList:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID]} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                NSArray *data = dictionary[@"countries"];
                if(data.count!=0){
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        _country = [Country dataWithInfo:obj];
                        [_arrCountries addObject:_country];
                    }];
                }
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

#pragma mark - Button Click event

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnDestinationTapped:(id)sender{
    [_txtCity resignFirstResponder];

    _txtDestination.selected = YES;
    _txtFromDate.selected = NO;
    _txtToDate.selected = NO;
    _datePicker.hidden = YES;
    _txtDestination.selected = YES;

    CountryListViewController *countryListViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"CountryListViewController"];
    countryListViewController.delegate = self;
    if(!countryListViewController.arrCountries)
        countryListViewController.arrCountries = _arrCountries;
    [self.navigationController pushViewController:countryListViewController animated:YES];
}

- (IBAction)btnFromTapped:(id)sender{
    _txtFromDate.selected = YES;
    _txtToDate.selected = NO;
    _txtDestination.selected = NO;
    [self showDatePickerView];
}

- (IBAction)btnToTapped:(id)sender{
    _txtFromDate.selected = NO;
    _txtDestination.selected = NO;
    _txtToDate.selected = YES;
    [self showDatePickerView];
}

- (IBAction)btnRightTapped:(id)sender{
    _pickerView.hidden = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (_datePicker.datePickerMode == UIDatePickerModeDate) {
        [dateFormatter setDateFormat:kDateFormat];
    }
    
    NSString *value = [dateFormatter stringFromDate:_datePicker.date];
    if (_txtFromDate.selected) {
        _txtFromDate.text = [value uppercaseString];
    }else if (_txtToDate.selected){
        if ([_txtFromDate.text isGreaterToDate:value]) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:msgDateDifference image:kErrorImage];
            return;
        }else{
            _txtToDate.text = [value uppercaseString];
        }
    }else if (_txtDestination.selected){
        _txtDestination.text = _country.strCountryName;
        _registeredTrip.intCountryID = [[NSString stringWithFormat:@"%ld",(long)_country.countryId]integerValue];
        NSLog(@"%ld",(long)_registeredTrip.intCountryID);
    }
}

- (IBAction)btnCloseTapped:(id)sender{
    _pickerView.hidden = YES;
}

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDoneTapped:(id)sender{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *strCountryId;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected = 1"];
    NSArray *selectedData = [_arrMembers filteredArrayUsingPredicate:predicate];

    if(selectedData.count!=0){
        [selectedData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Member *member = (Member*)obj;
            [data addObject:[NSNumber numberWithInteger:member.intMemberID]];
        }];
        strCountryId = [data componentsJoinedByString:@","];
    }else{
        strCountryId = @"";
    }
    if ([self validation]) {
        if(_registeredTrip){
            [[WebClient sharedClient] editTrip:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"tripid":[NSNumber numberWithInteger:_registeredTrip.intTripID],@"destination":[NSNumber numberWithInteger:_registeredTrip.intCountryID],@"city":_txtCity.text,@"fromdate":_txtFromDate.text,@"todate":_txtToDate.text,@"members":strCountryId} success:^(NSDictionary *dictionary) {
                if([dictionary[@"success"] boolValue] == YES){
                   // [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                }else {
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
            }];
        }else {
            [[WebClient sharedClient] registeredTrip:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"destination":[NSNumber numberWithInteger:_country.countryId],@"city":_txtCity.text,@"fromdate":_txtFromDate.text,@"todate":_txtToDate.text,@"members":strCountryId} success:^(NSDictionary *dictionary) {
                if([dictionary[@"success"] boolValue] == YES){
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kRightImage];
                }else {
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
            }];
        }
    }
}

- (IBAction)btnAddTapped:(id)sender{
    AddMemberViewController *addMemberViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"AddMemberViewController"];
    addMemberViewController.delegate = self;
    [self.navigationController pushViewController:addMemberViewController animated:YES];
}

- (void)showDatePickerView{
    [_txtCity resignFirstResponder];
    
    _pickerView.hidden = NO;
    _datePicker.hidden = NO;
    _lblPicker.text = @"SELECT DATE";
    [self.view bringSubviewToFront:_datePicker];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:kDateFormat];
    [_datePicker setDate:[NSDate date]];
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrMembers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AddTripCell";
    AddTripCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddTripCell" owner:self options:nil] objectAtIndex:0];
    
    Member *member = _arrMembers[indexPath.row];
    cell.delegate = self;
    
    if(_registeredTrip){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"intMemberID == %d", member.intMemberID];
        NSArray *filteredArray = [_registeredTrip.arrMembers filteredArrayUsingPredicate:predicate];
        member.isSelected = cell.btnCheck.selected = filteredArray.count!=0;
    }
    cell.member = member;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _pickerView.hidden = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)resignFields{
    [_txtDestination resignFirstResponder];
}

- (BOOL)validation{
    if([_txtDestination.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgDestinationEmpty image:kErrorImage];
        return NO;
    }else if ([_txtCity.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgCityEmpty image:kErrorImage];
        return NO;
    }else if ([_txtFromDate.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgFromDateEmpty image:kErrorImage];
        return NO;
    }else if ([_txtToDate.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgToDateEmpty image:kErrorImage];
        return NO;
    }else if ([_txtFromDate.text isGreaterToDate:_txtToDate.text]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgDateDifference image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma mark - Delegate Method

- (void)selectMember:(AddTripCell *)cell member:(Member *)member{
    member.isSelected=!member.isSelected;
    cell.btnCheck.selected = member.isSelected;
}

- (void)countryListViewController:(CountryListViewController *)controller country:(Country *)country{
    _country = country;
    _txtDestination.text = country.strCountryName;
    _registeredTrip.intCountryID = [[NSString stringWithFormat:@"%ld",(long)country.countryId]integerValue];
}

- (void)addMemberViewController:(AddMemberViewController *)controller{
    [self getMembersList];
}

@end
