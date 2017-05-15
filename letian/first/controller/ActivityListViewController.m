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

@interface ActivityListViewController ()<WKNavigationDelegate,WKUIDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong)NSMutableArray <ActiveModel *> *activeListArray;
@property (nonatomic,strong) WKWebView *webView;

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
    
    [self createCollectionView];
    
    [self requestData];
    
    [self setUpRefresh];
   
}

#pragma mark-------下拉刷新

-(void)setUpRefresh
{
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.collectionView.mj_header = header;
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark-------获取活动列表

-(void)requestData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_ACTIVE];
    [requestString appendString:API_NAME_GETACTIVELIST];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"pageIndex"]=@(1);
    params[@"pageSize"]=@(20);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        [self.collectionView.mj_header endRefreshing];
        NSLog(@"&&&&&&&&&*获取活动列表%@",responseObject);
        NSLog(@"ActiveTypeIDString=%@",responseObject[@"Result"][@"Source"][0][@"ActiveTypeIDString"]);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            weakSelf.activeListArray=[ActiveModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
            NSLog(@"activeListArray=%@",weakSelf.activeListArray);
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        [self.collectionView.mj_header endRefreshing];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}


#pragma mark-------创建CollectionView

-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake((SCREEN_W-30)/2,130);
    flowLayout.minimumLineSpacing=5;
    flowLayout.minimumInteritemSpacing=5;
    flowLayout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ActivityCell"];
    
    [self.view addSubview:self.collectionView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.activeListArray.count;
}

#pragma mark-------cell定制
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCell" forIndexPath:indexPath];
    [cell.ActivityImageView sd_setImageWithURL:[NSURL URLWithString:self.activeListArray[indexPath.row].ActiveImg] placeholderImage:[UIImage imageNamed:@"mine_bg"]];

    cell.ActivityTitleLabel.text=self.activeListArray[indexPath.row].Name;
    return cell;
}

#pragma mark-------跳到活动详情
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityDetailViewController *detailVc=[[ActivityDetailViewController alloc] init];
    detailVc.activeModel=self.activeListArray[indexPath.item];
    [self.navigationController pushViewController:detailVc animated:YES];
}

-(void) setUpNavigationBar
{
    self.navigationItem.title=@"乐天活动";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame=CGRectMake(30, 12, 20, 20);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
-(void) back
{
    [self.navigationController popViewControllerAnimated:YES];
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
