//
//  PGPayResult.h
//  letian
//
//  Created by J on 2017/3/29.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 支付结果状态
 */
typedef NS_ENUM(NSInteger, PayErrCode) {
    PaySuccess           = 0,    /**< 成功    */
    PayErrCodeCommon     = -1,   /**< 失败    */
    PayErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
};

#pragma mark -
/**
 支付结果
 */
@interface PGPayResult : NSObject

@property(nonatomic, strong)NSString *szOrder;
@property(nonatomic, assign)PayErrCode errorCode;
@property(nonatomic, strong)NSString *szDesc;

@end
