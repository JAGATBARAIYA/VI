//
//  AllCountryCell.h
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 25/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface AllCountryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblCountryName;
@property (strong, nonatomic) IBOutlet UIButton *btnCheck;

@property (strong, nonatomic) Country *country;

@end
