//
//  CommitModel.h
//  letian
//
//  Created by J on 2018/7/11.
//  Copyright © 2018年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommitModel : NSObject

@property (nonatomic, assign) NSInteger ArticleID;
@property (nonatomic, copy) NSString *CreatedByString;
@property (nonatomic, copy) NSString *HeadImg;
@property (nonatomic, copy) NSString *CreatedDate;
@property (nonatomic, assign) NSInteger RefferID;
@property (nonatomic, copy) NSString *CommentContent;
@property (nonatomic, assign) NSInteger PraiseCount;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger IsCurUserPraise;


@end
