//
//  selectionArticleVC.h
//  letian
//
//  Created by J on 2018/6/21.
//  Copyright © 2018年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectionArticleVC : UIViewController

@property (nonatomic, copy) NSString *ArticleUrl;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *ArticleTitle;
@property (nonatomic, copy) NSString *CreatedByString;
@property (nonatomic, copy) NSString *ArticleImg;
@property (nonatomic) BOOL fromPush;




@end
