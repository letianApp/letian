//
//  CounselorInfoViewController.m
//  letian
//
//  Created by J on 2017/3/2.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CounselorInfoViewController.h"

@interface CounselorInfoViewController ()

@property (nonatomic, strong) UIScrollView *mainScroview;
@property (nonatomic, strong) UITableView *mainTableview;


@end

@implementation CounselorInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAINCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatMainScroview];
    
    [self creatBottomBar];

    
//    [self creatMainTableview];
    
}

#pragma mark 创建主界面滚动视图
- (void)creatMainScroview{
    
    _mainScroview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_H/4, SCREEN_W, SCREEN_H/4*3-tabBar_H)];
    _mainScroview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScroview];
    
}

- (void)creatBottomBar {
    
    UITabBar *bar = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_H-tabBar_H, SCREEN_W, tabBar_H)];
    [self.view addSubview:bar];

}



# pragma mark 创建TableView
- (void)creatMainTableview {
    
    _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-tabBar_H) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTableview];
    _mainTableview.backgroundColor = MAINCOLOR;
    
}




- (void)viewWillDisappear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = NO;

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
