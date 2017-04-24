//
//  MBHudSet.m
//  letian
//
//  Created by 郭茜 on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "MBHudSet.h"
#import "MBProgressHUD.h"

@interface MBHudSet ()

@end

@implementation MBHudSet

+ (void)showText:(NSString *)str andOnView:(UIView *)fatherView
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:fatherView animated:YES];;
    HUD.mode = MBProgressHUDModeText;
    HUD.label.text = str;
    [HUD hideAnimated:YES afterDelay:2.f];
}

+ (void)showStatusOnView:(UIView *)fatherView
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:fatherView animated:YES];;
    HUD.mode = MBProgressHUDModeIndeterminate;
}

+(void)dismiss:(UIView *)fatherView{
    [MBProgressHUD hideHUDForView:fatherView animated:YES];
}
@end
