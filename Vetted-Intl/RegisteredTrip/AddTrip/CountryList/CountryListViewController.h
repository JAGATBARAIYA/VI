//
//  CountryListViewController.h
//  Vetted-Intl
//
//  Created by Manish on 23/04/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@class CountryListViewController;

@protocol CountryListViewControllerDeleagate <NSObject>
- (void)countryListViewController:(CountryListViewController*)controller country:(Country *)country;
@end

@interface CountryListViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *arrCountries;

@property (assign, nonatomic) id<CountryListViewControllerDeleagate> delegate;

@end
