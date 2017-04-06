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
#define API_HTTP_PREFIX            @"http://121.41.11.23:8080/api/"





//============模块============


//用户
#define API_MODULE_USER        @"User"
//工具类
#define API_MODULE_UTILS       @"Utils"
//咨询
#define API_MODULE_CONSULT     @"Consult"
//活动
#define API_MODULE_ACTIVE      @"Active"
//文章
#define API_MODULE_ARTICLE     @"Article"





//============接口名称============

//用户注册
#define API_NAME_REGISTER      @"Register"

//发送验证码
#define API_NAME_SENDMSG       @"SendShortMsgByTypeID"

//验证验证码
#define API_NAME_CHECKCODE     @"CheckShortMsgCode"

//登录
#define API_NAME_LOGIN         @"Login"

//忘记密码
#define API_NAME_FORGET         @"ForgetPwd"







#endif /* API_h */
