//
//  PGPayManager.h
//  letian
//
//  Created by J on 2017/3/29.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGPayManagerDelegate.h"

@interface PGPayManager : NSObject

+ (PGPayManager *)shareInstance;
/*
 支付完成后，应用间的信息传递
 */
- (void)handleOpenURL:(NSURL *)url;
/*
 初始化各支付平台
 */
- (void)platformInit;
/*
 开始支付
 dicParam: 平台SDK支付所需的参数
 type:支付方式
 delegate: 支付完成后的回调
 */
- (void)startPayWithParam:(NSDictionary *)dicParam
                  orderId:(NSString *)orderId
                  payType:(PGPayType)type
                 delegate:(id<PGPayManagerDelegate>)delegate;
/*
 获取微信支付下载地址
 */
+ (NSString *)getWXAppInstallUrl;


@end
