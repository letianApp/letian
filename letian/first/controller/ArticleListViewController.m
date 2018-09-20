//
//  ArticleListViewController.m
//  letian
//
//  Created by 郭茜 on 2017/4/30.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ArticleListViewController.h"
#import "WebArticleModel.h"
#import "WebArticleCell.h"
#import "WebArticleViewController.h"
#import "CategoryViewController.h"
#import "UIImageView+WebCache.h"

@interface ArticleListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray <WebArticleModel *> *webArticleList;
@property(nonatomic,assign)NSInteger pageIndex;

@end

@implementation ArticleListViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
}


-(void)setUpRefresh
{
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer = [RefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    self.tableView.mj_footer.hidden = YES;
}


-(NSMutableArray *)webArticleList
{
    if (_webArticleList == nil) {
        _webArticleList = [NSMutableArray array];
    }
    return _webArticleList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    [self createTableView];
    
    [self requestData];
    
    [self viewAmimationPlay];
    
    [self setUpRefresh];
}


#pragma mark-------获取心理健康专栏文章列表

-(void)requestData
{
    self.pageIndex=1;
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_WEBARTICLE];
    [requestString appendString:API_NAME_GETWEBARTICLELIST];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"cateID"]=@(self.cateID);
    params[@"pageIndex"]=@(self.pageIndex);
    params[@"pageSize"]=@(10);
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf.tableView.mj_header endRefreshing];
//        NSLog(@"文章列表%@",responseObject);
        [MBHudSet dismiss:self.view];
        weakSelf.webArticleList=[WebArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
        if (weakSelf.webArticleList.count >= 10) {
            weakSelf.tableView.mj_footer.hidden = NO;
        }else{
            weakSelf.tableView.mj_footer.hidden=YES;
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

//获取更多网站文章
-(void)requestMoreData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_WEBARTICLE];
    [requestString appendString:API_NAME_GETWEBARTICLELIST];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"pageIndex"]=@(++self.pageIndex);
    params[@"pageSize"]=@(10);
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        NSArray *array=[WebArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
        if (array.count >= 10) {
            weakSelf.tableView.mj_footer.hidden = NO;
            [weakSelf.tableView.mj_footer endRefreshing];
        }else{
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.webArticleList addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark-----创建tableview

-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor=WEAKPINK;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    UIImageView *topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, SCREEN_W, SCREEN_W*0.6)];
    topImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.title]];
    self.tableView.tableHeaderView=topImageView;
}


#pragma mark -----------------tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.webArticleList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.webArticleList[indexPath.row].Abstract isEqualToString:@""]) {
        return 80;
    }
    return 120;
}
//cell定制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebArticleCell *cell=[WebArticleCell cellWithTableView:tableView];
    cell.titleLabel.text=self.webArticleList[indexPath.row].Title;
    cell.contentLabel.text=self.webArticleList[indexPath.row].Abstract;
    cell.readNumLabel.text=[NSString stringWithFormat:@"%ld人看过",self.webArticleList[indexPath.row].ReadNum];
    cell.dateLabel.text=self.webArticleList[indexPath.row].PostDate;
    return cell;
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];

    WebArticleViewController *webVc=[WebArticleViewController new];
    
    webVc.articleID=self.webArticleList[indexPath.row].ID;
//    NSLog(@"%li,,%@",webVc.articleID,[self getCurrentViewController]);
    
    [[self getCurrentViewController].navigationController pushViewController:webVc animated:YES];
    
}

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
//界面翻转动画
-(void)viewAmimationPlay{
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation((180.0*M_PI/180), 0.0, 0.7, 0.4);
    rotation.m44 = 1.0/-600;
    self.tableView.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.tableView.layer.shadowOffset = CGSizeMake(10, 10);
    self.tableView.alpha = 0;
    self.tableView.layer.transform = rotation;
    self.tableView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [UIView beginAnimations:@"rotaion" context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.layer.transform = CATransform3DIdentity;
    self.tableView.alpha = 1;
    self.tableView.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}


-(void) setUpNavigationBar {
    self.navigationItem.title = @"心理文章";

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
