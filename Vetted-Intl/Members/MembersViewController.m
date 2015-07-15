//
//  MembersViewController.m
//  Vetted-Intl
//
//  Created by Manish on 12/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "MembersViewController.h"
#import "AddMemberViewController.h"
#import "MemberCell.h"
#import "MFSideMenu.h"
#import "RegisteredTrip.h"
#import "WebClient.h"
#import "Member.h"
#import "Helper.h"
#import "User.h"
#import "SIAlertView.h"
#import "REFrostedViewController.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"

@interface MembersViewController () <AddMemberViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblNoDataFound;
@property (strong, nonatomic) IBOutlet UITableView *tblList;

@property (strong, nonatomic) NSMutableArray *arrMembers;

@end

@implementation MembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrMembers = [[NSMutableArray alloc]init];
    [self addPanicView];
}

- (void)viewWillAppear:(BOOL)animated{
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getMemberList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getMemberList{
    [_arrMembers removeAllObjects];
    [[WebClient sharedClient] getMembers:@{@"userid":[NSNumber numberWithInteger:[User sharedUser].intUserID]} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
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
        _lblNoDataFound.hidden = _arrMembers.count!=0;
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}


#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrMembers.count;
}

- (MemberCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MemberCell";
    MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MemberCell" owner:self options:nil] objectAtIndex:0];
    
    Member *member = _arrMembers[indexPath.row];
    cell.lblName.text = [member.strName uppercaseString];
    cell.lblMobileNumber.text = member.strPhoneNumber;

    [cell.btnDelete addTarget:self action:@selector(btnDeleteTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDelete.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Member *member = _arrMembers[indexPath.row];
    member.isHide = NO;
    AddMemberViewController *addMemberViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"AddMemberViewController"];
    addMemberViewController.member = member;
    [self.navigationController pushViewController:addMemberViewController animated:YES];
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
    AddMemberViewController *addMemberViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"AddMemberViewController"];
    [self.navigationController pushViewController:addMemberViewController animated:YES];
}

- (void)btnDeleteTapped:(UIButton*)sender{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:msgDelete andMessage:msgDeleteMember];
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
    Member *member = _arrMembers[sender.tag];
    [[WebClient sharedClient] deleteMember:@{@"memberid":[NSNumber numberWithInteger:member.intMemberID]} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if([dictionary[@"success"] boolValue] == YES){
            [_arrMembers removeObjectAtIndex:sender.tag];
            [_tblList beginUpdates];
            [_tblList deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [_tblList endUpdates];
        }else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
        }
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
    }];
}

@end
