//
//  RegisterModel.h
//  letian
//
//  Created by 郭茜 on 2017/3/27.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterModel : NSObject

//昵称
@property(nonatomic,copy)NSString *NickName;
//手机号
@property(nonatomic,copy)NSString *Phone;
//密码
@property(nonatomic,copy)NSString *Password;
//短信验证码
@property(nonatomic,copy)NSString *VerifyCode;
//性别
@property(nonatomic,assign)NSInteger EnumSexType;
//注册用户类型
@property(nonatomic,assign)NSInteger EnumUserType;


@end
