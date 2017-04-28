//
//  OrderListModel.h
//  letian
//
//  Created by 郭茜 on 2017/4/26.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject

@property(nonatomic,assign)NSInteger ConsultTimeLength;//咨询时长
@property(nonatomic,copy)NSString *DoctorName;//咨询师名称
@property(nonatomic,assign)NSInteger EnumOrderState;//订单状态
@property(nonatomic,copy)NSString *HeadImg;//咨询师头像
@property(nonatomic,assign)NSInteger IsCancel;//是否退款
@property(nonatomic,assign)NSInteger OrderID;//订单ID
@property(nonatomic,assign)NSInteger TotalFee;//订单价格
@property(nonatomic,copy)NSString *OrderNo;//订单号
@property(nonatomic,copy)NSString *AppointmentDate;//预约日期
@property(nonatomic,copy)NSString *CreatedDate;//订单创建时间
@property(nonatomic,copy)NSString *StartTime;//开始时间
@property(nonatomic,copy)NSString *EndTime;//结束时间
@property(nonatomic,assign)NSInteger EnumConsultType;//咨询方式

@end
