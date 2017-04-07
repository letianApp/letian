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
#import "UserInfoModel.h"
#import "MJExtension.h"
#import "CYUserManager.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;

@property(nonatomic,strong)UserInfoModel *userInfoModel;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIImageView *headImageView;

@end

@implementation MyViewController


- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;

    
    
}


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.dataArray=@[@"系统设置",@"客服电话    021-37702979",@"我要分享",@"关于我们"];
    [self createTableView];
    [self requestData];

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
    
    [MBHudSet showStatusOnView:self.view];

    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBHudSet dismiss:self.view];

        NSLog(@"&&&&&&&&&*获取用户信息%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            

            weakSelf.userInfoModel=[UserInfoModel mj_objectWithKeyValues:responseObject[@"Result"][@"Source"]];
            
            self.nameLabel.text=weakSelf.userInfoModel.NickName;
            
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



- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableHeaderView=[self createHeadView];
    
}


#pragma mark--------账户头像

- (UIView *)createHeadView {
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 220)];
    
    headView.backgroundColor=MAINCOLOR;
    
    if ([CYUserManager isHaveLogin]) {
        //头像
        UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_W-100)/2, 55, 100, 100)];
        headImageView.image=[UIImage imageNamed:@"women"];
        headImageView.layer.masksToBounds=YES;
        headImageView.layer.cornerRadius=50;
        [headView addSubview:headImageView];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoClick)];
        [headImageView addGestureRecognizer:tap];
        headImageView.userInteractionEnabled=YES;
        
        self.headImageView=headImageView;
        
        
        //用户名
        UILabel *nameLabel=[GQControls createLabelWithFrame:CGRectMake((SCREEN_W-150)/2, 160, 150, 20) andText:@"" andTextColor:[UIColor whiteColor] andFontSize:16];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [headView addSubview:nameLabel];
        self.nameLabel=nameLabel;
        
        //消息
        UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W-35, 30, 25, 25)];
        [messageBtn setImage:[UIImage imageNamed:@"whiteMessage"] forState:UIControlStateNormal];
        [messageBtn addTarget:self action:@selector(messageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:messageBtn];
        
        
    }else{
//        未登录则显示登录按钮
        UIButton *loginBtn=[GQControls createButtonWithFrame:CGRectMake((SCREEN_W-100)/2, (220-40)/2, 100, 40) andTitle:@"登录/注册" andTitleColor:[UIColor whiteColor] andFontSize:15 andTag:100 andMaskToBounds:YES andRadius:20 andBorderWidth:1 andBorderColor:[UIColor whiteColor].CGColor];
        [loginBtn addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:loginBtn];
        
    }
    
    
    
    return headView;
    
}

-(void)userInfoClick{
    
    UserInfoViewController *userInfoVc=[[UserInfoViewController alloc]init];
    
    userInfoVc.hidesBottomBarWhenPushed=YES;
    
    userInfoVc.userInfoModel=self.userInfoModel;
    
    [self.navigationController pushViewController:userInfoVc animated:YES];
    
    
}


-(void)loginButtonClick{

    LoginViewController *loginVc=[[LoginViewController alloc]init];
    
    loginVc.hidesBottomBarWhenPushed=YES;
    
    loginVc.tabbarIndex=2;

    [self.navigationController pushViewController:loginVc animated:YES];

}
- (void)messageButtonClicked {
    
    MessageViewController *messageVc=[[MessageViewController alloc]init];
    
    messageVc.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:messageVc animated:YES];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
}

#pragma mark--------订单view

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *orderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    
    
    UILabel *label=[GQControls createLabelWithFrame:CGRectMake(10, 0, 100, 30) andText:@"全部订单" andTextColor:[UIColor darkGrayColor] andFontSize:14];
    [orderView addSubview:label];
    
    
    UILabel *allOrderLabel=[GQControls createLabelWithFrame:CGRectMake(SCREEN_W-160, 0, 150, 30) andText:@"查看全部订单 >>" andTextColor:[UIColor darkGrayColor] andFontSize:12];
    allOrderLabel.textAlignment=NSTextAlignmentRight;
    [orderView addSubview:allOrderLabel];

    
    //添加手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(orderSrateButtonClick:)];
    [allOrderLabel addGestureRecognizer:tap];
    allOrderLabel.userInteractionEnabled=YES;
    
    
    
    
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 31, SCREEN_W, 0.5)];
    lineView1.backgroundColor=[UIColor lightGrayColor];
    [orderView addSubview:lineView1];
    
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, 99, SCREEN_W, 0.5)];
    lineView2.backgroundColor=[UIColor lightGrayColor];
    [orderView addSubview:lineView2];
    
    
    //左边隔 30        按钮  40       中间  (screen-60-40*3)/2
    
    NSArray *imageNameArray=@[@"date",@"waitpay",@"success"];
    NSArray *orderSrateArray=@[@"我的预约",@"待支付",@"已完成"];
    
    
    
    for (NSInteger i=0; i<3; i++) {
        
        
        //订单分类按钮
        UIButton *orderButton=[[UIButton alloc]initWithFrame:CGRectMake(30+((SCREEN_W-60-40*3)/2+40)*i, 38, 40, 40)];
        [orderButton setImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateNormal];
        [orderButton addTarget:self action:@selector(orderSrateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [orderView addSubview:orderButton];
        
        
        
        //订单分类label
        UILabel *orderLabel=[GQControls createLabelWithFrame:CGRectMake(20+((SCREEN_W-40-60*3)/2+60)*i, 82, 60, 10) andText:orderSrateArray[i] andTextColor:[UIColor darkGrayColor] andFontSize:11];
        orderLabel.textAlignment=NSTextAlignmentCenter;
        [orderView addSubview:orderLabel];
        

        
    }
    
    
    return orderView;
    
}


//点击进入订单页面
- (void)orderSrateButtonClick:(UIButton *)btn {
    
    NSLog(@"进入订单列表");
    
    OrderViewController *orderVc=[[OrderViewController alloc]init];
    
    orderVc.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:orderVc animated:NO];
    

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 100;
    
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

//cell点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
    NSLog(@"cell被点击%li",indexPath.row);
    
    if (indexPath.row==0){
        
        //跳到系统设置
        SettingViewController *settingVc=[[SettingViewController alloc]init];
        
        settingVc.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:settingVc animated:YES];
        
        
    }else if(indexPath.row==1) {
        
        //拨打客服电话，打完之后不会留在通讯录而是回到应用
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"021-37702979"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
    }else if(indexPath.row==2) {
        
        //分享
        
    } else if (indexPath.row == 3) {
        
        AboutUsPageVC *aboutUsPage = [[AboutUsPageVC alloc]init];
        aboutUsPage.hidesBottomBarWhenPushed = YES;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:aboutUsPage animated:YES];
        
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
