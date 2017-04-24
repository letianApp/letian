//
//  TestListModel.h
//  letian
//
//  Created by 郭茜 on 2017/3/22.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestListModel : NSObject

@property(nonatomic,copy)NSString *title;//测试标题
@property(nonatomic,copy)NSString *content;//测试详情
@property(nonatomic,copy)NSString *absolute_url;//测试网址
@property(nonatomic,copy)NSString *cover;//图片

@end
