//
//  CounselorInfoViewController.m
//  letian
//
//  Created by J on 2017/3/2.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CounselorInfoViewController.h"

@interface CounselorInfoViewController ()


@property (nonatomic, weak) UIView *navigationView;



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
    
    [self setupNavigationView];
    
    [self creatMainScroview];
    
    [self creatBottomBar];

    
//    [self creatMainTableview];
    
}

#pragma mark 返回按钮
- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"whiteback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 25, 25)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
    
}

- (void)setupNavigationView
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    navigationView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, SCREEN_W, 20)];
    titleLabel.text = @"孙晓平";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:titleLabel];
    
    navigationView.alpha = 0;
    [self.view addSubview:navigationView];
    self.navigationView = navigationView;
}


#pragma mark 创建主界面滚动视图
- (void)creatMainScroview{
    
    _mainScroview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_H/3, SCREEN_W, SCREEN_H/4*3-tabBar_H)];
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
