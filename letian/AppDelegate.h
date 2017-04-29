//
//  AppDelegate.h
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/**
 *  定义了一个pushToOrderVc的Block。参数为字符串类型
 */
@property (nonatomic, copy) void(^pushToOrderVc)(NSInteger alipayCode);

@property (strong, nonatomic) UIWindow *window;

@end

