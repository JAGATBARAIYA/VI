//
//  CategoryCell.h
//  Vetted-Intl
//
//  Created by Manish on 26/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalInfo.h"

@interface CategoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDescription;

@property (strong, nonatomic) GlobalInfo *globalInfo;

@end
