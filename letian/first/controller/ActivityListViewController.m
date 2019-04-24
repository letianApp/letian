//
//  ActivityListViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityCell.h"
#import <WebKit/WebKit.h>
#import "ActiveModel.h"
#import "MJExtension.h"
#import "ActivityDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "AboutViewController.h"
#import "ActiveUrlVC.h"



@interface ActivityListViewController ()<WKNavigationDelegate,WKUIDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong)NSMutableArray <ActiveModel *> *activeListArray;

@property (nonatomic,strong) WKWebView *webView;
@property(nonatomic,assign)NSInteger pageIndex;


@end

@implementation ActivityListViewController

-(NSMutableArray *)activeListArray
{
    if (_activeListArray == nil) {
        _activeListArray = [NSMutableArray array];
    }
    return _activeListArray;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setUpNavigationBar];
    
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
    self.tableview.mj_header = header;
    self.tableview.mj_header.automaticallyChangeAlpha = YES;
    self.tableview.mj_footer.hidden = YES;
    self.tableview.mj_footer = [RefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    self.tableview.mj_footer.hidden = YES;

}

#pragma mark-------获取活动列表

- (void)requestData {
    self.pageIndex=1;
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_ACTIVE];
    [requestString appendString:@"GetActiveList"];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"pageIndex"] = @(self.pageIndex);
    params[@"pageSize"] = @(10);
//    params[@"enumActiveType"] = @(11);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
//        NSLog(@"乐园：%@",responseObject);
        [weakSelf.tableview.mj_header endRefreshing];
        weakSelf.activeListArray = [ActiveModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
        if (weakSelf.activeListArray.count >= 10) {
            weakSelf.tableview.mj_footer.hidden = NO;
        }else{
            weakSelf.tableview.mj_footer.hidden=YES;
        }

        [_tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [MBHudSet dismiss:self.view];
        
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}

-(void)requestMoreData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_ACTIVE];
    [requestString appendString:API_NAME_GETACTIVELISTBYTYPE];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"pageIndex"]=@(++self.pageIndex);
    params[@"pageSize"]=@(10);
    params[@"enumActiveType"]=@(11);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        NSArray *array = [ActiveModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
        if (array.count >= 10) {
            weakSelf.tableview.mj_footer.hidden = NO;
            [weakSelf.tableview.mj_footer endRefreshing];
        }else{
            [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.activeListArray addObjectsFromArray:array];
        [weakSelf.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        [weakSelf.tableview.mj_footer endRefreshing];
    }];
}

#pragma mark-------创建tableView

-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tableView];
    self.tableview = tableView;
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W*0.6)];
    image.image=[UIImage imageNamed:@"index_4"];
    self.tableview.tableHeaderView=image;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aboutImage)];
    image.userInteractionEnabled=YES;
    [image addGestureRecognizer:tap];
}

-(void)aboutImage{
    AboutViewController *aboutVc=[[AboutViewController alloc]init];
    [self.navigationController pushViewController:aboutVc animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activeListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_W*0.6+10;
}
#pragma mark-------cell定制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityCell *cell = [ActivityCell cellWithTableView:tableView];
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.activeListArray[indexPath.row].ActiveImg] placeholderImage:[UIImage imageNamed:@"mine_bg"]];
    
    cell.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.mainImageView.clipsToBounds = YES;
    cell.titleLabel.text = self.activeListArray[indexPath.row].Name;
    
    return cell;
}

#pragma mark-------跳到活动详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActiveUrlVC *detailVc = [[ActiveUrlVC alloc] init];
    detailVc.activeModel = self.activeListArray[indexPath.item];
    [self.navigationController pushViewController:detailVc animated:YES];
}



-(void) setUpNavigationBar
{
    self.navigationItem.title=@"乐天成长乐园";
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    backButton.frame=CGRectMake(30, 12, 20, 20);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//}
//-(void) back
//{
//    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {
    
    UIButton *btn = [[UIButton alloc]init];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 20, 20)];
    backView.image = [UIImage imageNamed:@"pinkback"];
    [btn addSubview:backView];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
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
