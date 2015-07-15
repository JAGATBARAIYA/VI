//
//  HomeAlertsViewController.m
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 21/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "HomeAlertsViewController.h"
#import "MFSideMenu.h"
#import "WebClient.h"
#import "Helper.h"
#import "Common.h"
#import "TKAlertCenter.h"
#import "BookmarkCell.h"
#import "Country.h"
#import "User.h"
#import "AllCountryViewController.h"
#import "BNEasyGoogleAnalyticsTracker.h"
#import "AlertsViewController.h"
#import "INTULocationManager.h"
#import "SVGeocoder.h"
#import "Loader.h"
#import "SIAlertView.h"
#import "REFrostedViewController.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"
#import "SQLiteManager.h"
#import "notifiedCopuntry.h"

@interface HomeAlertsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;

@property (strong, nonatomic) NSMutableArray *arrCountries;
@property (strong, nonatomic) NSMutableArray *filteredCountries;
@property (assign, nonatomic) NSInteger intAlertIndex;
@property (assign, nonatomic) BOOL isTextfieldLoded;
@property (assign, nonatomic) INTULocationRequestID locationRequestID;
@property (strong, nonatomic) NSMutableArray *arrayCountryNotification;
@property (strong, nonatomic) NSMutableArray *tempCountryNotification;

@end

@implementation HomeAlertsViewController

#pragma mark - View life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    _tblList.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self getBookmarkCountryList];
    
}


-(void)updater {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self getCountryNotification];
}

-(void)reloadTableView {
    [_tblList reloadData];
}

-(void)getCountryNotification{
    [_arrayCountryNotification removeAllObjects];
    [_tempCountryNotification removeAllObjects];
    
    NSArray *tmpArray = [[NSArray alloc]init];
    tmpArray = [[SQLiteManager singleton] findAllFrom:kNotificationtableName];
    
    if(tmpArray.count!=0){
        [tmpArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            notifiedCopuntry *country = [notifiedCopuntry dataWithInfo:obj];
            [_arrayCountryNotification addObject:country];
        }];
    }
    _tempCountryNotification = _arrayCountryNotification;
    [_tblList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    
    _arrayCountryNotification = [[NSMutableArray alloc]init];
    _tempCountryNotification = [[NSMutableArray alloc]init];
    
    
    [self addPanicView];
    _arrCountries = [[NSMutableArray alloc] init];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tblList.tableFooterView.tintColor = [UIColor clearColor];
    [self fetchCurrentLocation:NO];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAlert) name:@"NotificationBadgeObserver" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"reloadtableview" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCountryNotification) name:@"getListOfNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigatetoAlertViewcontroller) name:@"navigatetoAlertViewcontroller" object:nil];
    
    
    [self addNotidicationBadgeObserver];
}

-(void)updateAlert{
    
    NSLog(@"msg in country");
    NSLog(@"datainfo:%@",[User sharedUser].dictNotificatioInfo);
//    NSDictionary *receivedData = [User sharedUser].dictNotificatioInfo;

    
//    for (int i=0; i< [User sharedUser].arryNotificatioInfo.count; i++) {
//        _intAlertIndex = [[User sharedUser].arryNotificatioInfo[i] integerValue];
//
//    }
    
     //   NSInteger oneValue = [[[User sharedUser].dictNotificatioInfo valueForKey:@"countryid"] integerValue];
     //  _intAlertIndex = oneValue;

  //  [_tblList reloadData];
    
}

-(void)navigatetoAlertViewcontroller {
    
 NSDictionary *receivedData = [User sharedUser].dictNotificatioInfo;

    NSInteger countryid = [receivedData[@"countryid"] integerValue];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"countryId=%d",countryid];
    NSArray *filtered = [_arrCountries filteredArrayUsingPredicate:predicate];
    
//    if (filtered.count > 0) {
//        Country *country = [filtered firstObject];
//        AlertsViewController *alertsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"AlertsViewController"];
//        alertsViewController.country = country;
//        [self.navigationController pushViewController:alertsViewController animated:YES];
//    }else {
    
//        Country *country2;
//        country2.strCountryName =receivedData[@"countryname"];
//        country2.countryId =[receivedData[@"countryid"] integerValue];

        
        
        
        AlertsViewController *alertsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"AlertsViewController"];
       // alertsViewController.country = country2;
        
        alertsViewController.countryId = [receivedData[@"countryid"] integerValue];
        alertsViewController.strCountryName = receivedData[@"countryname"];
        
        [self.navigationController pushViewController:alertsViewController animated:YES];
//  }
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"countryId=%d",countryid];
    NSArray *filtered2 = [_tempCountryNotification filteredArrayUsingPredicate:predicate2];
    
    notifiedCopuntry *nono = [filtered2 firstObject];
    [[SQLiteManager singleton] deleteRowWithId:nono.Id from:kNotificationtableName];
    
}

//-(void)bookmarkCountryFromUnbookmarkData:(NSInteger)countryId {
// 
//    [_arrCountries removeAllObjects];
//    [[WebClient sharedClient] bookmarkCountryList:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID]} success:^(NSDictionary *dictionary) {
//        if (dictionary!=nil) {
//            if([dictionary[@"success"] boolValue] == YES){
//                NSArray *data = dictionary[@"countries"];
//                if(data.count!=0){
//                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                        Country *country = [Country dataWithInfo:obj];
//                        [_arrCountries addObject:country];
//                    }];
//                    _filteredCountries = _arrCountries;
//                    [self performSelector:@selector(getCountryNotification) withObject:nil afterDelay:1.0];
//                    
//                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"countryId=%d",countryId];
//                    NSArray *filtered = [_arrCountries filteredArrayUsingPredicate:predicate];
//                    
//                    Country *country = [filtered firstObject];
//                    AlertsViewController *alertsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"AlertsViewController"];
//                    alertsViewController.country = country;
//                    [self.navigationController pushViewController:alertsViewController animated:YES];
//                    
// }
//            }else {
//                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
//            }
//        }
//        _lblNoRecordFound.hidden = _arrCountries.count!=0;
//        if(_arrCountries.count==0){
//            BOOL firstTime = [Helper getBoolFromUserDefaults:@"BookmarkCountryList"];
//            if(firstTime){
//                return;
//            }
//            [self btnCurrentLocationTapped:nil];
//        }
//    } failure:^(NSError *error) {
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
//    }];
//    
//}

- (void)getBookmarkCountryList{
    
    [[WebClient sharedClient] bookmarkCountryList:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID]} success:^(NSDictionary *dictionary) {
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                NSArray *data = dictionary[@"countries"];
                if(data.count!=0){
                    
                    [_arrCountries removeAllObjects];
                    
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        Country *country = [Country dataWithInfo:obj];
                        [_arrCountries addObject:country];
                    }];
                    _filteredCountries = _arrCountries;
                    [self performSelector:@selector(getCountryNotification) withObject:nil afterDelay:1.0];
                }
                [_tblList reloadData];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
        _lblNoRecordFound.hidden = _arrCountries.count!=0;
        if(_arrCountries.count==0){
            BOOL firstTime = [Helper getBoolFromUserDefaults:@"BookmarkCountryList"];
            if(firstTime){
                return;
            }
            [self btnCurrentLocationTapped:nil];
        }
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

- (void)fetchCurrentLocation:(BOOL)isSaveLocation{
    [[Loader defaultLoader] displayLoadingView:msgLoading];
    __weak __typeof(self) weakSelf = self;
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    self.locationRequestID =  [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:50 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        __typeof(weakSelf) strongSelf = weakSelf;
        if (status == INTULocationStatusSuccess) {
            [SVGeocoder reverseGeocode:currentLocation.coordinate completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                [User sharedUser].latitude = currentLocation.coordinate.latitude;
                [User sharedUser].longitude = currentLocation.coordinate.longitude;
                [User sharedUser].strCountryCode = [placemarks[0] valueForKey:@"ISOcountryCode"];
                [User sharedUser].strCountryName = [placemarks[0] valueForKey:@"country"];
                [User sharedUser].strCityName = [placemarks[0] valueForKey:@"locality"];
                
                if(isSaveLocation) {
                    [self saveCurrentLocation:placemarks];
                }
            }];
        } else if (status == INTULocationStatusTimedOut) {
            [[Loader defaultLoader] hideLoadingView];
            [self locationError:[NSString stringWithFormat:msgTimeOut, currentLocation]];
        } else {
            if (status == INTULocationStatusServicesNotDetermined) {
                [self locationError:msgLocationNotDetermine];
            } else if (status == INTULocationStatusServicesDenied) {
                [self locationError:msgUserDeniedPermission];
            } else if (status == INTULocationStatusServicesRestricted) {
                [self locationError:msgUserRestrictedLocation];
            } else if (status == INTULocationStatusServicesDisabled) {
                [self locationError:msgLocationTurnOff];
            } else {
                //[self locationError:msgLocationError];
            }
            [[Loader defaultLoader] hideLoadingView];
        }
        strongSelf.locationRequestID = NSNotFound;
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
    static NSString *CellIdentifier = @"BookmarkCell";
    BookmarkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BookmarkCell" owner:self options:nil] objectAtIndex:0];
    
    Country *country = [self getCoutry:indexPath.row];
    cell.country = country;
    [cell.btnDelete addTarget:self action:@selector(btnDeleteTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDelete.tag = indexPath.row;
    
//    if (country.countryId == _intAlertIndex) {
//        
//            cell.ImgAlert.hidden = NO;
//    }
    if (_tempCountryNotification.count>0) {
        for (int i=0; i< _tempCountryNotification.count; i++) {
            notifiedCopuntry *nono = _tempCountryNotification[i];
            if (country.countryId == nono.countryId) {
                cell.ImgAlert.hidden = NO;
                // [_tempCountryNotification removeObjectAtIndex:i];
            }
        }
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"BookmarkCell";
    BookmarkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BookmarkCell" owner:self options:nil] objectAtIndex:0];
    
    Country *country = [self getCoutry:indexPath.row];

    
    if (_tempCountryNotification.count>0) {
        for (int i=0; i< _tempCountryNotification.count; i++) {
            notifiedCopuntry *nono = _tempCountryNotification[i];
            if (country.countryId == nono.countryId) {
                cell.ImgAlert.hidden = YES;
                [_tempCountryNotification removeObjectAtIndex:i];
                [[SQLiteManager singleton] deleteRowWithId:nono.Id from:kNotificationtableName];
            }
        }    }
    
//    if (country.countryId == _intAlertIndex) {
//        
//        cell.ImgAlert.hidden=YES;
//    }
    
    AlertsViewController *alertsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"AlertsViewController"];
 // alertsViewController.country = country;
        
        alertsViewController.strCountryName = country.strCountryName;
        alertsViewController.countryId = country.countryId;
        [self.navigationController pushViewController:alertsViewController animated:YES];
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

#pragma mark - Button tap events

- (IBAction)btnMenuTapped:(id)sender{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)btnCallTapped:(id)sender{
    [[AppDelegate appDelegate] callEmergency];
}

- (IBAction)btnCurrentLocationTapped:(id)sender {
    if([User sharedUser].latitude == 0.0 && [User sharedUser].longitude==0.0 && [User sharedUser].strCityName == nil && [User sharedUser].strCountryCode == nil && [User sharedUser].strCountryName == nil){
        [self fetchCurrentLocation:YES];
    }else {
        [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake([User sharedUser].latitude, [User sharedUser].longitude) completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
            [self saveCurrentLocation:placemarks];
        }];
    }
}

- (void)saveCurrentLocation:(NSArray*)placemarks{
    [[WebClient sharedClient]saveLocation:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"countrycode":[placemarks[0] valueForKey:@"ISOcountryCode"]} success:^(NSDictionary *dictionary) {
        BOOL success = [dictionary[@"success"] boolValue];
        if(success){
            [self getBookmarkCountryList];
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
        }
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:error.localizedDescription image:kErrorImage];
    }];
    [Helper addCustomObjectToUserDefaults:[User sharedUser] key:msgUserInfo];
}

- (void)btnDeleteTapped:(UIButton*)sender{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:msgDelete andMessage:msgUnfavouriteConfirmation];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"YES"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [self deleteRow:sender];
                          }];
    [alertView addButtonWithTitle:@"NO"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

- (void)locationError:(NSString *)msg{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Oops" andMessage:msg];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              if(![Helper getBoolFromUserDefaults:@"BookmarkCountryList"])
                                  [self performSegueWithIdentifier:@"push" sender:self];
                              [Helper addBoolToUserDefaults:YES forKey:@"BookmarkCountryList"];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [User sharedUser].latitude = 0.0;
    [User sharedUser].longitude = 0.0;
    [User sharedUser].strCityName = nil;
    [User sharedUser].strCountryCode = nil;
    [User sharedUser].strCountryName = nil;
   
    [alertView show];
}

#pragma mark - Delete Row

- (void)deleteRow:(UIButton*)sender{
    Country *country = [self getCoutry:sender.tag];
    [[WebClient sharedClient] deleteBookmark:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID],@"countryid":[NSNumber numberWithInteger:country.countryId]} success:^(NSDictionary *dictionary) {
        if([dictionary[@"success"] boolValue] == YES){
            if (_isTextfieldLoded == YES) {
                [_filteredCountries removeObjectAtIndex:sender.tag];
            }else{
                [_arrCountries removeObjectAtIndex:sender.tag];
            }
            [_tblList beginUpdates];
            [_tblList deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [_tblList endUpdates];
        }else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
        }
        _lblNoRecordFound.hidden = _arrCountries.count!=0;
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
        _lblNoRecordFound.hidden = _arrCountries.count!=0;
    }];
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

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _intAlertIndex = -1;
}

@end
