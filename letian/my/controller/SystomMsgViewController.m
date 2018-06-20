//
//  SystomMsgViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/8.
//  Copyright © 2017年 J. All rights reserved.
//

#import "SystomMsgViewController.h"
#import "MessageCell.h"
#import "SystemMsgModel.h"
#import "OrderDetailViewController.h"

@interface SystomMsgViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong)NSMutableArray<SystemMsgModel *> *systemModelList;
@end

@implementation SystomMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setUpNavigationBar];
    [self createTableView];
    [self requestData];
}

-(NSMutableArray *)systemModelList
{
    if (_systemModelList == nil) {
        _systemModelList = [NSMutableArray array];
    }
    return _systemModelList;
}

#pragma mark------------获取系统消息列表

-(void)requestData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_MESSAGE];
    [requestString appendString:API_NAME_GETMESSAGELIST];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"enumMessageType"]=@(1);
    params[@"pageIndex"]=@(1);
    params[@"pageSize"]=@(10);
//    NSLog(@"token----%@",kFetchToken);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBHudSet dismiss:weakSelf.view];
//        NSLog(@"&&&&&&&&&*获取系统消息列表%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            weakSelf.systemModelList=[SystemMsgModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
//            NSLog(@"Msg%@",responseObject[@"Msg"]);
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBHudSet dismiss:self.view];
//        NSLog(@"%@",error);
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}


-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView=[GQControls createViewWithFrame:CGRectMake(0, 0, SCREEN_W, 30) andBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.systemModelList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageCell *cell=[MessageCell cellWithTableView:tableView];
    if (self.systemModelList[indexPath.row].MessageTypeID==1) {
        cell.messageTypeLabel.text=@"订单消息";
    }else{
        cell.messageTypeLabel.text=@"活动消息";
    }
    cell.msgDetailLabel.text=self.systemModelList[indexPath.row].Remark;
    cell.dateLabel.text=self.systemModelList[indexPath.row].CreatedDate;
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.systemModelList[indexPath.row].MessageTypeID==1) {
        OrderDetailViewController *orderDetailVc=[[OrderDetailViewController alloc]init];
        orderDetailVc.orderID=self.systemModelList[indexPath.row].RefferID1;
        [self.navigationController pushViewController:orderDetailVc animated:YES];
    }
     
    
//    NSLog(@"cell被点击%li",indexPath.row);
    
}

-(void) setUpNavigationBar
{
    self.navigationItem.title = @"系统消息";
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    backButton.frame=CGRectMake(30, 12, 20, 20);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
//-(void) back
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
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
