//
//  ConsultViewController.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ConsultViewController.h"

@interface ConsultViewController ()

{
    UIScrollView *_classifiedSectionFirstLine;
    NSArray *_firstLineDataSource;
    
}



@end

@implementation ConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavigation];
    [self creatClassifiedSection];
    
    
    
}

#pragma mark 定制TabBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customTabBar];
    }
    return self;
}

- (void)customTabBar {
    
    self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"咨询" image:[[UIImage imageNamed:@"consultPagTab"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"consultPagTabSel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
}

#pragma mark 定制Navigation
- (void)customNavigation {
    
    self.navigationController.navigationBar.tintColor = MAINCOLOR;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/2, 40)];
    searchBar.placeholder = @"搜索";
    self.navigationItem.titleView = searchBar;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"乐天心理" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"mainMessage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(selRightButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)selRightButton {
    
}

#pragma mark 创建分类栏
- (void)creatClassifiedSection {
    
    _firstLineDataSource = @[@"自我成长",@"婚姻情感",@"孩子教育",@"职场心理",@"人际关系",@"情绪压力",@"神经症"];
    
    _classifiedSectionFirstLine = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBar_H + navigationBar_H, SCREEN_W, navigationBar_H)];
    [self.view addSubview:_classifiedSectionFirstLine];
    _classifiedSectionFirstLine.backgroundColor = WEAKPINK;
    _classifiedSectionFirstLine.showsHorizontalScrollIndicator = NO;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [btn setTitle:_firstLineDataSource[0] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
        [btn addTarget:self action:@selector(selRightButton) forControlEvents:UIControlEventTouchUpInside];
    [_classifiedSectionFirstLine addSubview:btn];
    
    
    //    [self customClassifiedSectionBtnFotData:_firstLineDataSource withParentView:_classifiedSectionFirstLine];
    
    
}

- (void)customClassifiedSectionBtnFotData:(NSArray *)dataArr withParentView:(UIView *)ParentView {
    
    for (int i = 0; i < dataArr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/4 * i, 0, 100, 44)];
        [btn setTitle:dataArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ParentView addSubview:btn];
        
    }
    
    
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
