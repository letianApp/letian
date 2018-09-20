//
//  UserLetterModel.h
//  letian
//
//  Created by J on 2018/9/19.
//  Copyright © 2018年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLetterModel : NSObject

/**
 用户名
 */
@property (nonatomic, copy) NSString *CreatedByString;

/**
 详细评论
 */
@property (nonatomic, copy) NSString *LetterContent;

/**
 详细时间
 */
@property (nonatomic, copy) NSString *CreatedDate;

/**
 头像
 */
@property (nonatomic, copy) NSString *HeadImg;



@end
