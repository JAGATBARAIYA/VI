//
//  AddTripViewController.h
//  Vetted-Intl
//
//  Created by Manish on 07/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisteredTrip.h"
#import "Member.h"
#import "Country.h"

@interface AddTripViewController : UIViewController

@property (nonatomic, strong) RegisteredTrip *registeredTrip;
@property (nonatomic, strong) Member *member;
@property (nonatomic, strong) Country *country;

@end
