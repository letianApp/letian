//
//  ActiveModel.h
//  letian
//
//  Created by 郭茜 on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActiveModel : NSObject

@property(nonatomic,copy)NSString *ActiveTypeIDString;
@property(nonatomic,copy)NSString *CreatedDate;//
@property(nonatomic,copy)NSString *Description;//
@property(nonatomic,copy)NSString *EndDate;//
@property(nonatomic,copy)NSString *ArticleName;//
@property(nonatomic,copy)NSString *StartDate;//
@property(nonatomic,assign)NSInteger ActiveTypeID;//
@property(nonatomic,assign)NSInteger CreatedBy;//
@property(nonatomic,assign)NSInteger ID;//
@property(nonatomic,assign)NSInteger IsAbort;//
@property(nonatomic,copy)NSString *ArticleImg;
@property(nonatomic,copy)NSString *ArticleUrl;
@property(nonatomic,copy)NSString *Name;
@property(nonatomic,copy)NSString *ActiveImg;
@property(nonatomic,copy)NSString *ActiveUrl;




@end
