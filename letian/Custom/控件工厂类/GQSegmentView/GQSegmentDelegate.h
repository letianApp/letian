//
//  GQSegmentDelegate.h
//  GQSlideSwitchDemo
//
//  Created by guoqian on 2017/1/9.
//  Copyright © 2017年 Apple. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol GQSegmentDelegate <NSObject>
@optional
/**
 切换位置
 */
- (void)segmentDidselectTab:(NSUInteger)index;
/*
 滑动到左边界时调用
 */
- (void)slideSwitchPanLeftEdge:(UIPanGestureRecognizer *)panParam;

/**
 滑动到右边界时调用
 */
- (void)slideSwitchPanRightEdge:(UIPanGestureRecognizer *)panParam;

@end
