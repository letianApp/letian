//
//  OrderViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/10.
//  Copyright © 2017年 J. All rights reserved.
//

#import "OrderViewController.h"
#import "ChatViewController.h"
#import "GQSegment.h"
#import "OrderCell.h"
#import "OrderDetailViewController.h"
#import "MJExtension.h"
#import "OrderListModel.h"
#import "PayPageVC.h"
#import "UIImageView+WebCache.h"
#import "DateTools.h"

@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SegmentDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) GQSegment *segment;
@property(nonatomic,strong)NSMutableArray<OrderListModel*> *orderList;
@property(nonatomic,strong)UIView *topView;
@property (nonatomic, copy) NSString *showText;

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
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBarHidden=NO;
    
    [self setUpNavigationBar];
    
    [self setSegment];
    
    [self createTableView];
    
    [self requestData];//订单
    
    [self setUpRefresh];
    
}

-(void)setUpRefresh
{
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = NO;
    self.tableView.mj_footer.hidden = YES;
    //    self.tableView.mj_footer = [RefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    //    self.tableView.mj_footer.hidden = YES;
}


#pragma mark-------创建Segment

-(void)setSegment {
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W, 50)];
    [self.view addSubview:self.topView];
    
    self.segment = [[GQSegment alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.segment.delegate = self;
    self.segment.backgroundColor=[UIColor whiteColor];
    [self.topView addSubview:self.segment];
    if (self.orderState==AllOrder) {
        [self.segment moveToOffsetX:0];
    }else if (self.orderState==ConsultOrder){
        [self.segment moveToOffsetX:SCREEN_W];
    }else if (self.orderState==WaitPayOrder){
        [self.segment moveToOffsetX:2*SCREEN_W];
    }else if (self.orderState==SuccessOrder){
        [self.segment moveToOffsetX:3*SCREEN_W];
    }
    UIView *marginView=[[UIView alloc]initWithFrame:CGRectMake(0, self.segment.height-3, SCREEN_W, 5)];
    marginView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.topView addSubview:marginView];
    
}


#pragma mark-------点击分类滑动到页面

-(void)scrollToPage:(int)Page {
    [UIView animateWithDuration:0.3 animations:^{
        NSLog(@"滑动到地%i页",Page);
        if (Page==0) {
            self.orderState=AllOrder;//全部订单
        }else if (Page==1){
            self.orderState=ConsultOrder;//预约订单
        }else if (Page==2){
            self.orderState=WaitPayOrder;//待支付订单
        }else if (Page==3){
            self.orderState=SuccessOrder;//已完成订单
        }
        [self requestData];
    }];
}


#pragma mark------------获取订单列表

-(void)requestData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendString:API_NAME_GETORDERLIST];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"enumOrderState"]=@(self.orderState);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    NSLog(@"订单列表的token%@",kFetchToken);
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = weakSelf;

        [strongSelf.tableView.mj_header endRefreshing];
        [MBHudSet dismiss:strongSelf.view];
        NSLog(@"&&&&&&&&&*获取订单列表%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            [strongSelf.orderList removeAllObjects];
            strongSelf.orderList=[OrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
            NSLog(@"Msg%@",responseObject[@"Msg"]);
            [strongSelf.tableView reloadData];
        }
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


#pragma mark-------创建TableView

-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+50, SCREEN_W, SCREEN_H-64-50) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell=[OrderCell cellWithTableView:tableView];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if ([kFetchUserType integerValue]==1) {
        //如果用户是咨客
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.orderList[indexPath.row].DoctorHeadImg]];
        cell.nameLabel.text = self.orderList[indexPath.row].DoctorName;
        UIGestureRecognizer *tap = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(getDoctorInfo:)];
        cell.headImageView.userInteractionEnabled=YES;
        [cell.headImageView addGestureRecognizer:tap];
    }else{
        //如果用户是咨询师
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.orderList[indexPath.row].UserHeadImg]];
        cell.nameLabel.text = self.orderList[indexPath.row].UserName;
    }
    
    //咨询方式
    if (self.orderList[indexPath.row].EnumConsultType==1) {
        cell.wayLabel.text=[NSString stringWithFormat:@"咨询方式：面对面咨询"];
    }else if (self.orderList[indexPath.row].EnumConsultType==11){
        cell.wayLabel.text=[NSString stringWithFormat:@"咨询方式：文字语音视频"];
    }else if (self.orderList[indexPath.row].EnumConsultType==21){
        cell.wayLabel.text=[NSString stringWithFormat:@"咨询方式：电话咨询"];
    }
    //咨询时间
    NSString *dataStr = [self.orderList[indexPath.row].AppointmentDate substringWithRange:NSMakeRange(0, 10)];
    NSString *startTime = [self.orderList[indexPath.row].StartTime substringWithRange:NSMakeRange(0, 5)];
    NSString *endTime = [self.orderList[indexPath.row].EndTime substringWithRange:NSMakeRange(0, 5)];
    cell.timeLabel.text=[NSString stringWithFormat:@"咨询时间：%@ %@～%@",dataStr,startTime,endTime];
    //总计金额
    cell.moneyLabel.text=[NSString stringWithFormat:@"共%li小时，总计%.2f元",self.orderList[indexPath.row].ConsultTimeLength,self.orderList[indexPath.row].TotalFee];
    //订单状态
    if (self.orderList[indexPath.row].EnumOrderState==5) {
        //计算未支付的订单创建时间与当前时间  间隔多少秒
        DTTimePeriod *timePeriod = [[DTTimePeriod alloc] initWithStartDate:[NSDate dateWithString:self.orderList[indexPath.row].CreatedDate formatString:@"yyyy-MM-dd HH:mm:ss"]  endDate:[NSDate date]];
        //超过一小时（即3600秒）未支付  则该订单失效
        if (timePeriod.durationInSeconds<=3600) {
            //去支付
            cell.stateButton.layer.borderColor=[MAINCOLOR CGColor];
            [cell.stateButton addTarget:self action:@selector(toPayVc:) forControlEvents:UIControlEventTouchUpInside];
            //倒计时
            cell.secondsCountDown=(int)(3600-timePeriod.durationInSeconds);
        }else{
//            //订单失效
//            [self.orderList removeObject:self.orderList[indexPath.row]];
//            [self.tableView reloadData];
        }
        cell.timeChangeLabel.hidden=NO;
        cell.askBtn.hidden = YES;

    }else if (self.orderList[indexPath.row].EnumOrderState==1){
        //已预约
        [cell.stateButton setTitle:@"已预约" forState:UIControlStateNormal];
        cell.stateButton.userInteractionEnabled=NO;
        cell.askBtn.hidden = NO;
        cell.askBtn.tag = indexPath.row + 100;
        [cell.askBtn addTarget:self action:@selector(clickAskBtn:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"ID:%ld",cell.askBtn.tag);

    }else if (self.orderList[indexPath.row].EnumOrderState==10){
        //已完成
        [cell.stateButton setTitle:@"已完成" forState:UIControlStateNormal];
        cell.stateButton.userInteractionEnabled=NO;
        cell.askBtn.hidden = YES;
    }else if (self.orderList[indexPath.row].EnumOrderState==15){
        //退款中
        [cell.stateButton setTitle:@"退款中" forState:UIControlStateNormal];
        cell.stateButton.userInteractionEnabled=NO;
        cell.askBtn.hidden = YES;

    }else if (self.orderList[indexPath.row].EnumOrderState==30){
        //已退款
        [cell.stateButton setTitle:@"已退款" forState:UIControlStateNormal];
        cell.stateButton.userInteractionEnabled=NO;
        cell.askBtn.hidden = YES;

    }
    return cell;
}

//点击咨询师头像查看咨询师详情
-(void)getDoctorInfo:(NSInteger)doctorId{
    
    
    
}

- (void)clickAskBtn:(UIButton *)btn {
    
    [self animationbegin:btn];
    ChatViewController *chatVc = [[ChatViewController alloc]init];
    chatVc.hidesBottomBarWhenPushed = YES;
    chatVc.conversationType = ConversationType_PRIVATE;
    chatVc.targetId = [NSString stringWithFormat:@"%ld",self.orderList[btn.tag - 100].DoctorID];
    chatVc.title = self.orderList[btn.tag - 100].DoctorName;
    [self.navigationController pushViewController:chatVc animated:YES];
    
}

-(void)toPayVc:(UIButton *)btn{
    PayPageVC *payVc=[[PayPageVC alloc]init];    
    OrderCell *cell=(OrderCell *)btn.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    payVc.orderID=self.orderList[indexPath.row].OrderID;
    payVc.orderNo=self.orderList[indexPath.row].OrderNo;
    payVc.price=self.orderList[indexPath.row].TotalFee;
    NSLog(@"token------%@",kFetchToken);
    [self.navigationController pushViewController:payVc animated:YES];
}
#pragma mark------跳到订单详情

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    OrderDetailViewController *orderDetailVc=[[OrderDetailViewController alloc]init];
    orderDetailVc.orderID=self.orderList[indexPath.row].OrderID;
    orderDetailVc.DoctorID = self.orderList[indexPath.row].DoctorID;
    [self.navigationController pushViewController:orderDetailVc animated:YES];
}

#pragma mark - 定制导航栏
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//- (UIBarButtonItem *)customBackItemWithTarget:(id)target
//                                       action:(SEL)action {
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"whiteback"] forState:UIControlStateNormal];
//    [btn setFrame:CGRectMake(0, 0, 20, 20)];
//    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    return item;
//}
//


#pragma mark 按钮动画
- (void)animationbegin:(UIView *)view {
    /* 放大缩小 */
    
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
    
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
