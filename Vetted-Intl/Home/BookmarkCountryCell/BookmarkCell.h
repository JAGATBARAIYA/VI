//
//  BookmarkCell.h
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 25/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface BookmarkCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblCountryName;

@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) Country *country;

@property (strong, nonatomic) IBOutlet UIImageView *ImgAlert;

@end
