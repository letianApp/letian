//
//  FirstViewController.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "FirstViewController.h"
#import "YYCycleScrollView.h"
#import "HomeCell.h"
#import "LoginViewController.h"

@interface FirstViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong)UIView *headBgView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self customTabBar];
    
    [self createHeadBgView];
    
    [self createTableView];
    
    
}



#pragma mark 定制TabBar


- (void)customTabBar {
    
    self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[[UIImage imageNamed:@"firstPageTab"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"firstPageTabSel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarController.tabBar.tintColor = MAINCOLOR;
    
}


-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableHeaderView=self.headBgView;
    
}

//头视图
-(void)createHeadBgView
{
    self.headBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 340)];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 220, SCREEN_W, 120)];
    
    NSArray *nameArray=@[@"- 咨询 -",@"- 文章 -",@"- 测试 -",@"- 活动 -"];
    for (NSInteger i=0; i<2; i++) {
        for (NSInteger j=0; j<2; j++) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/2*j, i*60, SCREEN_W/2, 60)];
            label.backgroundColor=[UIColor whiteColor];
            label.text=nameArray[j+i*2];
            label.textColor=[UIColor blackColor];
            label.textAlignment=NSTextAlignmentCenter;
            label.tag=j+i*2+100;
            
            label.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClicked:)];
            
            [label addGestureRecognizer:tap];
            
            [view addSubview:label];
            
        }
    }
    
    
    //模块分割线
    for (NSInteger i=0; i<2; i++) {
        UIView *horizontalLine=[[UIView alloc]initWithFrame:CGRectMake(30*(i+1)+i*((SCREEN_W-120)/2)+30*i, 60, (SCREEN_W-120)/2, 1)];
        horizontalLine.backgroundColor=MAINCOLOR;
        [view addSubview:horizontalLine];
        
        UIView *verticalLine=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_W/2, 20*i+20*(i+1)+i*20, 1, 20)];
        verticalLine.backgroundColor=MAINCOLOR;
        [view addSubview:verticalLine];
    }
    
    
    
    [self.headBgView addSubview:[self createScrollView]];
    
    [self.headBgView addSubview:view];
    
    [self createSearchBarOnView:self.headBgView];
    
    [self createmsgBtnOnView:self.headBgView];
    
}



-(void)labelClicked:(UITapGestureRecognizer *)tap
{
    
    NSLog(@"咨询页面");
    
}


#pragma mark 定制首页轮播图

-(YYCycleScrollView *)createScrollView
{
    
    YYCycleScrollView *cycleScrollView = [[YYCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 220) animationDuration:4.0];
    
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 4; i++) {
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 220)];
        
        
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
    
    
    
    
    return cycleScrollView;
    
}



#pragma mark 搜索栏
-(void)createSearchBarOnView:(UIView *)bgView
{
    UISearchBar * searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(100, 20, SCREEN_W-160, 40)];
    searchbar.delegate=self;
    searchbar.barStyle=UISearchBarStyleDefault;
    searchbar.searchBarStyle=UISearchBarStyleDefault;
    searchbar.placeholder=@"请输入关键字";
    [bgView addSubview:searchbar];
    
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
    [searchbar setBackgroundImage:searchBarBg];
    
    
}


#pragma mark ----创建消息按钮
-(void)createmsgBtnOnView:(UIView *)bgView
{
    
    UIButton *msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W-50, 25, 25, 25)];
    [msgBtn setImage:[UIImage imageNamed:@"mainMessageWhite"] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(msgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:msgBtn];
    
}


//消息按钮点击
-(void)msgBtnClick
{
    NSLog(@"进入消息按钮");
    
  
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertControl animated:YES completion:nil];

    // 2.实例化按钮:actionWithTitle
    [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        // 点击确定按钮的时候, 会调用这个block
        LoginViewController *loginVc=[[LoginViewController alloc]init];
//
//        loginVc.hidesBottomBarWhenPushed=YES;
//        
        [self.navigationController pushViewController:loginVc animated:YES];
        
//        [self presentViewController:loginVc animated:YES completion:nil];
        
        
        
    }]];
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];


    
    
    
}



#pragma mark -----------------tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

//cell定制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell=[HomeCell cellWithTableView:tableView];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


#pragma mark -----------------searchBarDelegate
//即将开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton=YES;
}


//点击返回按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
}


//点击搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
}


//实现搜索条背景透明化
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
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
