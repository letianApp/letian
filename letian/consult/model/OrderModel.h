//
//  OrderModel.h
//  letian
//
//  Created by J on 2017/3/22.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

/*!
 咨询师名字
 */
@property (nonatomic, copy) NSString *conserlorName;

/*!
 选择咨询方式
 */
@property (nonatomic, copy) NSString *orderChoice;

/*!
 咨询日期
 */
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, copy) NSString *orderDateStr;
@property (nonatomic, copy) NSString *orderDateTimeStart;
@property (nonatomic, copy) NSString *orderDateTimeEnd;

/*!
 个人信息
 */
@property (nonatomic, copy) NSString *orderInfoName;
@property (nonatomic, copy) NSString *orderInfoSex;
@property (nonatomic, copy) NSString *orderInfoAge;
@property (nonatomic, copy) NSString *orderInfoPhone;
@property (nonatomic, copy) NSString *orderInfoEmail;

/*!
 咨询价格
 */
@property (nonatomic, copy) NSString *orderPrice;

/*!
 订单创建时间
 */
@property (nonatomic, copy) NSString *orderCreatTime;

/*!
 订单当前状态
 */
@property (nonatomic, copy) NSString *orderState;

/*!
 订单ID
 */
@property (nonatomic, copy) NSString *orderID;

@end
