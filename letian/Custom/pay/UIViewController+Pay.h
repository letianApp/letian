//
//  UIViewController+Pay.h
//  letian
//
//  Created by J on 2017/3/29.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPayManagerDelegate.h"


typedef void(^PGPayFinishBlock)(PGPayResult *resultObj);
typedef void(^PGPayParamBlock)(NSString *orderId, PGPayType payType);

@interface UIViewController (Pay)<PGPayManagerDelegate>

@property(nonatomic, copy)PGPayFinishBlock payFinishBlock;
/*
 获取支付所需的支付参数
 */
@property(nonatomic, copy)PGPayParamBlock payParamBlock;
/*
 订单号
 */
@property(nonatomic, copy)NSString *payOrderId;

/*
 进行支付
 */
- (void)pay:(NSString *)szOrderId;
/*
 用对应的支付方式进行支付
 */
- (void)startPayWithParam:(NSDictionary *)dicParam
                  payType:(PGPayType)payType
                  orderId:(NSString *)szOrderId;

@end
