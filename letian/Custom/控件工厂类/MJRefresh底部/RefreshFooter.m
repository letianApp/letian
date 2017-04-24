//
//  CYAutoFooter.m
//
//  Created by guoqian on 16/7/28.
//  Copyright © 2016年 www.7eche.com. All rights reserved.
//

#import "RefreshFooter.h"

@interface RefreshFooter()

@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *loading;

@end

@implementation RefreshFooter

#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = MAINCOLOR;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = self.bounds;
    self.loading.center = CGPointMake(SCREEN_W * 0.2, self.mj_h * 0.5);
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"嘿,再加把劲";
            [self.loading stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在努力加载中";
            [self.loading startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"/(ㄒoㄒ)/~~，已经到底咯";
            [self.loading stopAnimating];
            break;
        default:
            break;
    }
}
@end
