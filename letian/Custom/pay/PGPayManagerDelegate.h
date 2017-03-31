//
//  PGPayManagerDelegate.h
//  letian
//
//  Created by J on 2017/3/29.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGPayResult.h"

/*
 支付方式
 */
typedef NS_ENUM(NSInteger, PGPayType) {
    PGPayType_None      = 0,//不支付
    PGPayType_WxPay     = 1,//微信支付
    PGPayType_AliPay    = 2,//支付宝支付
};

@protocol PGPayManagerDelegate <NSObject>
@required
/*
 payResult: 支付结果
 */
- (void)payFinished:(PGPayResult *)payResult;
/*
 平台App没有安装
 */
- (void)noInstallPlatformApp:(PGPayType)type orderId:(NSString *)orderId;
@end
