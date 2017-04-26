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

@end
