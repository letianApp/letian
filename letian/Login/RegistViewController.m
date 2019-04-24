//
//  RegistViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/1.
//  Copyright © 2017年 J. All rights reserved.
//

#import "RegistViewController.h"
#import "LoginViewController.h"
#import "SetAcountViewController.h"

#import "AgreeRegistVC.h"
#import "GQUserManager.h"
#import <RongIMKit/RongIMKit.h>


@interface RegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *doButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//定时器
@property (nonatomic,strong) NSTimer *timer;
//倒计时时间
@property (nonatomic,assign) NSInteger time;


@end

@implementation RegistViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.time=60;
    
    self.getCodeBtn.layer.masksToBounds=YES;
    self.getCodeBtn.layer.cornerRadius=8;
    
    self.nextButton.layer.masksToBounds=YES;
    self.nextButton.layer.cornerRadius=8;
    

    [self.getCodeBtn addTarget:self action:@selector(requestData:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.doButton addTarget:self action:@selector(doButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    

}


#pragma mark   ----------获取验证码

-(void)requestData:(UIButton *)button{
    
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
   
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_UTILS];
    [requestString appendFormat:@"%@",API_NAME_SENDMSG];
    __weak typeof(self) weakSelf   = self;
    NSMutableDictionary *params    = [NSMutableDictionary dictionary];

    params[@"authCode"]            = AUTHCODE;
    params[@"phone"]               = self.phoneTextField.text;
    params[@"enumSmsType"]         = @(1);
    
    [MBHudSet showStatusOnView:self.view];

    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBHudSet dismiss:self.view];

//        NSLog(@"发送短信%@",responseObject);
//        NSLog(@"%@",requestString);
        if([responseObject[@"Code"] integerValue] == 200){

            button.userInteractionEnabled = NO;
            [button setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)weakSelf.time] forState:UIControlStateNormal];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(changeText) userInfo:nil repeats:YES];
            weakSelf.getCodeBtn.titleLabel.alpha = 0.4;
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            weakSelf.timer = timer;
            
        }else{
            
            [MBHudSet showText:responseObject[@"Msg"] andOnView:self.view];

        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"错误%@",error);
        [MBHudSet dismiss:self.view];
        // 如果是取消了任务，就不算请求失败，就直接返回
        if (error.code == NSURLErrorCancelled) return;
        
        if (error.code == NSURLErrorTimedOut) {
            
            [MBHudSet showText:@"请求超时" andOnView:self.view];
            
        } else{
            
            [MBHudSet showText:@"请求失败" andOnView:self.view];
            
        }
    }];

    
    
}

-(void) changeText
{
    self.time--;
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        self.getCodeBtn.userInteractionEnabled = YES;
        self.getCodeBtn.titleLabel.alpha = 1;
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        return;
    }
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)self.time] forState:UIControlStateNormal];
}



-(void)doButtonClick:(UIButton *)btn
{
    //是否选中

    btn.selected=!btn.selected;
    
    
    if (btn.selected==NO) {
        self.nextButton.backgroundColor=[UIColor lightGrayColor];
        self.nextButton.userInteractionEnabled=NO;
    }else{
        self.nextButton.backgroundColor=MAINCOLOR;
        self.nextButton.userInteractionEnabled=YES;
    }
    
    
    
}


//乐天用户协议
- (IBAction)agreementBtnClick:(id)sender {
    
    AgreeRegistVC *avc = [[AgreeRegistVC alloc]init];
    [self presentViewController:avc animated:YES completion:nil];
//    [self.navigationController pushViewController:avc animated:YES];
    
}

#pragma mark  ----------登录

//下一步
- (void)nextButtonClick{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_LOGINBYSMS];
    NSMutableDictionary *params    = [NSMutableDictionary dictionary];
    NSString *signature            = @"";//加密字符串
    NSString *timeSp               = [NSString timestamp];//时间戳
    NSString *nonce                = [NSString randomString];//随机数
    //用户名
    params[@"phone"]               = self.phoneTextField.text;
    params[@"verifyCode"]          = self.codeTextField.text;
    params[@"Signature"]           = [signature YYApi_SHA1Encryption:nonce timeSp:timeSp];
    params[@"Timestamp"]           = timeSp;
    params[@"Nonce"]               = nonce;
    params[@"AppId"]               = APPID;
    
    __weak typeof(self) weakSelf   = self;
    [MBHudSet showStatusOnView:self.view];

    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;
        [MBHudSet dismiss:self.view];
//        NSLog(@"%@",responseObject);
        if([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            
            [GQUserManager saveUserData:@{@"UserId":[NSString stringWithFormat:@"%@",responseObject[@"Result"][@"Source"][@"userid"]]} andToken:responseObject[@"Result"][@"Source"][@"access_token"]];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"rongCloudToken"] forKey:kRongYunToken];
            //            NSLog(@"token:%@",kFetchRToken);
            [[NSUserDefaults standardUserDefaults] setObject:strongSelf.phoneTextField.text.trim forKey:kUserPhoneKey];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"enumUserType"] forKey:kUserType];
            
            [strongSelf getUserInfo];
            
        } else {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBHudSet showText:responseObject[@"Msg"] andOnView:strongSelf.view];
            });
            
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
            [strongSelf dismissViewControllerAnimated:YES completion:nil];

            RCUserInfo *currentUser = [RCIM sharedRCIM].currentUserInfo;
            currentUser.name = kFetchUserName;
            currentUser.portraitUri = kFetchUserHeadImageUrl;
            [[RCIM sharedRCIM]refreshUserInfoCache:currentUser withUserId:kFetchUserId];
            
            [[RCIM sharedRCIM] connectWithToken:kFetchRToken success:^(NSString *userId) {
                
//                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//                [strongSelf dismissViewControllerAnimated:YES completion:nil];
                
            } error:^(RCConnectErrorCode status) {
                
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

//登录
- (IBAction)loginButtonClick:(id)sender {
    
    LoginViewController *loginVc=[[LoginViewController alloc]init];
    [self presentViewController:loginVc animated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doNotLogin:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.phoneTextField resignFirstResponder];
    
    [self.codeTextField resignFirstResponder];
    
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
