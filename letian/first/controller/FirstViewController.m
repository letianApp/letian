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
#import "ArticleViewController.h"
#import "TestViewController.h"
#import "ActivityViewController.h"
#import "CustomCYLTabBar.h"
#import "ConsultViewController.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "TestListModel.h"
#import "CYUserManager.h"
#import "MessageViewController.h"
@interface FirstViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong)UIView *headBgView;

@property (nonatomic,strong) NSMutableArray <TestListModel *> *testList;

@end

@implementation FirstViewController


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;

}

-(NSMutableArray *)testList
{
    if (_testList == nil) {
        _testList = [NSMutableArray array];
    }
    return _testList;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    [self createHeadBgView];
    
    [self createTableView];
    
    [self requestData];
    
    
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


//请求套餐信息
-(void)requestData
{

    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:@"http://bapi.xinli001.com/ceshi/ceshis.json/?rows=10&offset=0&category_id=2&rmd=-1&key=86467ca472d76f198f8aa89d186fa85e"];
    
    __weak typeof(self) weakSelf = self;
    
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        weakSelf.testList=[TestListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

//头视图
-(void)createHeadBgView
{
    
    
    self.headBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 325)];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 220, SCREEN_W, 100)];
    
    NSArray *nameArray=@[@"- 咨询 -",@"- 文章 -",@"- 测试 -",@"- 活动 -"];
    for (NSInteger i=0; i<2; i++) {
        for (NSInteger j=0; j<2; j++) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/2*j, i*50, SCREEN_W/2, 50)];
            label.backgroundColor=[UIColor whiteColor];
            label.text=nameArray[j+i*2];
            label.textColor=MAINCOLOR;
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont boldSystemFontOfSize:17];
            label.tag=j+i*2+100;
            
            label.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClicked:)];
            
            [label addGestureRecognizer:tap];
            
            [view addSubview:label];
            
           
            
            
        }
    }
    
    
    
    //模块分割线
    for (NSInteger i=0; i<2; i++) {
        UIView *horizontalLine=[[UIView alloc]initWithFrame:CGRectMake(20*(i+1)+i*((SCREEN_W-100)/2)+40*i, 50, (SCREEN_W-100)/2, 1)];
        horizontalLine.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [view addSubview:horizontalLine];

        UIView *verticalLine=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_W/2, 15*i+15*(i+1)+i*15, 1, 20)];
        verticalLine.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [view addSubview:verticalLine];
    }
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 320, SCREEN_W, 5)];
    lineView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    [self.headBgView addSubview:lineView];
    
    [self.headBgView addSubview:[self createScrollView]];

    [self.headBgView addSubview:view];

    [self createSearchBarOnView:self.headBgView];

    [self createmsgBtnOnView:self.headBgView];

}



-(void)labelClicked:(UITapGestureRecognizer *)tap
{
    
//    跳到咨询页面
    if (tap.view.tag==100) {
        
        CustomCYLTabBar *tabBarControllerConfig = [[CustomCYLTabBar alloc] init];
        [UIApplication sharedApplication].delegate.window.rootViewController = tabBarControllerConfig.tabBarController;
        tabBarControllerConfig.tabBarController.selectedIndex = 1;
        
//    跳到文章
    }else if (tap.view.tag==101) {
        

        ArticleViewController *articleVc=[[ArticleViewController alloc]init];
        
        articleVc.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:articleVc animated:YES];
        
//    跳到测试
    }else if (tap.view.tag==102) {
        
        
        TestViewController *testVc=[[TestViewController alloc]init];
        
        testVc.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:testVc animated:YES];
        
//    跳到活动
    }else if (tap.view.tag==103){
        
        
        ActivityViewController *activityVc=[[ActivityViewController alloc]init];
        
        activityVc.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:activityVc animated:YES];
    }
    
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

//    已登陆
    if ([CYUserManager isHaveLogin]) {
        
        MessageViewController *messageVc=[[MessageViewController alloc]init];
        
        messageVc.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:messageVc animated:YES];
        
        
    }else{
        
//  未登录
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertControl animated:YES completion:nil];

    [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        LoginViewController *loginVc=[[LoginViewController alloc]init];
        
        loginVc.tabbarIndex=0;
        
        loginVc.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:loginVc animated:YES];
        
    }]];
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];


    }
    
    
}



#pragma mark -----------------tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.testList.count;
}

//cell定制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell=[HomeCell cellWithTableView:tableView];
    
    cell.titleLabel.text=self.testList[indexPath.row].title;
    
    cell.detailLabel.text=self.testList[indexPath.row].content;
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.testList[indexPath.row].cover]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
    ArticleViewController *articleVc=[[ArticleViewController alloc]init];
    
    articleVc.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:articleVc animated:YES];
    
    NSLog(@"cell被点击%li",indexPath.row);
    
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
