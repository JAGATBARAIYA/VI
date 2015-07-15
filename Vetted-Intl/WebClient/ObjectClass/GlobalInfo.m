//
//  GlobalInfo.m
//  Vetted-Intl
//
//  Created by Manish on 27/02/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "GlobalInfo.h"
#import "NSString+HTML.h"

@implementation GlobalInfo

+ (GlobalInfo *)dataWithInfo:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (GlobalInfo *)initWithDictionary:(NSDictionary*)dict{
    if(dict[@"category"]!=[NSNull null])
         self.strCategoryName = [dict[@"category"] stringByDecodingHTMLEntities];
    
    if(dict[@"countryid"]!=[NSNull null])
        self.intCategoryId = [dict[@"countryid"]integerValue];
    
    if(dict[@"text"]!=[NSNull null])
        self.strText = [dict[@"text"] lastObject];
    
//    self.strCategoryName = [self.strCategoryName stringByDecodingHTMLEntities];
//    self.attributedCatString = [self getString:self.strCategoryName fontSize:17.0];
    self.attributedString = [self getString:self.strText fontSize:14.0];
    
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
