//
//  UserInfoModel.h
//  letian
//
//  Created by 郭茜 on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property(nonatomic,copy)NSString *Email;
@property(nonatomic,assign)NSInteger EnumSexType;
@property(nonatomic,copy)NSString *HeadImg;//头像
@property(nonatomic,copy)NSString *MobilePhone;
@property(nonatomic,copy)NSString *NickName;
@property(nonatomic,copy)NSString *SexString;//性别
@property(nonatomic,assign)NSInteger UserID;
@property(nonatomic,copy)NSString *EnumUserType;//身份
@property(nonatomic,copy)NSString *Birhtday;
@property(nonatomic,copy)NSString *CompanyString;

@end
