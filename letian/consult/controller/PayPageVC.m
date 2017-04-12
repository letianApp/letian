//
//  PayPageVC.m
//  letian
//
//  Created by J on 2017/3/30.
//  Copyright © 2017年 J. All rights reserved.
//

#import "PayPageVC.h"

#import "WXApi.h"
#import "NSString+YYExtension.h"



@interface PayPageVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PayPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.automaticallyAdjustsScrollViewInsets = NO;

    [self customNavigation];
    [self customTableView];
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
