//
//  GQControls.h
//  letian
//
//  Created by 郭茜 on 2017/3/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQControls : NSObject

/**
 快速创建Label
 */
+(UILabel *)createLabelWithFrame:(CGRect)frame andText:(NSString *)text andTextColor:(UIColor *)color andFontSize:(CGFloat)fontSize;
/**
 快速创建普通button
 */
+(UIButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)color andFontSize:(CGFloat)fontSize andBackgroundColor:(UIColor *)backgroundColor;
/**
 快速创建图片button
 */
+(UIButton *)createImageButtonWithFrame:(CGRect)frame withImageName:(NSString *)imageName;
/**
 快速创建圆角边框button
 */
+(UIButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)color andFontSize:(CGFloat)fontSize andTag:(NSInteger)tag andMaskToBounds:(BOOL)mask andRadius:(CGFloat)radius andBorderWidth:(CGFloat)borderWidth andBorderColor:(CGColorRef )borderColor;
/**
 快速创建开关
 */
+(UISwitch *)createSwitchWithFrame:(CGRect)frame;
/**
 快速创建view
 */
+(UIView *)createViewWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)color;
/**
 截图
 */
+(UIImage *)imageFromView:(UIView *)theView;
/**
 截取超出屏幕的长图
 */
+(UIImage *)captureScrollView:(UIScrollView *)scrollView;

@end
