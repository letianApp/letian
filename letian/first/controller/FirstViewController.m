//
//  FirstViewController.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "FirstViewController.h"
#import "HomeCell.h"
#import "LoginViewController.h"
#import "CategoryViewController.h"
#import "TestViewController.h"
#import "ActivityListViewController.h"
#import "CustomCYLTabBar.h"
#import "ConsultViewController.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "TestListModel.h"
#import "GQUserManager.h"
#import "SystomMsgViewController.h"
#import "TestDetailViewController.h"
#import "GQScrollView.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *sectionHeaderLabel;
@property (nonatomic,strong) NSMutableArray <TestListModel *> *testList;

@end

@implementation FirstViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (self.tableView.contentOffset.y >= 220) {

        return UIStatusBarStyleDefault;
    } else {
        
        return UIStatusBarStyleLightContent;
    }
}

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
    
    [self createTableView];
    
    [self requestData];
    
    [self setUpRefresh];
    
}

#pragma mark-------下拉刷新

-(void)setUpRefresh
{
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark-------创建TableView

-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-49) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableHeaderView=[self createHeadBgView];
    UILabel *footLabel=[GQControls createLabelWithFrame:CGRectMake(0, 0, SCREEN_W, 30) andText:@"没有更多内容咯～" andTextColor:MAINCOLOR andFontSize:10];
    footLabel.textAlignment=NSTextAlignmentCenter;
    self.tableView.tableFooterView=footLabel;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.testList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *funnyTestModuleLabel=[GQControls createLabelWithFrame:CGRectMake(0, 0, SCREEN_W, 40) andText:@"**** 趣味小测试 ****" andTextColor:MAINCOLOR andFontSize:15];
    funnyTestModuleLabel.backgroundColor=WEAKPINK;
    funnyTestModuleLabel.textAlignment=NSTextAlignmentCenter;
    self.sectionHeaderLabel=funnyTestModuleLabel;
    return self.sectionHeaderLabel;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self setNeedsStatusBarAppearanceUpdate];
    if (self.tableView.contentOffset.y >= 325) {
        
        self.sectionHeaderLabel.hidden = YES;
        self.navigationItem.title = @"趣味心理测试";
        self.navigationController.navigationBarHidden = NO;
    }else{
        
        self.sectionHeaderLabel.hidden = NO;
        self.navigationController.navigationBarHidden = YES;
    }
}



#pragma mark------cell定制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell=[HomeCell cellWithTableView:tableView];
    cell.titleLabel.text=self.testList[indexPath.row].title;
    cell.detailLabel.text=self.testList[indexPath.row].content;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.testList[indexPath.row].cover]];
    return cell;
}
#pragma mark------cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    TestDetailViewController *articleVc=[[TestDetailViewController alloc]init];
    articleVc.testUrl=self.testList[indexPath.row].absolute_url;
    articleVc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:articleVc animated:NO];
}


#pragma mark------获取趣味测试列表

-(void)requestData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:@"http://bapi.xinli001.com/ceshi/ceshis.json/?rows=50&offset=0&category_id=2&rmd=-1&key=86467ca472d76f198f8aa89d186fa85e"];
    __weak typeof(self) weakSelf = self;
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBHudSet dismiss:self.view];
        weakSelf.testList=[TestListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}


#pragma mark------头视图

-(UIView *)createHeadBgView
{
    UIView *headBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 325)];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 220, SCREEN_W, 100)];
    NSArray *nameArray=@[@"- 预约咨询 -",@"- 心理专栏 -",@"- 专业测试 -",@"- 沙龙活动 -"];
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
        UIView *horizontalLine=[GQControls createViewWithFrame:CGRectMake(20*(i+1)+i*((SCREEN_W-100)/2)+40*i, 50, (SCREEN_W-100)/2, 1) andBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [view addSubview:horizontalLine];
        
        UIView *verticalLine=[GQControls createViewWithFrame:CGRectMake(SCREEN_W/2, 15*i+15*(i+1)+i*15, 1, 20) andBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [view addSubview:verticalLine];
    }
    [headBgView addSubview:[self createScrollView]];
    [headBgView addSubview:view];
    return headBgView;
}


#pragma mark------点击头视图模块

-(void)labelClicked:(UITapGestureRecognizer *)tap
{
    //跳到咨询页面
    if (tap.view.tag==100) {
        self.tabBarController.selectedIndex=1;
    //跳到文章列表
    }else if (tap.view.tag==101) {
        CategoryViewController *articleVc=[[CategoryViewController alloc]init];
        articleVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:articleVc animated:NO];
    //跳到测试
    }else if (tap.view.tag==102) {
       TestViewController *testVc=[[TestViewController alloc]init];
        testVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:testVc animated:NO];
    //跳到活动
    }else if (tap.view.tag==103){
        ActivityListViewController *activityVc=[[ActivityListViewController alloc]init];
        activityVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:activityVc animated:YES];
    }
}


#pragma mark 轮播图

-(GQScrollView *)createScrollView
{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"index_slide_0%d.jpg",i+1]];
        [imageArray addObject:image];
    }
    GQScrollView *scrollView = [[GQScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 220) withImages:imageArray withIsRunloop:YES withBlock:^(NSInteger index) {
        NSLog(@"点击了index%zd",index);
    }];
    scrollView.color_currentPageControl = MAINCOLOR;
    return scrollView;
}



#pragma mark------特效

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    CATransform3D rotation;
//    rotation = CATransform3DMakeRotation((90.0*M_PI/180), 0.0, 0.7, 0.4);
//    rotation.m44 = 1.0/-600;
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    cell.layer.transform = rotation;
//    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
//    [UIView beginAnimations:@"rotaion" context:NULL];
//    [UIView setAnimationDuration:0.3];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
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
