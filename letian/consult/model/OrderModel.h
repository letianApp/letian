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

typedef NS_ENUM (NSInteger, EnumSexType) {
    Male = 0,
    Female = 1,
    Other = 2,
    Error = 3,
};


@interface OrderModel : NSObject

/**
 咨询师名字
 */
@property (nonatomic, copy  ) NSString              *conserlorName;

/**
 咨询师ID
 */
@property (nonatomic        ) NSInteger             conserlorID;

/**
 * 选择咨询方式: 面对面咨询, 文字语音视频, 电话咨询
 * 默认面对面咨询
 */
@property (nonatomic        ) EnumConsultType       consultType;

/**
 咨询日期
 */
@property (nonatomic, copy  ) NSString              *orderDate;

/**
 咨询开始时间
 */
@property (nonatomic, copy  ) NSString              *orderDateTimeStart;

/**
 咨询结束时间
 */
@property (nonatomic, copy  ) NSString              *orderDateTimeEnd;

/**
 咨询价格
 */
@property (nonatomic        ) float                 orderPrice;

/*!
 咨询人名字
 */
@property (nonatomic, copy  ) NSString              *orderInfoName;

/*!
 咨询人性别: 男, 女, 其他
 */
@property (nonatomic, copy  ) NSString              *orderInfoSex;

/*!
 咨询人年龄
 */
@property (nonatomic        ) NSInteger             orderInfoAge;

/*!
 咨询人手机号
 */
@property (nonatomic, copy  ) NSString              *orderInfoPhone;

/*!
 咨询人Email
 */
@property (nonatomic, copy  ) NSString              *orderInfoEmail;

/*!
 咨询人备注
 */
@property (nonatomic, copy  ) NSString              *orderInfoDetail;

/**
 订单创建时间
 */
@property (nonatomic, copy  ) NSString              *orderCreatTime;

/*!
 订单当前状态
 */
@property (nonatomic, copy  ) NSString              *orderState;

/*!
 订单ID
 */
@property (nonatomic, copy  ) NSString              *orderID;

@end
