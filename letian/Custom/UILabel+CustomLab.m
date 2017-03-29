//
//  UILabel+CustomLab.m
//  letian
//
//  Created by J on 2017/3/29.
//  Copyright © 2017年 J. All rights reserved.
//

#import "UILabel+CustomLab.h"

@implementation UILabel (CustomLab)

- (void)LabelTextAutoFitWidth {
    
    NSMutableAttributedString *attributeString =  [[NSMutableAttributedString alloc] initWithString:self.text];
    CGSize attributeSize = [attributeString.string sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGSize adjustedSize = CGSizeMake(ceilf(attributeSize.width), ceilf(attributeSize.height));
    CGSize frame = self.frame.size;
    NSNumber *wordSpace = [NSNumber numberWithInt:((frame.width-adjustedSize.width)/(attributeString.length-1))];
    [attributeString addAttribute:NSKernAttributeName value:wordSpace range:NSMakeRange(0, attributeString.length-1)];
    self.attributedText = attributeString;
    
}


@end
