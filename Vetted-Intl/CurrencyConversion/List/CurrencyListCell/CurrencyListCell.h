//
//  CurrencyListCell.h
//  Vetted-Intl
//
//  Created by Manish Dudharejia on 21/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Currency.h"

@class CurrencyListCell;

@protocol CurrencyListCellDelegate <NSObject>

//- (void)selectFromCurrency:(CurrencyListCell*)cell currency:(Currency*)currency;
- (void)selectToCurrency:(CurrencyListCell*)cell currency:(Currency*)currency;

@end

@interface CurrencyListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblCurrency;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrencyCode;

@property (strong, nonatomic) IBOutlet UIButton *btnFrom;
@property (strong, nonatomic) IBOutlet UIButton *btnTo;

@property (assign, nonatomic) id<CurrencyListCellDelegate> delegate;

@property (strong, nonatomic) Currency *currency;

@end
