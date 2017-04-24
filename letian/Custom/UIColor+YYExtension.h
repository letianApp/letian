//
//  UIColor+HFExtension.h
//  HiMagzine
//
//  Created by fairzy on 13-9-10.
//  Copyright (c) 2013年 hifashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YYExtension)

+ (UIColor*)colorWithHexString:(NSString*)hex;
+ (UIColor *)colorWithHexNumber:(NSInteger)rgbValue;
+ (UIColor *)HFPinkColor;
+ (UIColor *) colorWithHex:(int)color;

- (UIImage *)imageWithColor;

@end
