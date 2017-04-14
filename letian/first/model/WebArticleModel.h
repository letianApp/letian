//
//  WebArticleModel.h
//  letian
//
//  Created by 郭茜 on 2017/4/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebArticleModel : NSObject

@property(nonatomic,copy)NSString *Abstract;//

@property(nonatomic,copy)NSString *Content;//

@property(nonatomic,copy)NSString *CreatedBy;//

@property(nonatomic,copy)NSString *OriginalUrl;//

@property(nonatomic,copy)NSString *PostDate;//

@property(nonatomic,copy)NSString *Title;//



@property(nonatomic,assign)NSInteger ID;//

@property(nonatomic,assign)NSInteger ReadNum;//


@end
