//
//  ActivityViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ActivityViewController.h"
#import "HomeCell.h"
#import <WebKit/WebKit.h>
#import "ActiveListModel.h"
#import "MJExtension.h"

@interface ActivityViewController ()<WKNavigationDelegate,WKUIDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong)NSMutableArray <ActiveListModel *> *activeListArray;
@property (nonatomic,strong) WKWebView *webView;

@end

@implementation ActivityViewController

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
    [self setUpNavigationBar];
    
//    [self createTableView];
//    [self requestData];
    [self createWebView];
   
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
    params[@"pageSize"]=@(10);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        NSLog(@"&&&&&&&&&*获取活动列表%@",responseObject);
        NSLog(@"ActiveTypeIDString=%@",responseObject[@"Result"][@"Source"][0][@"ActiveTypeIDString"]);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            weakSelf.activeListArray=[ActiveListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
            NSLog(@"activeListArray=%@",weakSelf.activeListArray);
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}


#pragma mark-------创建TableView

-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activeListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
#pragma mark-------cell定制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell=[HomeCell cellWithTableView:tableView];
    cell.titleLabel.text=self.activeListArray[indexPath.row].Name;
    cell.detailLabel.text=self.activeListArray[indexPath.row].Description;
    return cell;
}
#pragma mark-------cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
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

-(void)createWebView
{
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://mp.weixin.qq.com/mp/homepage?__biz=MzA3NjA4ODcxMQ==&hid=5&sn=066abcaccc743b1b8149c260ddf7e05d#wechat_redirect"]];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H )];
    webView.allowsBackForwardNavigationGestures=YES;
    [webView loadRequest:request];
    webView.navigationDelegate=self;
    webView.scrollView.showsVerticalScrollIndicator=NO;
    webView.UIDelegate = self;
    self.webView=webView;
    [self.view addSubview:webView];
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
