//
//  RegisteredTripCell.h
//  Vetted-Intl
//
//  Created by Manish on 07/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisteredTrip.h"

@interface RegisteredTripCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDestination;
@property (strong, nonatomic) IBOutlet UILabel *lblDateFrom;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) RegisteredTrip *registeredTrip;


@end
