//
//  PayPageVC.m
//  letian
//
//  Created by J on 2017/3/30.
//  Copyright © 2017年 J. All rights reserved.
//

#import "PayPageVC.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayHelper.h"
#import "RSADataSigner.h"
#import "Order.h"
#import "OrderViewController.h"
#import "AppDelegate.h"

@interface PayPageVC ()<UITableViewDelegate,UITableViewDataSource,WXApiDelegate,UIApplicationDelegate>

@end

@implementation PayPageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self customNavigation];
    [self customTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayAction:) name:kWeChatPayNotifacation object:nil];
    
    [self aliPayAction];
    

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    self.navigationItem.title = @"支付方式";
    
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}


- (void)customTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    [self customHeadViewWithTableView:tableView];
    
}

- (void)customHeadViewWithTableView:(UITableView *)tableview {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 70)];
    tableview.tableHeaderView = view;
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/2, view.height)];
    [view addSubview:titleLab];
    titleLab.text = @"预约金额：";
    titleLab.textColor = MAINCOLOR;
    titleLab.textAlignment = NSTextAlignmentRight;
    UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/2, 0, SCREEN_W/2, view.height)];
    [view addSubview:priceLab];
    priceLab.text = [NSString stringWithFormat:@"%.2f",self.totalFee];
    priceLab.textColor = MAINCOLOR;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCellId"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payCellId"];
    }
    NSArray *titleArr = @[@"微信支付",@"支付宝支付"];
    cell.textLabel.text = titleArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:titleArr[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
//        NSLog(@"微信");
        [self wechatPay];

        
    } else if (indexPath.row == 1) {
//        NSLog(@"支付宝");
        
        [self checkAlipay];
        
        
    }
    
}

#pragma mark - 支付宝
-(void)aliPay{
    
    Product *product = [Product new];
    product.orderNo = self.orderNo;//订单号
    product.subject = @"乐天心理咨询订单";
    product.price = [NSString stringWithFormat:@"%.2f",self.totalFee];//订单价格
    
    [[AlipayHelper shared] alipay:product block:^(NSDictionary *result) {
        NSString *message = @"";
        switch([[result objectForKey:@"resultStatus"] integerValue])
        {
            case 9000:
            {
                message = @"订单支付成功";
                [MBHudSet showText:message andOnView:self.view];
                OrderViewController *orderVc = [[OrderViewController alloc] init];
                orderVc.orderState = 1;
                [self.navigationController pushViewController:orderVc animated:YES];
                return;
            }
            case 8000:
            {
                message = @"正在处理中";
                break;
            }
            case 4000:message = @"订单支付失败";break;
            case 6001:message = @"取消了支付";break;
            case 6002:message = @"网络连接错误";break;
            default:message = @"未知错误";
        }
//        NSLog(@"什么鬼啊%@",message);
        [self payFailedAlertWithMessage:message];

    }];


}

//支付宝状态检验
-(void)checkAlipay
{
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendFormat:@"%@",API_NAME_CHECKALIPAY];
//    NSLog(@"%@",requestString);
    __weak typeof(self) weakSelf   = self;
    
    NSMutableDictionary *params    = [[NSMutableDictionary alloc]init];
    params[@"orderID"]     = @(self.orderID);
    
    [PPNetworkHelper GET:requestString parameters:params success:^(id responseObject) {
//        NSLog(@"支付宝预支付%@%@",responseObject,responseObject[@"Msg"]);
        if ([responseObject[@"IsSuccess"] boolValue] == YES){
            
            [self aliPay];
        }else{
            [MBHudSet showText:[NSString stringWithFormat:@"%@",responseObject[@"IsSuccess"]]andOnView:weakSelf.view];

        }
        
    } failure:^(NSError *error) {
        
        __strong typeof(self) strongself = weakSelf;
        [MBHudSet showText:[NSString stringWithFormat:@"错误代码：%ld",(long)error.code]andOnView:strongself.view];
    }];

}
#pragma mark - 微信支付

-(void)wechatPay{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendString:API_NAME_WECHATPAY];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderID"] = @(self.orderID);
    params[@"money"] = @(self.totalFee);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"微信预支付%@%@",responseObject,responseObject[@"Msg"]);
        [MBHudSet dismiss:self.view];
        if ([responseObject[@"IsSuccess"] boolValue] == YES){
            NSMutableDictionary *dict = responseObject[@"Result"][@"Source"];
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = dict[@"partnerid"];
            req.prepayId            = dict[@"prepayid"];
            req.nonceStr            =dict[@"noncestr"];
            req.timeStamp           = [dict[@"timestamp"] intValue];
            req.package             = dict[@"package"];
            req.sign                = dict[@"sign"];
            [WXApi sendReq:req];
            //日志输出
//            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
            [MBHudSet showText:@"支付失败" andOnView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        [MBHudSet showText:@"支付失败" andOnView:self.view];
//        NSLog(@"%@",error);
    }];

}


#pragma mark--------微信支付回调

-(void) wechatPayAction:(NSNotification *)notification
{
    NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
    BaseResp *resp = (BaseResp *)(notification.object);
    switch (resp.errCode) {
        case WXSuccess:
        {
            strMsg = @"订单支付成功！";
            //跳到预约订单
            OrderViewController *orderVc = [[OrderViewController alloc] init];
            orderVc.orderState = 1;
            [self.navigationController pushViewController:orderVc animated:YES];
            return;
        }
        case WXErrCodeCommon: strMsg = @"普通错误类型！"; break;
        case WXErrCodeUserCancel: strMsg = @"用户取消！"; break;
        case WXErrCodeSentFail: strMsg = @"发送失败！"; break;
        case WXErrCodeAuthDeny: strMsg = @"授权失败"; break;
        case WXErrCodeUnsupport: strMsg = @"微信不支持"; break;
        default: strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
        break;
    }
    [self payFailedAlertWithMessage:strMsg];
}


#pragma mark--------支付宝回调

-(void)aliPayAction{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    __weak typeof(self) weakSelf   = self;
    appdelegate.pushToOrderVc=^(NSInteger alipayCode){
        NSString *message = @"";
        switch (alipayCode) {
            case 9000:
            {message = @"订单支付成功";
                OrderViewController *orderVc = [[OrderViewController alloc] init];
                orderVc.orderState = 1;
                [weakSelf.navigationController pushViewController:orderVc animated:YES];
                return;
            }
            case 8000:
            {
                message = @"正在处理中";
                break;
            }
            case 4000:message = @"订单支付失败";break;
            case 6001:message = @"取消了支付";break;
            case 6002:message = @"网络连接错误";break;
            default:message = @"未知错误";
        }
        [self payFailedAlertWithMessage:message];
    };
}


#pragma mark-------支付失败时跳到待支付订单列表

-(void)payFailedAlertWithMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付结果" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //跳到待支付订单
        OrderViewController *orderVc = [[OrderViewController alloc] init];
        orderVc.orderState = 5;
        [self.navigationController pushViewController:orderVc animated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
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
