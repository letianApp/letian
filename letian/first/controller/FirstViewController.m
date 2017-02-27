//
//  FirstViewController.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "FirstViewController.h"
#import "YYCycleScrollView.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self customTabBar];
    
    self.navigationController.navigationBarHidden=YES;
    
    [self createScrollView];
    

}

#pragma mark 定制TabBar
- (void)customTabBar {
    
    self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[[UIImage imageNamed:@"firstPageTab"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"firstPageTabSel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarController.tabBar.tintColor = MAINCOLOR;
    
}

#pragma mark 定制首页轮播图
-(void)createScrollView
{
    
    YYCycleScrollView *cycleScrollView = [[YYCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 250) animationDuration:4.0];
    
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 250)];
        
        
        tempImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"index_slide_0%d.jpg",i+1]];
        tempImageView.contentMode = UIViewContentModeScaleAspectFill;
        tempImageView.clipsToBounds = true;
        [viewArray addObject:tempImageView];
    }
    [cycleScrollView setFetchContentViewAtIndex:^UIView *(NSInteger(pageIndex)) {
        return [viewArray objectAtIndex:pageIndex];
    }];
    [cycleScrollView setTotalPagesCount:^NSInteger{
        return 4;
    }];
    [cycleScrollView setTapActionBlock:^(NSInteger(pageIndex)) {
        
        NSLog(@"点击的相关的页面%ld",(long)pageIndex);
        
    }];
    
    [self.view addSubview:cycleScrollView];

    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
