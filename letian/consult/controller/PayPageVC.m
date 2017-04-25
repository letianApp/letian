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
#import "AliPayOrderModel.h"
#import "RSADataSigner.h"



@interface PayPageVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PayPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self customNavigation];
    [self customTableView];
    
    NSLog(@"订单ID：%ld",self.orderID);
    
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
    priceLab.text = @"¥3000";
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
        NSLog(@"微信");
        
        //        BOOL weChatIns = [WXApi isWXAppInstalled];
        [WXApi openWXApp];
        
        //        PayReq *request = [[PayReq alloc] init];
        //        /** 商家向财付通申请的商家id */
        //        request.partnerId = WEIXIN_PARTNERID;
        //        /** 预支付订单 */
        //        request.prepayId= @"8201038****be9c4c063c30";
        //        /** 商家根据财付通文档填写的数据和签名 */
        //        request.package = @"Sign=WXPay";
        //        /** 随机串，防重发 */
        //        request.nonceStr= @"lUu5qloVJV7rrJlr";
        //        /** 时间戳，防重发 */
        ////        request.timeStamp= 145****985;
        //        /** 商家根据微信开放平台文档对数据做的签名 */
        //        request.sign= @"b640c1a4565b4****4b8a9e71960b0123";
        //        /*! @brief 发送请求到微信，等待微信返回onResp
        //         *
        //         * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
        //         * SendAuthReq、SendMessageToWXReq、PayReq等。
        //         * @param req 具体的发送请求，在调用函数后，请自己释放。
        //         * @return 成功返回YES，失败返回NO。
        //         */
        //        [WXApi sendReq: request];
        
    } else if (indexPath.row == 1) {
        NSLog(@"支付宝");
        
        NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
        [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
        [requestString appendFormat:@"%@",API_NAME_CHECKALIPAY];
        NSLog(@"%@",requestString);
        __weak typeof(self) weakSelf   = self;
        
        NSMutableDictionary *params    = [[NSMutableDictionary alloc]init];
        params[@"orderID"]     = @(self.orderID);
        
        [PPNetworkHelper GET:requestString parameters:params success:^(id responseObject) {
            __strong typeof(self) strongself = weakSelf;
            NSLog(@"%@",responseObject);
            
            
        } failure:^(NSError *error) {
            
            __strong typeof(self) strongself = weakSelf;
            [MBHudSet showText:[NSString stringWithFormat:@"错误代码：%ld",error.code]andOnView:strongself.view];
            
            
        }];
        
                [self aliPay];
        
    }
    
}


- (void)aliPay {

    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2017040706582401";

    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC/T1Ic15GihcIbIkXMswHUdxnslnJQxvY1eCX7eOJU5mV/9x2glEcDCZwOL9zFy78hwbn3ytnskD9HcD218mhfvBK9wmF08YChJs4/GPWaFNiER3NL87Cxy896N3q8LJFhCotMu2IXNqBZ5AK9T+H7EJ6peNnMr9mTRUzM0I2zPg/aaSu0Fx6EtiGITO/S7GPkrmcUzj1sz/EPj8Er8c413xNutDDdel1dAdifXeWKh/OiBNXaOl6cQq5nObVrFsy7kWDJZgtqt46AyTIOwubZYBfjh0FCnnJyH0T59wBAmlrgVhXSAd+hbmZ3sMzn3bmjFnei2/N9i8cGP8bWuxIDAgMBAAECggEAF5qb0P8v8tN6DYr+/bCgayx+wFgXpqvFuPcoCIzzr/H1WAKPXz6sPE21OXLiVG09GdcjMNWQacWqaRAKLSbJhfZYgZ04FQuvCTMWg2Z69xXXWQrPyPE6PdWdtcCenhUJouWAJmmAQsj0o+KkC+ONSELWsKY+iSixOaB1R1f8A79PwCX3nPDxmUaX/lD4IRXLxi1gGlvoM4WAdFsc0JMnigYDa9yvRrQgjDYyO51F7uV40ZcJVjItaRYj2q36ddbI6QrpPJfKKtkXz0FOuZPEXm6Tks0jtyRGeiIzi1QDbtXmdBDq6pMmXaWqalNcl9t8f56HeeKMpR8/ogxUW3dWUQKBgQDvz1I+4B4y8UL9sXSAFUskZJZeSwEzWHeTrgTZpjDGHzq3WGAyZMW1j8POLvmShfhF1vUbnlWFWbhKlAL/RzQZLdJiSjeE99cjKkhO/sNkWyHOSOIiTkS5oEYNYNIM6tXyaPxq500lYCkYkNFMwN2sFQTgwwGso5xE6vFS3PZB1wKBgQDMOcPLXd07ipQ3P9yZ+RbOCHKCPj6uCAHfEEEZrmfwDZn+MEkhYTutC+eovkpQeswYMwlNiftnHlYO84MJ2qYk9sxosvHHJBFH7m84tJzcJaExLrnvxc+idH6N2qFphnsbWCdcarxLzQP08EBZnZhC5exi4EuJykyQT/1Dy88DtQKBgGTmr61i8XHvz4cc/m7SBs7mP9qm5ndrNsz9gG7vnUAPbc4tMjSh8ApH1lRPsZT0J5WDL5iSU1uLd55xjp1IoWQiwo22uouJGI1kQg5y5VW5fozkX7mdgw8zn6YLYfYrbR/VCrgUYIJkZoY+kMIhuGOqaGYFxxOTt7HLxQRfkoH7AoGAUAIVZbfZMzlgRaDcQOon+AGxMrtF/RIgAY6xomkESTRa7w1lqREZuvqeACrEnHDvQk/ERj9XYZet6V+XJ6YkTvjtLdtlAzprFr4fjpybk1eepdEDgR8C8EcpSVOsxtWrpxPLH9ak/CFOeogg/brS6up+yGHM1ieOBT+BHi1bZb0CgYB58CUeB72A8fdPZ/ivZ1xynfo1X7HytqhSmDIStse3kzBr9nU8Ih8fvJmiVFyyszohsjulub/Ch+SfKT4tKsBoXtfBU6HTPH+9IZIwkPjf2V40g/LLtS6ADfQeTlGzXlH7/C2r+ALRvqQ/GvXsgo8lRftVgSW30Td6feJozTE2hg==";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/

    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    AliPayOrderModel *order = [AliPayOrderModel new];

    // NOTE: app_id设置
    order.app_id = appID;

    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";

    // NOTE: 参数编码格式
    order.charset = @"utf-8";

    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];

    // NOTE: 支付版本
    order.version = @"1.0";

    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";

    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
//    order.biz_content.out_trade_no = self.orderID; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 1.0]; //商品价格

    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);

    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }

    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";

        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];

        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }

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
