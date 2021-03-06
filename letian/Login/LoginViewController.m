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
#import "JPUSHService.h"
#import "GQUserManager.h"

#import <RongIMKit/RongIMKit.h>

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


- (void)loginBtnClicked {
    
    [self.acountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if ([self.acountTextField.text isEqualToString:@""]) {
        [MBHudSet showText:@"请输入账号" andOnView:self.view];
        return;
    }
    [MBHudSet showStatusOnView:self.view];

    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_LOGIN];
    NSMutableDictionary *params    = [NSMutableDictionary dictionary];
    NSString *signature            = @"";//加密字符串
    NSString *timeSp               = [NSString timestamp];//时间戳
    NSString *nonce                = [NSString randomString];//随机数
    //用户名
    params[@"LoginName"]           = [self.acountTextField.text.trim stringByReplacingOccurrencesOfString:@" " withString:@""];
    params[@"Password"]            = self.passwordTextField.text;
    params[@"Signature"]           = [signature YYApi_SHA1Encryption:nonce timeSp:timeSp];
    params[@"Timestamp"]           = timeSp;
    params[@"Nonce"]               = nonce;
    params[@"AppId"]               = APPID;
    params[@"PushNo"]              = [JPUSHService registrationID];
    
    NSLog(@"登录参数。。。。。%@",params);
    __weak typeof(self) weakSelf = self;
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        [MBHudSet dismiss:self.view];

        NSLog(@"登录%@",responseObject);
        if([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            
            [GQUserManager saveUserData:@{@"UserId":[NSString stringWithFormat:@"%@",responseObject[@"Result"][@"Source"][@"userid"]]} andToken:responseObject[@"Result"][@"Source"][@"access_token"]];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"rongCloudToken"] forKey:kRongYunToken];
//            NSLog(@"token:%@",kFetchRToken);
            [[NSUserDefaults standardUserDefaults] setObject:strongSelf.acountTextField.text.trim forKey:kUserPhoneKey];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"enumUserType"] forKey:kUserType];

            [strongSelf getUserInfo];
            
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [MBHudSet showText:responseObject[@"Msg"] andOnView:strongSelf.view];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        __strong typeof(self) strongSelf = weakSelf;

        [MBHudSet dismiss:strongSelf.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"登录超时" andOnView:strongSelf.view];
        }else{
            [MBHudSet showText:@"登录失败" andOnView:strongSelf.view];
        }
    }];
}

-(void)getUserInfo {
    
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_GETUSERINFO];
    __weak typeof(self) weakSelf = self;
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;

        [MBHudSet dismiss:strongSelf.view];
//        NSLog(@"&&&&&&&&&*获取用户信息%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"NickName"] forKey:kUserName];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"HeadImg"] forKey:kUserHeadImageUrl];
            [strongSelf.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];

            RCUserInfo *currentUser = [RCIM sharedRCIM].currentUserInfo;
            currentUser.name = kFetchUserName;
            currentUser.portraitUri = kFetchUserHeadImageUrl;
            [[RCIM sharedRCIM]refreshUserInfoCache:currentUser withUserId:kFetchUserId];
            
            [[RCIM sharedRCIM] connectWithToken:kFetchRToken success:^(NSString *userId) {
                
//                [strongSelf.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];


            } error:^(RCConnectErrorCode status) {
//                NSLog(@"登陆的错误码为:%ld", (long)status);
                
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//                NSLog(@"token错误");
                
                __strong typeof(self) strongSelf = weakSelf;
                
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"连接失败，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
                alertControl.view.tintColor=[UIColor blackColor];
                [strongSelf presentViewController:alertControl animated:YES completion:nil];
                
                [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    
                    LoginViewController *loginVc     = [[LoginViewController alloc]init];
                    loginVc.hidesBottomBarWhenPushed = YES;
                    [strongSelf presentViewController:loginVc animated:YES completion:nil];
                }]];
                [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                
            }];
        } else {
            
            [MBHudSet showText:responseObject[@"登陆失败，请重新登录"] andOnView:strongSelf.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        __strong typeof(self) strongSelf = weakSelf;

        [MBHudSet dismiss:strongSelf.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:strongSelf.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:strongSelf.view];
        }
    }];
}


-(void)registBtnClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//不登录随便看看
- (IBAction)doNotLogin:(id)sender {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

//点击忘记密码
- (IBAction)forgetBtnClick:(id)sender {
    
    ForgetPwViewController *forgetPwVc=[[ForgetPwViewController alloc]init];
    
//    [self.navigationController pushViewController:forgetPwVc animated:YES];
    [self presentViewController:forgetPwVc animated:YES completion:nil];
    
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
