//
//  TestDetailViewController.h
//  letian
//
//  Created by 郭茜 on 2017/3/22.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestListModel.h"

@interface TestDetailViewController : UIViewController

@property(nonatomic,strong)TestListModel *testModel;
@property(nonatomic,copy)NSString *testUrl;//测试网址



@end
