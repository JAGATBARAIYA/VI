//
//  MyDocumentsViewController.m
//  Vetted-Intl
//
//  Created by Manish on 27/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "MyDocumentsViewController.h"
#import "BNEasyGoogleAnalyticsTracker.h"
#import "MyDocumentsCell.h"
#import "MFSideMenu.h"
#import "MyDocuments.h"
#import "WebClient.h"
#import "Helper.h"
#import "User.h"
#import "Loader.h"
#import "REFrostedViewController.h"
#import "PanicButton.h"
#import "UIViewController+Additions.h"

@interface MyDocumentsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;

@property (strong, nonatomic) NSMutableArray *arrDocuments;

@end

@implementation MyDocumentsViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[[BNEasyGoogleAnalyticsTracker sharedTracker] trackScreenNamed:msgMyDocument];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    [self addPanicView];
    _arrDocuments = [[NSMutableArray alloc] init];
    _tblList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self getMyDocumentsList];
}

- (void)getMyDocumentsList{
    [_arrDocuments removeAllObjects];
    [[WebClient sharedClient] getMyDocumentsList:@{@"userid":[User sharedUser].strEmail} success:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if (dictionary!=nil) {
            if([dictionary[@"success"] boolValue] == YES){
                _arrDocuments = dictionary[@"url"];
                [_tblList reloadData];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:dictionary[@"message"] image:kErrorImage];
            }
        }
        _lblNoRecordFound.hidden = _arrDocuments.count!=0;
    } failure:^(NSError *error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:titleFail image:kErrorImage];
        _lblNoRecordFound.hidden = _arrDocuments.count!=0;
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
    return _arrDocuments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MyDocumentsCell";
    MyDocumentsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyDocumentsCell" owner:self options:nil] objectAtIndex:0];
    
    cell.lblDocumentName.text = [_arrDocuments[indexPath.row] lastPathComponent];
    NSArray *arrFileType = [cell.lblDocumentName.text componentsSeparatedByString:@"."];
    if (arrFileType.count!=0) {
        if([arrFileType[1]  isEqual: @"pdf"]){
            cell.imageView.image = [UIImage imageNamed:@"pdf_icon"];
        }else if([arrFileType[1]  isEqual: @"ppt"]) {
            cell.imageView.image = [UIImage imageNamed:@"ppt_icon"];
        }else if([arrFileType[1]  isEqual: @"png"] || [arrFileType[1]  isEqual: @"jpg"]) {
            cell.imageView.image = [UIImage imageNamed:@"image_icon"];
        }else if ([arrFileType[1]  isEqual: @"doc"] || [arrFileType[1]  isEqual: @"docs"]){
            
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[Loader defaultLoader] displayLoadingView:msgLoading];
    NSURL *URL =[NSURL URLWithString:[_arrDocuments[indexPath.row] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSString *filePath = [Helper getDocumentDirectoryPath:[_arrDocuments[indexPath.row]lastPathComponent]];
    
    [self performSelector:@selector(setupDocumentForPreview:) withObject:[NSDictionary dictionaryWithObjectsAndKeys: URL, @"url", filePath, @"filepath", nil] afterDelay:0.2];
}

-(void)setupDocumentForPreview:(NSDictionary *)dictFileData{
    NSURL *url=dictFileData[@"url"];
    NSData *fileData = [NSData dataWithContentsOfURL:url];
    [fileData writeToFile:dictFileData[@"filepath"] atomically:YES];
    
    NSURL *filePathURL = [NSURL fileURLWithPath:dictFileData[@"filepath"]];    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    if (url) {
        _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:filePathURL];
        [_documentInteractionController setDelegate:self];
        [_documentInteractionController presentPreviewAnimated:YES];
    }
    
    [[Loader defaultLoader] hideLoadingView];
}

//- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller   canPerformAction:(SEL)action{
//    return false;
//}

#pragma mark - UIDocumentInteractionController Delegate Methods

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return  self;
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
