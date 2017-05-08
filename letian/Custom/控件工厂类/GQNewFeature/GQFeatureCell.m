//
//  GQFeatureCell.m
//  cheyongwang
//
//  Created by 郭茜 on 15/11/15.
//  Copyright © 2015年 郭茜. All rights reserved.
//

#import "GQFeatureCell.h"
//#import "GQMainViewController.h"

@interface GQFeatureCell()

/**
 *  cell上的图片
 */
@property (nonatomic,weak) UIImageView *imageView;

/**
 *  进入主界面按钮
 */
@property (nonatomic,weak) UIButton *enterNewFeatureBtn;

@end

@implementation GQFeatureCell

/**
 *  懒加载进入主界面按钮
 */
-(UIButton *)enterNewFeatureBtn
{
    if (_enterNewFeatureBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"entryNewFeatures"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"entryNewFeatures_selected"] forState:UIControlStateSelected];
        [self.contentView addSubview:btn];
        [btn sizeToFit];
        btn.hidden = YES;
        [btn addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchDown];
        self.enterNewFeatureBtn = btn;
    }
    return _enterNewFeatureBtn;
}

/**
 *  重新布局子控件
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.enterNewFeatureBtn.center = CGPointMake(self.center.x, self.bounds.size.height * 0.85);
}

/**
 *  懒加载cell的图片
 */
-(UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

/**
 *  重写set方法
 */
-(void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
    self.imageView.frame = self.bounds;

}

/**
 *  根据indexPath来设置进入主界面按钮的显示与否
 *
 *  @param indexPath 图片的Index
 *  @param count     图片的总数
 */
-(void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count
{
    if (indexPath.row == count -1) {
        self.enterNewFeatureBtn.hidden = NO;
    }else{
        self.enterNewFeatureBtn.hidden = YES;
    }
}

/**
 *  进入主界面，更改window的根控制器
 */
-(void) enter
{
    //NKMainViewController *mainVc = [[NKMainViewController alloc] init];
    
    //[UIApplication sharedApplication].keyWindow.rootViewController = mainVc;
}

@end
