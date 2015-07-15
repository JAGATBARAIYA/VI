//
//  MemberCell.h
//  Vetted-Intl
//
//  Created by Manish on 12/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"

@interface MemberCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblMobileNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) Member *member;

@end
