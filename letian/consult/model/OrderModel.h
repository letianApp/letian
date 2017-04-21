//
//  OrderModel.h
//  letian
//
//  Created by J on 2017/3/22.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, EnumConsultType) {
    FaceToFace = 1,
    Chat = 11,
    PhoneTalk = 21,
};

@interface OrderModel : NSObject

/**
 咨询师名字
 */
@property (nonatomic, copy    ) NSString              *conserlorName;

/**
 咨询师ID
 */
@property (nonatomic, assign  ) NSInteger             conserlorID;

/**
 * 选择咨询方式: 面对面咨询, 文字语音视频, 电话咨询
 * 默认面对面咨询
 */
@property (nonatomic, assign  ) EnumConsultType       consultType;

/**
 咨询日期
 */
@property (nonatomic, copy    ) NSDate                *orderDate;

/**
 咨询开始时间
 */
@property (nonatomic, copy  ) NSString        *orderDateTimeStart;

/**
 咨询结束时间
 */
@property (nonatomic, copy  ) NSString        *orderDateTimeEnd;

/**
 咨询价格
 */
@property (nonatomic, assign  ) float                 orderPrice;

/*!
 个人信息
 */
@property (nonatomic, copy    ) NSString              *orderInfoName;
@property (nonatomic, copy    ) NSString              *orderInfoSex;
@property (nonatomic, copy    ) NSString              *orderInfoAge;
@property (nonatomic, copy    ) NSString              *orderInfoPhone;
@property (nonatomic, copy    ) NSString              *orderInfoEmail;

/**
 订单创建时间
 */
@property (nonatomic, copy    ) NSString              *orderCreatTime;

/*!
 订单当前状态
 */
@property (nonatomic, copy    ) NSString              *orderState;

/*!
 订单ID
 */
@property (nonatomic, copy    ) NSString              *orderID;

@end
