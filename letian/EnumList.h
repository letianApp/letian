//
//  EnumList.h
//  letian
//
//  Created by 郭茜 on 2017/5/6.
//  Copyright © 2017年 J. All rights reserved.
//

#ifndef EnumList_h
#define EnumList_h

typedef NS_ENUM(NSInteger,SharePlatformType)
{
    ShareTo_Sina           = 0,//新浪
    ShareTo_WechatSession  = 1,//微信聊天
    ShareTo_WechatTimeLine = 2,//微信朋友圈
    ShareTo_QQ             = 4,//QQ聊天页面
    ShareTo_Qzone          = 5,//qq空间
    ShareTo_Sms            = 13,//短信
};

typedef NS_ENUM(NSInteger,OrderState)
{
    AllOrder               = 100,//全部订单
    ConsultOrder           = 1,//预约订单
    WaitPayOrder           = 5,//待支付订单
    SuccessOrder           = 10,//已完成订单
};

#endif /* EnumList_h */
