//
//  GQControls.m
//  letian
//
//  Created by 郭茜 on 2017/3/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "GQControls.h"

@implementation GQControls




//创建label
+(UILabel *)createLabelWithFrame:(CGRect)frame andText:(NSString *)text andTextColor:(UIColor *)color andFontSize:(CGFloat)fontSize
{
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.text=text;
    label.textColor=color;
    label.font=[UIFont systemFontOfSize:fontSize];
    return label;
    
}

//普通button
+(UIButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)color andFontSize:(CGFloat)fontSize andBackgroundColor:(UIColor *)backgroundColor {
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:color forState:UIControlStateNormal];
    
    button.titleLabel.font=[UIFont systemFontOfSize:fontSize];
    
    button.backgroundColor=backgroundColor;
    

    return button;
}

+(UIButton *)createImageButtonWithFrame:(CGRect)frame withImageName:(NSString *)imageName{
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    
    return button;
}
//创建非矩形button
+(UIButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)color andFontSize:(CGFloat)fontSize andTag:(NSInteger)tag andMaskToBounds:(BOOL)mask andRadius:(CGFloat)radius andBorderWidth:(CGFloat)borderWidth andBorderColor:(CGColorRef )borderColor{
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:color forState:UIControlStateNormal];
    
    button.titleLabel.font=[UIFont systemFontOfSize:fontSize];
    
    button.tag=tag;
    
    [button.layer setMasksToBounds:mask];
    
    [button.layer setCornerRadius:radius]; //设置矩圆角半径
    
    [button.layer setBorderWidth:borderWidth];   //边框宽度
    
    
    button.layer.borderColor = borderColor;
    
    return button;
}



@end
