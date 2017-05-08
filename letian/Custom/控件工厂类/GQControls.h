//
//  GQControls.h
//  letian
//
//  Created by 郭茜 on 2017/3/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQControls : NSObject

+(UILabel *)createLabelWithFrame:(CGRect)frame andText:(NSString *)text andTextColor:(UIColor *)color andFontSize:(CGFloat)fontSize;

+(UIButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)color andFontSize:(CGFloat)fontSize andBackgroundColor:(UIColor *)backgroundColor;

+(UIButton *)createImageButtonWithFrame:(CGRect)frame withImageName:(NSString *)imageName;

+(UIButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)color andFontSize:(CGFloat)fontSize andTag:(NSInteger)tag andMaskToBounds:(BOOL)mask andRadius:(CGFloat)radius andBorderWidth:(CGFloat)borderWidth andBorderColor:(CGColorRef )borderColor;

+(UISwitch *)createSwitchWithFrame:(CGRect)frame;

+(UIView *)createViewWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)color;

@end
