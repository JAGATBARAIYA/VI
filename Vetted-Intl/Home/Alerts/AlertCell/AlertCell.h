//
//  AlertCell.h
//  Vetted-Intl
//
//  Created by Manish on 17/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alert.h"

@class AlertCell;

@protocol AlertCellDelegate <NSObject>
- (void)alertCell:(NSString*)strAlertText;
@end

@interface AlertCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblAlertText;

@property (strong, nonatomic) Alert *alert;

@end
