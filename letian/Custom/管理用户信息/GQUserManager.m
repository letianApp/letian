//
//  GQUserManager.m
//  KeepCarEasy
//
//  Created by guoqian on 16/8/4.
//  Copyright © 2016年 www.7eche.com. All rights reserved.
//

#import "GQUserManager.h"
#import "NSDictionary+Safe.h"

@implementation GQUserManager


/**
 *  获取UUID
 */
+(NSString *)getUserUniqueCode
{
    NSDictionary * codeDic = [[NSUserDefaults standardUserDefaults] objectForKey:kUniqueCode];
    
    if (!codeDic) {
        
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        
        CFRelease(uuidRef);
        
        NSString * code = (__bridge NSString *)(uuidStringRef);
        
        NSDictionary * dic = @{@"0":code};
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kUniqueCode];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return code;
    }
    
    NSString * key = [NSString stringWithFormat:@"%@",kFetchUserId];
    
    NSString * code = codeDic[key];
    
    if (!code) {
        
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        
        CFRelease(uuidRef);
        
        code = (__bridge NSString *)(uuidStringRef);
        
        NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithDictionary:codeDic];
        
        NSString * uid = [NSString stringWithFormat:@"%@",kFetchUserId];
        
        [newDic setObject:code forKey:uid];
        
        [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:kUniqueCode];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    return code;
}

/**
 *  保存用户基本信息
 */
+ (void)saveUserData:(NSDictionary *)infoDic andToken:(NSString *)token
{
    
    
    if (infoDic == nil || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSMutableDictionary * newDic = [[NSMutableDictionary alloc]init];
    
    [infoDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if (![obj isKindOfClass:[NSNull class]]) {
            
            [newDic setObject:obj forKey:key];
        }
        else
        {
            obj = @"";
            
            [newDic setObject:obj forKey:key];
        }
        
        
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:kUserInfoKey];
    
    NSString *userID = newDic[@"UserId"];
    
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kUserIdKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kTokenKey];
    
//    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kUserPasswordKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

/**
 *  获取用户基本信息
 */
- (void)fetchUser
{
    NSDictionary * infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKey];
    
    if (infoDic == nil || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.uid = [infoDic safeObjectForKey:@"UserId"];
    
    self.gender = [infoDic safeObjectForKey:@"SexString"];
    
    self.account = [infoDic safeObjectForKey:@"Account"];
    
    self.nickname = [infoDic safeObjectForKey:@"NickName"];
    
    self.token =  [infoDic safeObjectForKey:@"token"];

    self.email = [infoDic safeObjectForKey:@"Email"];
    
    self.mobile = [infoDic safeObjectForKey:@"MobilePhone"];
    
    self.enumUserType=[infoDic safeObjectForKey:@"EnumUserType"];
    
    //self.lastloginip = [infoDic safeObjectForKey:@"lastloginip"];
    
    //self.lastlogintime =[infoDic safeObjectForKey:@"lastlogintime"];
    
}


/**
 *  修改个人信息项目
 *
 */
+ (BOOL)editUserInfoByObj:(id)obj key:(NSString *)key
{
    
    NSDictionary * dict = [NSDictionary dictionaryWithDictionary:kFetchUserInfo];
    
    NSMutableDictionary * newDic = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [newDic setObject:obj forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:kUserInfoKey];
    
    BOOL b = [[NSUserDefaults standardUserDefaults] synchronize];
    
    return b;
}

/**
 *  判断是否已经登录
 */
+ (BOOL)isHaveLogin
{
    if (kFetchUserId != nil)
    {
        NSString * str = [NSString stringWithFormat:@"%@",kFetchUserId];
        if (![str isEqualToString:@"0"]) {
            return YES;
        }
        //        return YES;
    }
    return NO;
}

/**
 *  移除用户所有信息
 */
+ (void)removeAllUserInfo
{
    
    NSDictionary * codeDic = [[NSUserDefaults standardUserDefaults] objectForKey:kUniqueCode];
    
    NSMutableDictionary * newDci = [[NSMutableDictionary alloc]initWithDictionary:codeDic];
    
    NSString * code = [GQUserManager getUserUniqueCode];
    
    [newDci setObject:code forKey:@"0"];
    
    [[NSUserDefaults standardUserDefaults] setObject:newDci forKey:kUniqueCode];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserPasswordKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kUserIdKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kTokenKey];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserType];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserName];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserHeadImageUrl];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
