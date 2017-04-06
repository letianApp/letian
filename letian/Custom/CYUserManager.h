//
//  CYUserManager.h
//  KeepCarEasy
//
//  Created by 恽雨晨 on 16/8/4.
//  Copyright © 2016年 www.7eche.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYUserManager : NSObject

/* Account = 15161170944;
 HeadImage = "http://image.7eche.com/201604162247493063.jpg";
 IsValidate = 0;
 Money = 0;
 MsgCount = 0;
 NickName = OMG;
 Point = 0;
 Sex = 1;
 ShareMoney = 30;
 UserId = 2603;
 */
//用户基本信息
@property(nonatomic,strong)NSString * uid;//用户ID

@property(nonatomic,strong)NSString * token; //用户token

@property(nonatomic,strong)NSString * account;//用户名

@property(nonatomic,strong)NSString * nickname;//昵称

@property(nonatomic,strong)NSString * email;//邮箱

@property(nonatomic,strong)NSString * mobile;//手机号码

@property(nonatomic,strong) NSString *headerimage;//头像

@property(nonatomic,strong)NSString * lastloginip;//上次登录

@property(nonatomic,strong)NSString * lastlogintime;//上次登录时间戳

@property(nonatomic,strong)NSString * gender;//性别
/**
 *  获取UUID
 */
+(NSString *)getUserUniqueCode;

/**
 *  保存用户基本信息
 */
+ (void)saveUserData:(NSDictionary *)infoDic andToken:(NSString *)token;

/**
 *  移除所有用户数据
 */
+ (void)removeAllUserInfo;

/**
 *  判断是否已经登录
 *
 *  @return YES or NO
 */
+ (BOOL)isHaveLogin;

/**
 *  获取用户基本信息
 */
- (void)fetchUser;

/**
 *  修改个人信息项目
 */
+ (BOOL)editUserInfoByObj:(id)obj key:(NSString *)key;

@end
