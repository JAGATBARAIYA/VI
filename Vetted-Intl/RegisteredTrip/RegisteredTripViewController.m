//
//  RegisteredTripViewController.m
//  Vetted-Intl
//
//  Created by Manish on 07/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "RegisteredTripViewController.h"
#import "AddTripViewController.h"
#import "RegisteredTripCell.h"
#import "MFSideMenu.h"
#import "RegisteredTrip.h"
#import "WebClient.h"
#import "SIAlertView.h"
#import "Helper.h"
#import "User.h"
#import "Member.h"
#import "REFrostedViewController.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"

@interface RegisteredTripViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;

@property (strong, nonatomic) NSMutableArray *arrRegisteredTrip;

@end

@implementation RegisteredTripViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [self getRegisteredTrip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    [self addPanicView];
    _arrRegisteredTrip = [[NSMutableArray alloc] init];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)getRegisteredTrip{
    [_arrRegisteredTrip removeAllObjects];
    [[WebClient sharedClient] getTrip:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID]} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                NSArray *data = dictionary[@"trips"];
                if(data.count!=0){
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        RegisteredTrip *registeredTrip = [RegisteredTrip dataWithInfo:obj];
                        [_arrRegisteredTrip addObject:registeredTrip];
                    }];
                }
                [_tblList reloadData];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
        _lblNoRecordFound.hidden = _arrRegisteredTrip.count!=0;
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
        _lblNoRecordFound.hidden = _arrRegisteredTrip.count!=0;
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
    return _arrRegisteredTrip.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RegisteredTripCell";
    RegisteredTripCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RegisteredTripCell" owner:self options:nil] objectAtIndex:0];
    
    RegisteredTrip *registeredTrip = _arrRegisteredTrip[indexPath.row];
    cell.lblDestination.text = [registeredTrip.strDestination uppercaseString];
    cell.lblDateFrom.text = [[[NSString stringWithFormat:@"%@ TO ",registeredTrip.strFromDate ] stringByAppendingString:registeredTrip.strToDate]uppercaseString];
    [cell.btnDelete addTarget:self action:@selector(btnDeleteTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDelete.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RegisteredTrip *registeredTrip = _arrRegisteredTrip[indexPath.row];
    AddTripViewController *addTripViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"AddTripViewController"];
    addTripViewController.registeredTrip = registeredTrip;
    [self.navigationController pushViewController:addTripViewController animated:YES];
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

- (IBAction)btnAddTapped:(id)sender{
    AddTripViewController *tripViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"AddTripViewController"];
    [self.navigationController pushViewController:tripViewController animated:YES];
}

- (void)btnDeleteTapped:(UIButton*)sender{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:msgDelete andMessage:msgDeleteConfirmation];
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

- (void)deleteRow:(UIButton*)sender{
    RegisteredTrip *registeredTrip = _arrRegisteredTrip[sender.tag];
    [[WebClient sharedClient] deleteTrip:@{@"tripid":[NSNumber numberWithInteger:registeredTrip.intTripID]} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if([dictionary[@"success"] boolValue] == YES){
            [_arrRegisteredTrip removeObjectAtIndex:sender.tag];
            [_tblList beginUpdates];
            [_tblList deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [_tblList endUpdates];
        }else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
        }
        _lblNoRecordFound.hidden = _arrRegisteredTrip.count!=0;
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
        _lblNoRecordFound.hidden = _arrRegisteredTrip.count!=0;
    }];
}

@end
