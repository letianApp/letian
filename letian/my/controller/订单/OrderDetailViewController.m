//
//  OrderDetailViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/16.
//  Copyright © 2017年 J. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderInfoModel.h"
#import "OrderConsultCell.h"
#import "OrderMoneyCell.h"
#import "OrderPayDetailCell.h"
#import "UIImageView+WebCache.h"
#import "PayPageVC.h"
#import "ChatViewController.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)OrderInfoModel *orderInfoModel;

@end

typedef NS_ENUM(NSInteger,OrderButtonTag)
{
    PayButtonTag           = 10,
    CancelButtonTag        = 20,
    BackButtonTag          = 30,
    FinishButtonTag        = 40,
    AskButtonTag           = 50,
};

@implementation OrderDetailViewController

- (void)viewDidLoad {    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self setUpNavigationBar];
    
    [self createTableView];
    
    [self requestData];
    
 }


#pragma mark------------获取订单详情

-(void)requestData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendString:API_NAME_GETORDERINFO];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"orderID"]=@(self.orderID);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [weakSelf.tableView.mj_header endRefreshing];
        [MBHudSet dismiss:self.view];
        NSLog(@"&&&&&&&&&*获取订单详情%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            weakSelf.orderInfoModel=[OrderInfoModel mj_objectWithKeyValues:responseObject[@"Result"][@"Source"]];
            NSLog(@"Msg%@",responseObject[@"Msg"]);
            [self createBottomView];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [weakSelf.tableView.mj_header endRefreshing];
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}

#pragma mark-------底部视图

-(void)createBottomView
{
    UIView *bottomView=[GQControls createViewWithFrame:CGRectMake(0, SCREEN_H-50, SCREEN_W, 50) andBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomView];
    
    [bottomView addSubview:[GQControls createViewWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5) andBackgroundColor:MAINCOLOR]];
    
    
    if ([kFetchUserType integerValue]==1) {
        //待支付的订单，可以取消，可以支付
        if (self.orderInfoModel.EnumOrderState == WaitPayOrder) {
            
            UIButton *cancelButton=[GQControls createButtonWithFrame:CGRectMake(SCREEN_W-95, 10, 80, 30) andTitle:@"取消订单" andTitleColor:MAINCOLOR andFontSize:13 andTag:CancelButtonTag andMaskToBounds:YES andRadius:8 andBorderWidth:0.5 andBorderColor:MAINCOLOR.CGColor];
            [cancelButton addTarget:self action:@selector(bottombtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:cancelButton];
            
            UIButton *payButton=[GQControls createButtonWithFrame:CGRectMake(SCREEN_W-190, 10, 80, 30) andTitle:@"现在支付" andTitleColor:MAINCOLOR andFontSize:13 andTag:PayButtonTag andMaskToBounds:YES andRadius:8 andBorderWidth:0.5 andBorderColor:MAINCOLOR.CGColor];
            [payButton addTarget:self action:@selector(bottombtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:payButton];
            //已经支付的订单，可以申请退款
        }else if (self.orderInfoModel.EnumOrderState!=WaitPayOrder && self.orderInfoModel.EnumOrderState!=BackIngOrder && self.orderInfoModel.EnumOrderState!=CancelOrder && self.orderInfoModel.EnumOrderState!=SuccessOrder){
            
            UIButton *payButton=[GQControls createButtonWithFrame:CGRectMake(SCREEN_W-95, 10, 80, 30) andTitle:@"申请退款" andTitleColor:MAINCOLOR andFontSize:13 andTag:BackButtonTag andMaskToBounds:YES andRadius:8 andBorderWidth:0.5 andBorderColor:MAINCOLOR.CGColor];
            [payButton addTarget:self action:@selector(bottombtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:payButton];
            //已完成，退款中或已退款的订单，在此联系客服
        }else if (self.orderInfoModel.EnumOrderState==SuccessOrder || self.orderInfoModel.EnumOrderState==CancelOrder || self.orderInfoModel.EnumOrderState==BackIngOrder){
        
        UIButton *payButton=[GQControls createButtonWithFrame:CGRectMake(SCREEN_W-95, 10, 80, 30) andTitle:@"在线客服" andTitleColor:MAINCOLOR andFontSize:13 andTag:AskButtonTag andMaskToBounds:YES andRadius:8 andBorderWidth:0.5 andBorderColor:MAINCOLOR.CGColor];
        [payButton addTarget:self action:@selector(bottombtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:payButton];
        
        
    }
        //如果用户是咨询师，可将预约订单修改为完成状态
    else if ([kFetchUserType integerValue]==11){
        
        if (self.orderInfoModel.EnumOrderState==ConsultOrder) {
            UIButton *finishButton=[GQControls createButtonWithFrame:CGRectMake(SCREEN_W-95, 10, 80, 30) andTitle:@"咨询已完成" andTitleColor:MAINCOLOR andFontSize:13 andTag:FinishButtonTag andMaskToBounds:YES andRadius:8 andBorderWidth:0.5 andBorderColor:MAINCOLOR.CGColor];
            [finishButton addTarget:self action:@selector(bottombtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:finishButton];
            
        }
        
    }
    
}
}

-(void)bottombtnClick:(UIButton *)btn{
    //点击现在付款
    if (btn.tag==PayButtonTag) {
        PayPageVC *payVc=[[PayPageVC alloc]init];
        payVc.orderID=self.orderInfoModel.OrderID;
        payVc.orderNo=self.orderInfoModel.OrderNo;
        [self.navigationController pushViewController:payVc animated:YES];
        //点击取消订单
    }else if (btn.tag==CancelButtonTag){
        [self cancelOrder];
        //申请退款
    }else if (btn.tag==BackButtonTag){
        [self applyToRefundOrder];
        //咨询已完成
    }else if (btn.tag==FinishButtonTag){
        [self finishOrder];
    }else if (btn.tag==AskButtonTag){
        //联系客服
        ChatViewController *chatVc=[[ChatViewController alloc]init];
        [self.navigationController pushViewController:chatVc animated:YES];
    }
    
}

#pragma mark-------取消订单

-(void)cancelOrder
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendString:API_NAME_DOCANCELORDER];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"orderID"]=@(self.orderID);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        NSLog(@"&&&&&&&&&*取消订单%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            NSLog(@"Msg%@",responseObject[@"Msg"]);
            [MBHudSet showText:@"订单取消成功！" andOnView:self.view];
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

#pragma mark-------申请退款

-(void)applyToRefundOrder
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendString:API_NAME_REFUNDORDER];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"orderID"]=@(self.orderID);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        NSLog(@"&&&&&&&&&*申请退款%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            NSLog(@"Msg%@",responseObject[@"Msg"]);
            [MBHudSet showText:@"申请成功！退款中……" andOnView:self.view];
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

#pragma mark-------咨询已完成

-(void)finishOrder
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendString:API_NAME_FINISHORDER];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"orderID"]=@(self.orderID);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        NSLog(@"&&&&&&&&&*修改订单为已完成%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            NSLog(@"Msg%@",responseObject[@"Msg"]);
            [MBHudSet showText:@"确认成功！" andOnView:self.view];
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64-50) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //订单咨询详情
    if (indexPath.row==0) {
        OrderConsultCell *consultCell=[OrderConsultCell cellWithTableView:tableView];
        consultCell.orderNoLabel.text=[NSString stringWithFormat:@"订单号：%@",self.orderInfoModel.OrderNo];
        consultCell.orderStateLabel.text=self.orderInfoModel.EnumOrderStateString;
        [consultCell.doctorHeadImgView sd_setImageWithURL:[NSURL URLWithString:self.orderInfoModel.DoctorHeadImg]];
        [consultCell.userHeadImgView sd_setImageWithURL:[NSURL URLWithString:self.orderInfoModel.UserHeadImg]];
        consultCell.doctorNameLabel.text=[NSString stringWithFormat:@"咨询师：%@",self.orderInfoModel.DoctorName];
        consultCell.consultTypeLabel.text=[NSString stringWithFormat:@"咨询方式：%@",self.orderInfoModel.ConsultTypeIDString];
        consultCell.consultTimeLabel.text=[NSString stringWithFormat:@"咨询时间：%@",self.orderInfoModel.ConsultTime];
        consultCell.userNameLabel.text=[NSString stringWithFormat:@"咨客：%@",self.orderInfoModel.ConsultName];
        consultCell.userInfoLabel.text=[NSString stringWithFormat:@"%@  %li",self.orderInfoModel.ConsultEnumSexTypeString,self.orderInfoModel.ConsultAge];
        consultCell.userPhoneLabel.text=[NSString stringWithFormat:@"电话：%@",self.orderInfoModel.ConsultPhone];
        consultCell.userEmailLabel.text=[NSString stringWithFormat:@"邮箱：%@",self.orderInfoModel.ConsultEmail];
        consultCell.consultDetailLabel.text=[NSString stringWithFormat:@"咨询内容：%@",self.orderInfoModel.ConsultDescription];
        return consultCell;
        //订单金额
    }else if (indexPath.row==1){
        OrderMoneyCell *moneyCell=[OrderMoneyCell cellWithTableView:tableView];
        moneyCell.moneyLabel.text=[NSString stringWithFormat:@"¥%.2f",self.orderInfoModel.TotalFee];
        return moneyCell;
    }else if (indexPath.row==2){
        //如果是已经支付的订单，显示支付详情
        OrderPayDetailCell *payCell=[OrderPayDetailCell cellWithTableView:tableView];
        if (self.orderInfoModel.EnumOrderState!=WaitPayOrder){
            payCell.PayTimeLabel.text=[NSString stringWithFormat:@"支付时间：%@",self.orderInfoModel.PayDate];
            if ([self.orderInfoModel.PayTypeString isEqualToString:@"支付宝"]) {
                payCell.PayTypeLabel.text=[NSString stringWithFormat:@"支付方式：%@",self.orderInfoModel.PayTypeString];
                payCell.PayTypeImgView.image=[UIImage imageNamed:@"支付宝支付"];
            }
            //未支付的订单则隐藏支付详情
        }else{
            payCell.hidden=YES;
        }
        return payCell;
        //温馨提示
    }else if (indexPath.row==3){
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        
        UIView *bgView=[GQControls createViewWithFrame:CGRectMake(15,0, SCREEN_W-30, 150) andBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        bgView.layer.masksToBounds=YES;
        bgView.layer.cornerRadius=25;
        [cell.contentView addSubview:bgView];
        
        [bgView addSubview:[GQControls createLabelWithFrame:CGRectMake(15, 10, SCREEN_W-30, 10) andText:@"温馨提示:" andTextColor:[UIColor lightGrayColor] andFontSize:11]];
        UILabel *detailLabel=[GQControls createLabelWithFrame:CGRectMake(15, 25, SCREEN_W-60,120) andText:@"1.  订单创建后，请于一小时内支付。超时未支付的订单将失效。\n2.  下单成功后，请记住您预约的时间，并及时进行咨询。如果您想更改咨询的时间，可在预约好的时间之前将原订单取消，并重新下单。\n3.  如果您未及时进行咨询，订单已处于完成状态，可联系客服退款。但您预约的这段时间，咨询师无法接受其他咨询，因此退款中将扣除10%的违约费用。\n4.  所有退款将在48小时内到账。\n5.  若您有任何疑问，可在线询问乐天客服，或致电021-37702979。" andTextColor:[UIColor lightGrayColor] andFontSize:11];
        detailLabel.numberOfLines=0;
        [bgView addSubview:detailLabel];
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 300;
    }else if (indexPath.row==1){
        return 50;
    }else if (indexPath.row==2){
        if (self.orderInfoModel.EnumOrderState==5) {
            return 10;
        }
        return 60;
    }else if (indexPath.row==3){
        return 150;
    }
    return 0;
}


-(void) setUpNavigationBar
{
    self.navigationItem.title=@"订单详情";
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
