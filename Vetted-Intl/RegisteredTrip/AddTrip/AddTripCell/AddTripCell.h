//
//  AddTripCell.h
//  Vetted-Intl
//
//  Created by Manish on 10/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"
#import "RegisteredTrip.h"

@class AddTripCell;

@protocol AddTripDelegate <NSObject>

- (void)selectMember:(AddTripCell*)cell member:(Member*)member;

@end

@interface AddTripCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblMobileNumber;

@property (strong, nonatomic) IBOutlet UIButton *btnCheck;

@property (strong, nonatomic) Member *member;
@property (strong, nonatomic) RegisteredTrip *registeredTrip;

//- (void)setMember:(Member *)member setRegistered:(RegisteredTrip *)registered;

@property (assign, nonatomic) id<AddTripDelegate> delegate;

@end
