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
#import "ActiveModel.h"
#import "GQUserManager.h"
#import "SystomMsgViewController.h"
#import "TestDetailViewController.h"
#import "GQScrollView.h"
#import "ActivityDetailViewController.h"
#import "FunnyViewController.h"
@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *sectionHeaderLabel;
@property(nonatomic,strong)NSMutableArray <ActiveModel *> *funnyListArray;
@property(nonatomic,assign)NSInteger pageIndex;

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

-(NSMutableArray *)funnyListArray
{
    if (_funnyListArray == nil) {
        _funnyListArray = [NSMutableArray array];
    }
    return _funnyListArray;
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
    return self.funnyListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *funnyTestModuleLabel=[GQControls createLabelWithFrame:CGRectMake(0, 0, SCREEN_W, 40) andText:@"．·°∴ ☆．．·°．·°∴乐天派 ☆．．·°∴ ☆．．·° " andTextColor:MAINCOLOR andFontSize:15];
    funnyTestModuleLabel.backgroundColor=[UIColor colorWithRed:247/255.0 green:235/255.0 blue:242/255.0 alpha:0.5];
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
        self.navigationItem.title = @"乐天派";
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
    cell.titleLabel.text=self.funnyListArray[indexPath.row].Name;
    cell.detailLabel.text=self.funnyListArray[indexPath.row].Description;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.funnyListArray[indexPath.row].ActiveImg]];

    
    return cell;
}
#pragma mark------cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    FunnyViewController *funnyVc=[[FunnyViewController alloc]init];
    funnyVc.activeModel=self.funnyListArray[indexPath.row];
    funnyVc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:funnyVc animated:NO];
}


#pragma mark------获取趣味列表

-(void)requestData
{
    self.pageIndex=1;
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_ACTIVE];
    [requestString appendString:API_NAME_GETACTIVELIST];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"pageIndex"]=@(self.pageIndex);
    params[@"pageSize"]=@(40);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.funnyListArray=[ActiveModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
        NSArray *deleArray=[NSArray arrayWithArray:weakSelf.funnyListArray];
        for (ActiveModel *model in deleArray) {
            if (model.ActiveTypeID==11) {
                [weakSelf.funnyListArray removeObject:model];
            }
        }
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
    UIView *headBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 105+SCREEN_W*0.6)];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_W*0.6, SCREEN_W, 100)];
    NSArray *nameArray=@[@"- 预约咨询 -",@"- 心理专栏 -",@"- 专业测试 -",@"- 智慧学院 -"];
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
        if (![GQUserManager isHaveLogin]) {
//            NSLog(@"登录一下");
            //未登录
            UIAlertController *alertControl  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self) weakSelf = self;
            [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                LoginViewController *loginVc = [[LoginViewController alloc]init];
                loginVc.hidesBottomBarWhenPushed = YES;
                [weakSelf presentViewController:loginVc animated:YES completion:nil];
            }]];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertControl animated:YES completion:nil];

        }else{

            TestViewController *testVc=[[TestViewController alloc]init];
            testVc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:testVc animated:NO];
        }
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
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"index_%d",i+1]];
        [imageArray addObject:image];
        
    }
    
    GQScrollView *scrollView = [[GQScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W*0.6) withImages:imageArray withIsRunloop:YES withBlock:^(NSInteger index) {
//        NSLog(@"点击了index%zd",index);
        //跳到咨询页面
        if (index==0) {
            self.tabBarController.selectedIndex=1;
            //跳到文章列表
        }else if (index==1) {
            CategoryViewController *articleVc=[[CategoryViewController alloc]init];
            articleVc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:articleVc animated:NO];
            //跳到测试
        }else if (index==2) {
            if (![GQUserManager isHaveLogin]) {
//                NSLog(@"登录一下");
                //未登录
                UIAlertController *alertControl  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
                __weak typeof(self) weakSelf = self;
                [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    
                    LoginViewController *loginVc = [[LoginViewController alloc]init];
                    loginVc.hidesBottomBarWhenPushed = YES;
                    [weakSelf presentViewController:loginVc animated:YES completion:nil];
                }]];
                [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                
                [self presentViewController:alertControl animated:YES completion:nil];
                
            }else{
                
                TestViewController *testVc=[[TestViewController alloc]init];
                testVc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:testVc animated:NO];
            }
            //跳到活动
        }else if (index==3){
            ActivityListViewController *activityVc=[[ActivityListViewController alloc]init];
            activityVc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:activityVc animated:YES];
        }

    
    }];
    
   
    scrollView.color_currentPageControl = MAINCOLOR;
    
    
    
    
    return scrollView;
}

//
////是否可以旋转
//- (BOOL)shouldAutorotate
//{
//    return false;
// }
////支持的方向
// -(UIInterfaceOrientationMask)supportedInterfaceOrientations
// {
//    return UIInterfaceOrientationMaskPortrait;
// }
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
