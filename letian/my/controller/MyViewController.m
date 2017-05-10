//
//  MyViewController.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "MyViewController.h"
#import "GQControls.h"
#import "MessageViewController.h"
#import "OrderViewController.h"
#import "AboutUsPageVC.h"
#import "SettingViewController.h"
#import "CustomDateViewController.h"
#import "UserInfoModel.h"
#import "MJExtension.h"
#import "GQUserManager.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import <UShareUI/UShareUI.h>
#import "GQActionSheet.h"
#import "UIImageView+WebCache.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong)UserInfoModel *userInfoModel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *headImageView;
//@property (nonatomic, strong) UIView *holdView;//下拉遮罩层

@end

@implementation MyViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self requestData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (//) {
//        self.dataArray=@[@"系统设置",@"客服电话    021-37702979",@"我要分享",@"关于我们"];

//    } else {
        self.dataArray=@[@"系统设置",@"设置可预约日期",@"我要分享",@"关于我们"];

//    }
    
    
    [self createTableView];
}


#pragma mark------------获取用户信息
-(void)requestData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_GETUSERINFO];
    __weak typeof(self) weakSelf = self;
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    NSLog(@"token------------%@",kFetchToken);
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        NSLog(@"&&&&&&&&&*获取用户信息%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            weakSelf.userInfoModel=[UserInfoModel mj_objectWithKeyValues:responseObject[@"Result"][@"Source"]];
            self.nameLabel.text=weakSelf.userInfoModel.NickName;
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.HeadImg] placeholderImage:[UIImage imageNamed:@"emptyHeadImage"]];
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


#pragma mark--------创建tableView

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-44) style:UITableViewStylePlain];    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.tag = 10;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableHeaderView=[self createHeadView];
//    _holdView = [[UIView alloc]init];
//    _holdView.backgroundColor = MAINCOLOR;
//    [tableView addSubview:_holdView];
}


#pragma mark--------下拉显示遮罩层

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.tag == 10) {
//        _holdView.frame = CGRectMake(0, 0, SCREEN_W, scrollView.contentOffset.y);
//    }
}


#pragma mark--------账户头像

- (UIImageView *)createHeadView {
    UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W*0.7)];
    headView.image=[UIImage imageNamed:@"mine_bg"];
    headView.contentMode=UIViewContentModeScaleToFill;
    headView.userInteractionEnabled=YES;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:headView.bounds];
    toolbar.barStyle = UIBarStyleBlackOpaque;
    toolbar.alpha=0.7;
    [headView addSubview:toolbar];
    
    //已登录则显示头像昵称
    if ([GQUserManager isHaveLogin]) {
        //头像
        UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_W-100)/2, (headView.height-130)/2, 100, 100)];
        headImageView.layer.masksToBounds=YES;
        headImageView.layer.cornerRadius=50;
        [headView addSubview:headImageView];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoClick)];
        [headImageView addGestureRecognizer:tap];
        headImageView.userInteractionEnabled=YES;
        self.headImageView=headImageView;
        //用户名
        UILabel *nameLabel=[GQControls createLabelWithFrame:CGRectMake((SCREEN_W-150)/2, headImageView.height+((headView.height-130)/2)+10, 150, 20) andText:@"" andTextColor:[UIColor whiteColor] andFontSize:16];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [headView addSubview:nameLabel];
        self.nameLabel=nameLabel;
        //消息
        UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W-35, 30, 25, 25)];
        [messageBtn setImage:[UIImage imageNamed:@"whiteMessage"] forState:UIControlStateNormal];
        [messageBtn addTarget:self action:@selector(messageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:messageBtn];
    }else{
        //未登录则显示登录按钮
        UIButton *loginBtn=[GQControls createButtonWithFrame:CGRectMake((SCREEN_W-100)/2, (headView.height-40)/2, 100, 40) andTitle:@"登录/注册" andTitleColor:[UIColor whiteColor] andFontSize:15 andTag:100 andMaskToBounds:YES andRadius:20 andBorderWidth:1 andBorderColor:[UIColor whiteColor].CGColor];
        [loginBtn addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:loginBtn];
    }
    return headView;
}


#pragma mark--------点击头像进入个人资料

-(void)userInfoClick{
    UserInfoViewController *userInfoVc=[[UserInfoViewController alloc]init];
    userInfoVc.hidesBottomBarWhenPushed=YES;
    userInfoVc.userInfoModel=self.userInfoModel;
    [self.navigationController pushViewController:userInfoVc animated:YES];
}

#pragma mark--------点击登录

-(void)loginButtonClick{
    LoginViewController *loginVc=[[LoginViewController alloc]init];
    loginVc.hidesBottomBarWhenPushed=YES;
    loginVc.tabbarIndex=2;
    [self.navigationController pushViewController:loginVc animated:YES];
}

#pragma mark--------点击进入消息界面

- (void)messageButtonClicked {
    MessageViewController *messageVc=[[MessageViewController alloc]init];
    messageVc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:messageVc animated:NO];
}


#pragma mark--------TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text=self.dataArray[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_W, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [cell.contentView addSubview:lineView];
    return cell;
}

#pragma mark--------SectionHeadView----订单分类view

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *orderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    //全部订单
    UILabel *label=[GQControls createLabelWithFrame:CGRectMake(10, 0, 100, 40) andText:@"全部订单" andTextColor:[UIColor darkGrayColor] andFontSize:14];
    [orderView addSubview:label];
    
    UILabel *allOrderLabel=[GQControls createLabelWithFrame:CGRectMake(SCREEN_W-160, 0, 150, 40) andText:@"查看全部订单 >>" andTextColor:[UIColor darkGrayColor] andFontSize:12];
    allOrderLabel.textAlignment=NSTextAlignmentRight;
    [orderView addSubview:allOrderLabel];
    //添加手势：查看全部订单
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allOrderLabelTouched)];
    [allOrderLabel addGestureRecognizer:tap];
    allOrderLabel.userInteractionEnabled=YES;
    //分割线
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_W, 0.5)];
    lineView1.backgroundColor=[UIColor lightGrayColor];
    [orderView addSubview:lineView1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, 109, SCREEN_W, 0.5)];
    lineView2.backgroundColor=[UIColor lightGrayColor];
    [orderView addSubview:lineView2];
    //左边隔 30        按钮  40       中间  (screen-60-40*3)/2
    NSArray *imageNameArray=@[@"date",@"waitpay",@"success"];
    NSArray *orderSrateArray=@[@"我的预约",@"待支付",@"已完成"];
    for (NSInteger i=0; i<3; i++) {
       //订单分类按钮
        UIButton *orderButton=[[UIButton alloc]initWithFrame:CGRectMake(30+((SCREEN_W-60-40*3)/2+40)*i, 48, 40, 40)];
        [orderButton setImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateNormal];
        [orderButton addTarget:self action:@selector(orderSrateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        orderButton.tag=100+i;
        [orderView addSubview:orderButton];
        //订单分类label
        UILabel *orderLabel=[GQControls createLabelWithFrame:CGRectMake(20+((SCREEN_W-40-60*3)/2+60)*i, 92, 60, 10) andText:orderSrateArray[i] andTextColor:[UIColor darkGrayColor] andFontSize:11];
        orderLabel.textAlignment=NSTextAlignmentCenter;
        [orderView addSubview:orderLabel];
    }
    return orderView;
}


#pragma mark--------点击进入订单列表
- (void)orderSrateButtonClick:(UIButton *)btn {
    OrderViewController *orderVc=[[OrderViewController alloc]init];
    orderVc.hidesBottomBarWhenPushed=YES;
    if (btn.tag==100) {
        orderVc.orderState=ConsultOrder;
    }else if (btn.tag==101){
        orderVc.orderState=WaitPayOrder;
    }else if (btn.tag==102){
        orderVc.orderState=SuccessOrder;
    }
    [self.navigationController pushViewController:orderVc animated:NO];
}
//查看所有订单
-(void)allOrderLabelTouched{
    OrderViewController *orderVc=[[OrderViewController alloc]init];
    orderVc.hidesBottomBarWhenPushed=YES;
    orderVc.orderState=AllOrder;
    [self.navigationController pushViewController:orderVc animated:NO];
}

#pragma mark--------cell点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    NSLog(@"cell被点击%li",indexPath.row);
    if (indexPath.row==0){
        //跳到系统设置
        SettingViewController *settingVc=[[SettingViewController alloc]init];
        settingVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:settingVc animated:NO];
    }else if(indexPath.row==1) {
        //拨打客服电话，打完之后不会留在通讯录而是回到应用
//        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"021-37702979"];
//        UIWebView * callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [self.view addSubview:callWebview];
        
        CustomDateViewController *customDateVc = [[CustomDateViewController alloc]init];
        customDateVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:customDateVc animated:NO];
        
    }else if(indexPath.row==2) {
        //分享
        NSArray *titles = @[@"分享到朋友圈",@"分享到微信",@"分享到微博",@"分享到空间",@"分享到短信",@"分享到QQ"];
        NSArray *imageNames = @[@"pengyou",@"weixin",@"weibo",@"kongjian",@"mess",@"qq"];
        GQActionSheet *sheet = [[GQActionSheet alloc] initWithTitles:titles iconNames:imageNames];
        [sheet showActionSheetWithClickBlock:^(int btnIndex) {
            NSLog(@"btnIndex:%d",btnIndex);
            NSInteger platformType;
            if (btnIndex==0) {
                platformType=ShareTo_WechatTimeLine;
            }else if (btnIndex==1){
                platformType=ShareTo_WechatSession;
            }else if (btnIndex==2){
                platformType=ShareTo_Sina;
            }else if (btnIndex==3){
                platformType=ShareTo_Qzone;
            }else if (btnIndex==4){
                platformType=ShareTo_Sms;
            }else {
                platformType=ShareTo_QQ;
            }
            [self shareWebPageToPlatformType:platformType];
        } cancelBlock:^{
            NSLog(@"取消");
        }];
    } else if (indexPath.row == 3) {
       // 关于我们
        AboutUsPageVC *aboutUsPage = [[AboutUsPageVC alloc]init];
        aboutUsPage.hidesBottomBarWhenPushed = YES;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:aboutUsPage animated:NO];
    }
}


#pragma mark--------分享网页

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"乐天心理" descr:@"解除心理束缚，重获心灵自由。——最好的心理医生" thumImage:[UIImage imageNamed:@"乐天logo"]];
    shareObject.webpageUrl =@"http://www.wzright.com/";
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBHudSet showText:@"分享失败" andOnView:self.view];
        }else{
            [MBHudSet showText:@"分享成功" andOnView:self.view];
        }
    }];
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
