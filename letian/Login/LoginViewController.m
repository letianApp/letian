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
    
    params[@"PushNo"]               = @"";

    __weak typeof(self) weakSelf   = self;
    
    //        [SVProgressHUD showWithStatus:@"登录中..."];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //            [SVProgressHUD dismiss];
        
        NSLog(@"登录%@",responseObject);
        
        if([responseObject[@"code"] integerValue] == 200 && [responseObject[@"isSuccess"] boolValue] == YES){
            //存储用户信息
//            [CYUserManager saveUserData:@{@"UserId":responseObject[@"result"][@"source"][@"id"]} andToken:responseObject[@"result"][@"source"][@"access_token"]];
            
            //发送登录成功的通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
//            YYLOG(@" >>>> user login result (token) === %@",kFetchToken);
            
            
            
            CustomCYLTabBar *tabBarController = [[CustomCYLTabBar alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController.tabBarController;
            
            
            
        }else{
//            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        YYLOG(@">>>> user login result error === %@",error);
        
        
        
        // 如果是取消了任务，就不算请求失败，就直接返回
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
//            [SVProgressHUD showErrorWithStatus:@"登录超时"];
        } else {
//            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
    }];
    
    
    

   
    
    
}


-(void)registBtnClicked
{
    
    RegistViewController *registVc=[[RegistViewController alloc]init];
    
    [self presentViewController:registVc animated:YES completion:nil];
    
    
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
