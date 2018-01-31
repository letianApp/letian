//
//  GQControls.m
//  letian
//
//  Created by 郭茜 on 2017/3/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "GQControls.h"

@implementation GQControls

+(UILabel *)createLabelWithFrame:(CGRect)frame andText:(NSString *)text andTextColor:(UIColor *)color andFontSize:(CGFloat)fontSize
{
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.text=text;
    label.textColor=color;
    label.font=[UIFont systemFontOfSize:fontSize];
    return label;
}

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


+(UIButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)color andFontSize:(CGFloat)fontSize andTag:(NSInteger)tag andMaskToBounds:(BOOL)mask andRadius:(CGFloat)radius andBorderWidth:(CGFloat)borderWidth andBorderColor:(CGColorRef )borderColor{
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:fontSize];
    button.tag=tag;
    [button.layer setMasksToBounds:mask];
    [button.layer setCornerRadius:radius];
    [button.layer setBorderWidth:borderWidth];
    button.layer.borderColor = borderColor;
    return button;
}


+(UISwitch *)createSwitchWithFrame:(CGRect)frame{
    UISwitch *switchView = [[UISwitch alloc]initWithFrame:frame];
    switchView.on = YES;
    return switchView;
}

+(UIView *)createViewWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)color{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    view.backgroundColor=color;
    return view;
}

+(UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext: context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


+(UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    scrollView.contentSize=CGSizeMake(SCREEN_W, scrollView.contentSize.height+SCREEN_W*0.8);
//    scrollView.backgroundColor = MAINCOLOR;
    UIView *lineView=[self createViewWithFrame:CGRectMake(30, scrollView.contentSize.height-SCREEN_W*0.7, SCREEN_W-60, 0.5) andBackgroundColor:[UIColor lightGrayColor]];
    [scrollView addSubview:lineView];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(40, lineView.centerY+10, SCREEN_W*0.3, SCREEN_W*0.3)];
    imageV.image =[UIImage imageNamed:@"二维码"];
    imageV.contentMode = UIViewContentModeScaleToFill;
//    imageV.backgroundColor = [UIColor blackColor];
    [scrollView addSubview:imageV];
    
    UIImageView *textImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"广告语"]];
    textImage.frame=CGRectMake(SCREEN_W*0.3+60, 0, SCREEN_W*0.5, SCREEN_W*0.2);
    textImage.centerY=imageV.centerY;
    [scrollView addSubview:textImage];
    
    NSLog(@"yyy:%f",imageV.bottom);

    UILabel *adText = [[UILabel alloc]initWithFrame:CGRectMake(40, imageV.bottom+10, imageV.width, 20)];
    adText.text = @"乐天心理APP二维码";
    adText.textColor = MAINCOLOR;
    adText.numberOfLines = 1;
    adText.adjustsFontSizeToFitWidth = YES;
    [scrollView addSubview:adText];
    
    
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    [lineView removeFromSuperview];
    [imageV removeFromSuperview];
    [textImage removeFromSuperview];
    
    UIGraphicsEndImageContext();
    
    
    
    
    
    if (image != nil) {
        return image;
        }
        return nil;
}
@end
