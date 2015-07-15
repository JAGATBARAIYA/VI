//
//  GlobalInfoCountryCell.h
//  Vetted-Intl
//
//  Created by Manish on 26/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface GlobalInfoCountryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblCountryName;

@property (strong, nonatomic) Country *country;

@end
