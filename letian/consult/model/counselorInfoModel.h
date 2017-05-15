//
//  counselorInfoModel.h
//  letian
//
//  Created by J on 2017/2/28.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface counselorInfoModel : NSObject

/**
 咨询师ID
 */
@property (nonatomic, assign) NSInteger UserID;

/**
 咨询师名字
 */
@property (nonatomic, copy  ) NSString  *UserName;

/**
 咨询师性别
 */
@property (nonatomic, assign) NSInteger  EnumSexType;

/**
 咨询师级别
 */
@property (nonatomic, copy  ) NSString  *UserTitleString;

/**
 咨询师级别ID
 */
@property (nonatomic, copy  ) NSString  *UserTitleID;

/**
 咨询师图片
 */
@property (nonatomic, copy  ) NSString  *HeadImg;

/**
 咨询师简介
 */
@property (nonatomic, copy  ) NSString  *Description;

/**
 咨询师擅长领域
 */
@property (nonatomic, copy  ) NSString  *Expertise;

/**
 咨询师资讯特点
 */
@property (nonatomic, copy  ) NSString  *Specific;

/**
 咨询师咨询理念
 */
@property (nonatomic, copy  ) NSString  *Idea;

/**
 咨询师价格
 */
@property (nonatomic, assign) NSInteger  ConsultFee;

/**
 咨询师折扣
 */
@property (nonatomic, assign) float      ConsultDisCount;

/**
 咨询师达到多少时间有折扣
 */
@property (nonatomic, assign) NSInteger  ConsultPreferDateLength;

/**
 咨询师折扣Tag
 */
@property (nonatomic, copy ) NSString  *ConsultTag;

/**
 咨询师总咨询次数
 */
@property (nonatomic, copy  ) NSString  *TotalConsultCount;



@end
