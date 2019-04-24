//
//  API.h
//  letian
//
//  Created by 郭茜 on 16/7/14.
//  Copyright © 2016年 www.7eche.com. All rights reserved.
//

#ifndef API_h
#define API_h

//域名
#define API_HTTP_PREFIX              @"https://webapi.rightpsy.com/api/"

//图片域名
#define API_HTTP_IMAGEPREFIX         @"http://image.rightpsy.com/api/"


//============模块============


//用户
#define API_MODULE_USER              @"User"

//工具类
#define API_MODULE_UTILS             @"Utils"

//咨询
#define API_MODULE_CONSULT           @"Consult"

//咨询师设置
#define API_MODULE_DOCTORSET         @"DoctorSet"

//活动
#define API_MODULE_ACTIVE            @"Active"

//文章
#define API_MODULE_ARTICLE           @"Article"

//网页文章
#define API_MODULE_WEBARTICLE        @"WebArticle"

//消息
#define API_MODULE_MESSAGE           @"Message"

//地区
#define API_MODULE_REGION            @"Region"




//============接口名称============

//上传头像
#define API_NAME_UPLOADPHOTO         @"UploadPhoto"


//修改昵称
#define API_NAME_CHANGENICKNAME      @"ModifyNickName"

//修改性别
#define API_NAME_CHANGESEX           @"ModifyUserSex"

//修改性别
#define API_NAME_CHANGEBIRTHDAY           @"ModifyUserBirthday"

//绑定手机
#define API_NAME_BINDINGPHONE        @"BindMobilePhone"

//用户注册
#define API_NAME_REGISTER            @"Register"

//发送验证码
#define API_NAME_SENDMSG             @"SendShortMsgByTypeID"

//验证验证码
#define API_NAME_CHECKCODE           @"CheckShortMsgCode"

//登录
#define API_NAME_LOGIN               @"Login"

//验证码登录
#define API_NAME_LOGINBYSMS               @"LoginBySmsCode"

//忘记密码
#define API_NAME_FORGETPW            @"ForgetPwd"

//修改密码
#define API_NAME_CHANGEPW            @"ModifyPassword"

//获取用户信息
#define API_NAME_GETUSERINFO         @"GetUserInfo"

//获取活动列表
#define API_NAME_GETACTIVELIST       @"GetActiveList"

//根据活动类型获取活动列表
#define API_NAME_GETACTIVELISTBYTYPE @"GetActiveListByTypeID"

//获取活动详情
#define API_NAME_GETACTIVEINFO       @"GetActiveInfo"

//消息推送
#define API_NAME_SETPOSTACTIVE       @"SetPostActive"

//获取心理健康专栏类别
#define API_NAME_GETWEBARCTIVECATE   @"GetWebArticleCateList"

//获取文章列表
#define API_NAME_GETWEBARTICLELIST   @"GetWebArticleList"

//获取文章详情
#define API_NAME_GETWEBACTIVEL       @"GetWebArticleInfo"

//获取精选文章列表
#define API_NAME_GETARTICLELIST     @"GetArticleList"

//获取一篇精选文章模型
#define API_NAME_GETARTICLEINFO @"GetArticleInfo"

//点赞精选文章或评论
#define API_NAME_DOARTICLEPRAISE @"DoArticlePraise"

//获取精选文章评论列表
#define API_NAME_GETARTICLECOMMIT @"GetArticleCommonetList"

//评论文章
#define API_NAME_DOARTICLECOMMIT @"DoArticleCommentReply"

//获取咨询师类型
#define API_NAME_GETCONSULTTITLELIST  @"GetUserPsyAndTitleList"

//获取咨询师所属区域列表
#define API_NAME_GETBUSINESSREGIN @"GetBusinessRegion"

//获取咨询师价格规则
#define API_NAME_GETCONSULFEELIST  @"GetConsultFeeList"

//获取咨询师列表
#define API_NAME_GETCONSULTLIST @"GetConsultDoctorList"

//获取咨询师详情
#define API_NAME_GETCONSULTINFO @"GetConsultDoctorInfo"

//获取咨询师感谢信
#define API_NAME_GETUSERLETTER @"GetUserLetterList"

//获取咨询师在某个月份的咨询情况和设置信息
#define API_NAME_GETCONSULTSETFORMONTH @"GetMonthCousultListInfo"

//获取咨询师在某天的咨询情况和设置信息
#define API_NAME_GETCONSULTSETFORDAY @"GetDayConsultInfo"

//咨询师设置咨询时间段
#define API_NAME_DOSETCONSULTSET @"DoSetDoctorConsultDate"

//提交订单
#define API_NAME_POSTORDER           @"DoConsultAppointment"

//微信预支付
#define API_NAME_WECHATPAY           @"GetTencentParams"

//检查支付宝状态
#define API_NAME_CHECKALIPAY         @"CheckAliParamsState"

//获取订单列表
#define API_NAME_GETORDERLIST        @"GetMyConsultList"

//获取订单详情
#define API_NAME_GETORDERINFO        @"GetConsultOrderInfo"

//取消订单
#define API_NAME_DOCANCELORDER       @"DoCancelConsultOrder"

//申请退款
#define API_NAME_REFUNDORDER         @"DoBackConsultOrder"

//咨询师修改订单为已完成状态
#define API_NAME_FINISHORDER         @"DoFinishConsultOrder"

//添加感谢信
#define API_NAME_ADDUSERLETTER       @"AddUserLetter"

//系统消息列表
#define API_NAME_GETMESSAGELIST      @"GetMessageList"


#endif /* API_h */
