//
//  OrderInfoModel.h
//  letian
//
//  Created by 郭茜 on 2017/5/7.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfoModel : NSObject

@property(nonatomic,copy)NSString *ConsultTime;//咨询时间

@property(nonatomic,copy)NSString *ConsultTypeIDString;//咨询方式

@property(nonatomic,copy)NSString *DoctorName;//咨询师名字

@property(nonatomic,assign)NSInteger EnumOrderState;//订单状态

@property(nonatomic,copy)NSString *EnumOrderStateString;//订单状态

@property(nonatomic,assign)NSInteger IsCancel;//是否取消

@property(nonatomic,assign)NSInteger OrderID;//订单ID

@property(nonatomic,copy)NSString *OrderNo;//订单号

@property(nonatomic,copy)NSString *PayDate;//支付时间

@property(nonatomic,assign)NSInteger PayType;//支付方式

@property(nonatomic,copy)NSString *PayTypeString;//支付方式

@property(nonatomic,assign)CGFloat TotalFee;//订单金额

@property(nonatomic,copy)NSString *UserName;//咨客名称

@property(nonatomic,copy)NSString *DoctorHeadImg;//咨询师头像

@property(nonatomic,copy)NSString *UserHeadImg;//咨客头像





@end
