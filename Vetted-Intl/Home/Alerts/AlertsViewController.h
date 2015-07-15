//
//  AlertsViewController.h
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 25/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface AlertsViewController : UIViewController

@property (strong, nonatomic) Country *country;
@property (strong, nonatomic)NSString *strCountryName;
@property (assign, nonatomic) NSInteger countryId;

@end
