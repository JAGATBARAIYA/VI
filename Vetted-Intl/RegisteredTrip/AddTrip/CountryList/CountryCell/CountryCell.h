//
//  CountryCell.h
//  Vetted-Intl
//
//  Created by Manish on 23/04/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface CountryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblCountryName;

@property (strong, nonatomic) Country *country;

@end
