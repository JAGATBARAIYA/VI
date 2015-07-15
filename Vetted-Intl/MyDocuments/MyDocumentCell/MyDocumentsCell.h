//
//  MyDocumentsCell.h
//  Vetted-Intl
//
//  Created by Manish on 27/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDocuments.h"

@interface MyDocumentsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDocumentName;
@property (strong, nonatomic) IBOutlet UIImageView *imgFileType;

@property (strong, nonatomic) MyDocuments *myDocuments;

@end
