//
//  Alert.m
//  Vetted-Intl
//
//  Created by Manish on 17/03/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "Alert.h"
#import "NSString+HTML.h"

@implementation Alert

+ (Alert *)dataWithInfo:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (Alert *)initWithDictionary:(NSDictionary *)dict{
    
    if(dict[@"alertid"]!=[NSNull null])
        self.intAlertID = [dict[@"alertid"] integerValue];
    
    if(dict[@"alert_text"]!=[NSNull null])
        self.strAlertText = dict[@"alert_text"];

    if(dict[@"title"]!=[NSNull null])
        self.strTitle = [dict[@"title"] stringByDecodingHTMLEntities];

    if(dict[@"alert_type"]!=[NSNull null])
        self.strAlertType = dict[@"alert_type"];
    
    if(dict[@"category"]!=[NSNull null])
        self.strCategory = dict[@"category"];

    if(dict[@"created_date"]!=[NSNull null])
        self.strUpdatedDate = dict[@"created_date"];
    
//    self.attributedTitleString = [self getString:self.strTitle fontSize:17.0];
    self.attributedDescString = [self getString:self.strAlertText fontSize:14.0];

    _open = NO;
    
    return self;
}

- (NSMutableAttributedString*)getString:(NSString*)data fontSize:(CGFloat)size{
    NSDictionary *dictAttrib = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,  NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc]initWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:dictAttrib documentAttributes:nil error:nil];
    [attrib beginEditing];
    [attrib enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            UIFont *oldFont = (UIFont *)value;
            [attrib removeAttribute:NSFontAttributeName range:range];
            if ([oldFont.fontName isEqualToString:@"TimesNewRomanPSMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-ItalicMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Italic" size:size] range:range];
            else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldItalicMT"])
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Italic" size:size] range:range];
            else
                [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:size] range:range];
        }
    }];
    [attrib endEditing];
    return attrib;
}

@end
