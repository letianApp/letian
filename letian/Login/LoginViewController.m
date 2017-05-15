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


-(void)loginBtnClicked{
    
    [self.acountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
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
    params[@"LoginName"]           = [self.acountTextField.text.trim stringByReplacingOccurrencesOfString:@" " withString:@""];
    params[@"Password"]            = self.passwordTextField.text;
    params[@"Signature"]           = [signature YYApi_SHA1Encryption:nonce timeSp:timeSp];
    params[@"Timestamp"]           = timeSp;
    params[@"Nonce"]               = nonce;
    params[@"AppId"]               = APPID;
    params[@"PushNo"]              = @"121c83f76014d24bc2d";
//    [JPUSHService registrationID];
    NSLog(@"推送号：。。。。。%@",params[@"PushNo"]);
    __weak typeof(self) weakSelf   = self;
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;

        [MBHudSet dismiss:strongSelf.view];
        NSLog(@"登录%@",responseObject);
        NSLog(@"Msg%@",responseObject[@"Msg"]);
        if([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            
            [GQUserManager saveUserData:@{@"UserId":[NSString stringWithFormat:@"%@",responseObject[@"Result"][@"Source"][@"userid"]]} andToken:responseObject[@"Result"][@"Source"][@"access_token"]];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"rongCloudToken"] forKey:kRongYunToken];
            NSLog(@"token:%@",kFetchRToken);
            [[NSUserDefaults standardUserDefaults] setObject:strongSelf.acountTextField.text.trim forKey:kUserPhoneKey];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"enumUserType"] forKey:kUserType];

            [self getUserInfo];
            
            } else {
                
            [MBHudSet showText:responseObject[@"Msg"] andOnView:strongSelf.view];
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
        NSLog(@"&&&&&&&&&*获取用户信息%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"NickName"] forKey:kUserName];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"HeadImg"] forKey:kUserHeadImageUrl];
            RCUserInfo *currentUser = [RCIM sharedRCIM].currentUserInfo;
            currentUser.name = kFetchUserName;
            currentUser.portraitUri = kFetchUserHeadImageUrl;
            [[RCIM sharedRCIM]refreshUserInfoCache:currentUser withUserId:kFetchUserId];
            
            [[RCIM sharedRCIM] connectWithToken:kFetchRToken success:^(NSString *userId) {
                
//                __strong typeof(self) strongself = weakSelf;
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                NSLog(@"ID：%@",kFetchUserId);
                
                RCTextMessage *textMessage = [RCTextMessage messageWithContent:@"你好，欢迎来到乐天心理"];
                RCMessage *message = [[RCMessage alloc]init];
                message.conversationType = ConversationType_PRIVATE;
                message.targetId = kFetchUserId;
                message.messageDirection = MessageDirection_RECEIVE;
                message.senderUserId = @"222";
                message.content = textMessage;
//                [RCIM sharedRCIM] send
                
                [strongSelf dismissViewControllerAnimated:YES completion:nil];

                //        [[RCIM sharedRCIM] setUserInfoDataSource:strongself];
                //        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc]initWithUserId:userId name:kFetchUserName portrait:kFetchUserHeadImageUrl];
                
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%ld", (long)status);
                
                
                
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");
            }];

//            CustomCYLTabBar *tabBarController = [[CustomCYLTabBar alloc] init];
//            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController.tabBarController;

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


-(void)registBtnClicked
{
    
    RegistViewController *registVc=[[RegistViewController alloc]init];
    
    [self presentViewController:registVc animated:YES completion:nil];
    
}

//不登录随便看看
- (IBAction)doNotLogin:(id)sender {
    
//    CustomCYLTabBar *tabBarController = [[CustomCYLTabBar alloc] init];
//    
//    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController.tabBarController;
//    
//    tabBarController.tabBarController.selectedIndex = self.tabbarIndex;
        
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
