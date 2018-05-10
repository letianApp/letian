//
//  CustomPlusBtn.m
//  letian
//
//  Created by J on 2017/4/18.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CustomPlusBtn.h"

#import "ChatListViewController.h"
#import "ConsultViewController.h"
#import "ChatViewController.h"


@implementation CustomPlusBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//上下结构的 button
- (void)layoutSubviews {
    [super layoutSubviews];

// 控件大小,间距大小
// 注意：一定要根据项目中的图片去调整下面的0.7和0.9，Demo之所以这么设置，因为demo中的 plusButton 的 icon 不是正方形。
    CGFloat const imageViewEdgeWidth   = self.bounds.size.height * 0.7;
//    NSLog(@"高度%f",self.superview.bounds.size.height);
    CGFloat const imageViewEdgeHeight  = imageViewEdgeWidth;

    CGFloat const centerOfViewY    = self.bounds.size.height * 0.5;
    CGFloat const centerOfViewX    = self.bounds.size.width * 0.5;

//    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
//    CGFloat const verticalMargin  = (self.bounds.size.height - labelLineHeight - imageViewEdgeHeight) * 0.5;

// imageView 和 titleLabel 中心的 Y 值
//    CGFloat const centerOfImageView  = imageViewEdgeHeight * 0.5;
//    CGFloat const centerOfTitleLabel = imageViewEdgeHeight  + verticalMargin * 2 + labelLineHeight * 0.5 + 5;

////imageView position 位置
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdgeHeight, imageViewEdgeHeight);
    self.imageView.center = CGPointMake(centerOfViewX, centerOfViewY);
//
//    //title position 位置
//    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
//    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
}


+ (id)plusButton {
    CustomPlusBtn *button = [[CustomPlusBtn alloc] init];
    UIImage *buttonImage = [UIImage imageNamed:@"consultPagTabWhite"];
    [button setImage:buttonImage forState:UIControlStateNormal];
//    [button setTitle:@"咨询" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    
//    [button setTitle:@"咨询" forState:UIControlStateSelected];
//    [button setTitleColor:MAINCOLOR forState:UIControlStateSelected];
//    
//    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
//    [button sizeToFit]; // or set frame in this way `button.frame = CGRectMake(0.0, 0.0, 250, 100);`
    button.frame = CGRectMake(0.0, 0.0, SCREEN_W/3, 49);
    button.backgroundColor = MAINCOLOR;
    
    // if you use `+plusChildViewController` , do not addTarget to plusButton.
    [button addTarget:button action:@selector(clickConsultBtn) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)clickConsultBtn {
    
//    NSLog(@"点击咨询按钮");
    
    ChatListViewController *chatListVc  = [[ChatListViewController alloc]init];
    chatListVc.hidesBottomBarWhenPushed = YES;

    
    ChatViewController *secondViewController           = [[ChatViewController alloc] init];
//    RTRootNavigationController *secondNavigationController = [[RTRootNavigationController alloc]
//                                                    initWithRootViewController:chatListVc];
    
    
    
    UITabBarController *tabBarController               = (UITabBarController *)self.window.rootViewController;
//    [tabBarController presentViewController:secondNavigationController animated:YES completion:nil];
    
    
}

@end
