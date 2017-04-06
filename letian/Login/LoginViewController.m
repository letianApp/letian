//
//  LoginViewController.m
//  letian
//
//  Created by 郭茜 on 2017/2/28.
//  Copyright © 2017年 J. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstViewController.h"
#import "AppDelegate.h"
#import "RegistViewController.h"
#import "ForgetPwViewController.h"
#import "CustomCYLTabBar.h"
#import "NSString+YYExtension.h"
#import "JPUSHService.h"
#import "CYUserManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *acountTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;


@end

@implementation LoginViewController


-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden=YES;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.loginBtn.layer setMasksToBounds:YES];
    [self.loginBtn.layer setCornerRadius:8];
    [self.registBtn.layer setMasksToBounds:YES];
    [self.registBtn.layer setCornerRadius:8];
    [self.loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.registBtn addTarget:self action:@selector(registBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)loginBtnClicked{
    
    if ([self.acountTextField.text isEqualToString:@""]) {
        [MBHudSet showText:@"请输入账号" andOnView:self.view];
        return;
    }
    
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_LOGIN];
    NSMutableDictionary *params    = [NSMutableDictionary dictionary];
    NSString *signature            = @"";//加密字符串
    NSString *timeSp               = [NSString timestamp];//时间戳
    NSString* nonce                = [NSString randomString];//随机数
    //用户名
    params[@"LoginName"]               = [self.acountTextField.text.trim stringByReplacingOccurrencesOfString:@" " withString:@""];
    //密码
    params[@"Password"]            =self.passwordTextField.text;
    
    //加密签名字符串
    params[@"Signature"]           = [signature YYApi_SHA1Encryption:nonce timeSp:timeSp];
    
    //时间戳
    params[@"Timestamp"]           = timeSp;

    //随机数
    params[@"Nonce"]               = nonce;

    //应用接入ID
    params[@"AppId"]               = APPID;

    
    params[@"PushNo"]               = [JPUSHService registrationID];;

    __weak typeof(self) weakSelf   = self;
    
    [MBHudSet showStatusOnView:self.view];
    
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        [MBHudSet dismiss:self.view];
            
        NSLog(@"登录%@",responseObject);
        NSLog(@"Msg%@",responseObject[@"Msg"]);

        if([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES){
            //存储用户信息
            [CYUserManager saveUserData:@{@"UserId":responseObject[@"Result"][@"Source"][@"userid"]} andToken:responseObject[@"Result"][@"Source"][@"access_token"]];
            
            NSLog(@"token:%@",kFetchToken);

            [[NSUserDefaults standardUserDefaults] setObject:self.acountTextField.text.trim forKey:kUserPhoneKey];
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
            
            
            CustomCYLTabBar *tabBarController = [[CustomCYLTabBar alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController.tabBarController;
            
            
            
        }else{
            

            [MBHudSet showText:responseObject[@"Msg"] andOnView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBHudSet dismiss:self.view];

        
        // 如果是取消了任务，就不算请求失败，就直接返回
        if (error.code == NSURLErrorCancelled) return;
        
        if (error.code == NSURLErrorTimedOut) {
            
            [MBHudSet showText:@"登录超时" andOnView:self.view];
        
        } else{
            
            [MBHudSet showText:@"登录失败" andOnView:self.view];

        }
    }];
    
    
  
    
}


-(void)registBtnClicked
{
    
    RegistViewController *registVc=[[RegistViewController alloc]init];
    
    [self presentViewController:registVc animated:YES completion:nil];
    
    
}

//不登录随便看看
- (IBAction)doNotLogin:(id)sender {
    
    CustomCYLTabBar *tabBarController = [[CustomCYLTabBar alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController.tabBarController;
    tabBarController.tabBarController.selectedIndex = self.tabbarIndex;

}

//点击忘记密码
- (IBAction)forgetBtnClick:(id)sender {
    
    ForgetPwViewController *forgetPwVc=[[ForgetPwViewController alloc]init];
    
    [self.navigationController pushViewController:forgetPwVc animated:YES];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.acountTextField resignFirstResponder];
    
    [self.passwordTextField resignFirstResponder];
    
    
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
