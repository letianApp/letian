//
//  MBHudSet.h
//  letian
//
//  Created by 郭茜 on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBHudSet : NSObject

//文字
+ (void)showText:(NSString *)str andOnView:(UIView *)fatherView;

//转菊花
+ (void)showStatusOnView:(UIView *)fatherView;

//消失
+(void)dismiss:(UIView *)fatherView;

@end
