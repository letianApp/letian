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
    NSArray *_mainClassifiedDataSource;
    NSArray *_counselorStatusDataSource;
    NSArray *_priceDataSource;
    
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
    
    _mainClassifiedDataSource = @[@"全部类型",@"自我成长",@"婚姻情感",@"孩子教育",@"职场心理",@"人际关系",@"情绪压力",@"神经症"];
    _counselorStatusDataSource = @[@"全部资历",@"首席",@"主任",@"专家",@"资深",@"心理咨询师"];
    _priceDataSource = @[@"全部价格",@"最低价",@"最高价"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self customClassifiedSectionBtnFotData:_mainClassifiedDataSource withLineNumber:0];
    [self customClassifiedSectionBtnFotData:_counselorStatusDataSource withLineNumber:1];
    [self customClassifiedSectionBtnFotData:_priceDataSource withLineNumber:2];

    [self customPriceSection];
    
}

//分类栏按钮
- (void)customClassifiedSectionBtnFotData:(NSArray *)dataArr withLineNumber:(int)n{
    
    UIScrollView *ParentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (statusBar_H + navigationBar_H)+n*navigationBar_H, SCREEN_W, navigationBar_H)];
    [self.view addSubview:ParentView];
    ParentView.backgroundColor = WEAKPINK;
    ParentView.showsHorizontalScrollIndicator = NO;
    ParentView.contentSize = CGSizeMake(dataArr.count * SCREEN_W/4 , navigationBar_H);
    ParentView.tag = 50+n;
    
    for (int i = 0; i < dataArr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/4*i+10, 8, SCREEN_W/4-12, navigationBar_H-16)];
        [btn setTitle:dataArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = MAINCOLOR.CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 15;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        btn.tag = n*100+i+1;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];

        [ParentView addSubview:btn];
    }
    [self beginningButtonSelectedWithTag:n*100 + 1];
    ParentView.contentSize = CGSizeMake(SCREEN_W/4 * dataArr.count , navigationBar_H);

}

//首按钮初始点击状态
- (void)beginningButtonSelectedWithTag:(int)tagg {
    
    UIButton *beginningButton = [self.view viewWithTag:tagg];
    beginningButton.selected = YES;
    beginningButton.backgroundColor = MAINCOLOR;
}

//点击按钮方法
- (void)clickBtn:(UIButton *)btn {

    if (btn.tag < 100) {
        for (int i = 1; i < _mainClassifiedDataSource.count+1; i++) {
            UIButton *btnn = [self.view viewWithTag:i];
            btnn.selected = NO;
            btnn.backgroundColor = [UIColor whiteColor];
        }
    }
    else if (btn.tag < 200) {
        for (int i = 1; i < _counselorStatusDataSource.count+1; i++) {
            UIButton *btnn = [self.view viewWithTag:i+100];
            btnn.selected = NO;
            btnn.backgroundColor = [UIColor whiteColor];
        }
    }
    
    btn.selected = YES;
    btn.backgroundColor = MAINCOLOR;
}

//定制价格栏
- (void)customPriceSection {
    
    UIScrollView *scroview = [self.view viewWithTag:52];
    
    UIButton *minPriceBtn = [self.view viewWithTag:202];
    minPriceBtn.backgroundColor = [UIColor whiteColor];
    minPriceBtn.selected = NO;
    [minPriceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [minPriceBtn removeTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    minPriceBtn.frame = CGRectMake(SCREEN_W/4+10, 8, SCREEN_W/4, navigationBar_H-16);

    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/2+20, navigationBar_H/2, 20, 2)];
    [scroview addSubview:line];
    line.backgroundColor = MAINCOLOR;
    
    UIButton *maxPriceBtn = [self.view viewWithTag:203];
    maxPriceBtn.backgroundColor = [UIColor whiteColor];
    maxPriceBtn.selected = NO;
    [maxPriceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [maxPriceBtn removeTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    maxPriceBtn.frame = CGRectMake(SCREEN_W/2+50, 8, SCREEN_W/4, navigationBar_H-16);
    
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
