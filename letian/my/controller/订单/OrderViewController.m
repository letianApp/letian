//
//  OrderViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/10.
//  Copyright © 2017年 J. All rights reserved.
//

#import "OrderViewController.h"
#import "GQSegment.h"
#import "OrderCell.h"
#import "OrderDetailViewController.h"
#import "MJExtension.h"
#import "OrderListModel.h"

@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SegmentDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, weak) GQSegment *segment;
@property(nonatomic,strong)NSMutableArray<OrderListModel*> *orderList;

@end

@implementation OrderViewController

-(NSMutableArray *)orderList
{
    if (_orderList == nil) {
        _orderList = [NSMutableArray array];
    }
    return _orderList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    
    [self setUpNavigationBar];
    
    [self setSegment];
    
    [self requestData:self.state];//订单
}


#pragma mark-------创建Segment

-(void)setSegment {
    GQSegment *segment = [[GQSegment alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    segment.delegate = self;
    [self.view addSubview:segment];
    if (self.state==0) {
        [segment moveToOffsetX:0];
    }else if (self.state==1){
        [segment moveToOffsetX:SCREEN_W];
    }else if (self.state==5){
        [segment moveToOffsetX:2*SCREEN_W];
    }else if (self.state==10){
        [segment moveToOffsetX:3*SCREEN_W];
    }
    self.segment = segment;
}


#pragma mark-------点击分类滑动到页面
-(void)scrollToPage:(int)Page {
    [UIView animateWithDuration:0.3 animations:^{
        NSLog(@"滑动到地%i页",Page);
        if (Page==0) {
            [self requestData:5];//全部订单
        }else if (Page==1){
            [self requestData:1];//预约订单
        }else if (Page==2){
            [self requestData:5];//待支付订单
        }else if (Page==3){
            [self requestData:10];//已完成订单
        }
    }];
}


#pragma mark------------获取订单列表

-(void)requestData:(NSInteger)orderType
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendString:API_NAME_GETORDERLIST];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"enumOrderState"]=@(orderType);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        NSLog(@"&&&&&&&&&*获取订单列表%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            weakSelf.orderList=[OrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
            NSLog(@"Msg%@",responseObject[@"Msg"]);
            [self createTableView];
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.tableHeaderView=self.segment;
    self.tableView = tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell=[OrderCell cellWithTableView:tableView];
//    cell.headImageView
    cell.nameLabel.text=self.orderList[indexPath.row].DoctorName;
//    cell.wayLabel.text
//    cell.timeLabel.text=
    cell.moneyLabel.text=[NSString stringWithFormat:@"共%li小时，总计%li元",self.orderList[indexPath.row].ConsultTimeLength,self.orderList[indexPath.row].TotalFee];
    return cell;
}


#pragma mark------跳到订单详情

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    OrderDetailViewController *orderDetailVc=[[OrderDetailViewController alloc]init];
    [self.navigationController pushViewController:orderDetailVc animated:YES];
}


-(void) setUpNavigationBar
{
    self.navigationItem.title=@"我的订单";
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
