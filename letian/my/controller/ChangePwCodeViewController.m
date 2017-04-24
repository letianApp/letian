//
//  ChangePwCodeViewController.m
//  letian
//
//  Created by 郭茜 on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ChangePwCodeViewController.h"
#import "ChangePwViewController.h"

@interface ChangePwCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic,strong) NSTimer *timer;//定时器
@property (nonatomic,assign) NSInteger time;//倒计时时间

@end

@implementation ChangePwCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    self.getCodeButton.layer.masksToBounds=YES;
    self.getCodeButton.layer.cornerRadius=8;
    self.nextButton.layer.masksToBounds=YES;
    self.nextButton.layer.cornerRadius=8;
    [self.getCodeButton addTarget:self action:@selector(getCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.time=60;
    
    [self setUpNavigationBar];
}


#pragma mark-------发送验证码

-(void)getCodeButtonClick:(UIButton *)button{
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_UTILS];
    [requestString appendFormat:@"%@",API_NAME_SENDMSG];
    __weak typeof(self) weakSelf   = self;
    NSMutableDictionary *params    = [NSMutableDictionary dictionary];
    params[@"authCode"]            =AUTHCODE;
    params[@"phone"]               = self.phoneTextFiled.text;
    params[@"enumSmsType"]         = @(4);
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        if([responseObject[@"Code"] integerValue] == 200){
            button.userInteractionEnabled = NO;
            [button setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)weakSelf.time] forState:UIControlStateNormal];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(changeText) userInfo:nil repeats:YES];
            weakSelf.getCodeButton.titleLabel.alpha = 0.4;
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            weakSelf.timer = timer;
        }else{
            [MBHudSet showText:responseObject[@"Msg"] andOnView:self.view];
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


#pragma mark-------倒计时
-(void) changeText
{
    self.time--;
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        self.getCodeButton.userInteractionEnabled = YES;
        self.getCodeButton.titleLabel.alpha = 1;
        [self.getCodeButton setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        return;
    }
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)self.time] forState:UIControlStateNormal];
}


#pragma mark-------验证验证码

-(void)nextButtonClicked{
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_UTILS];
    [requestString appendFormat:@"%@",API_NAME_CHECKCODE];
    NSMutableDictionary *params    = [NSMutableDictionary dictionary];
    params[@"verifyCode"]            =self.codeTextField.text;
    params[@"phone"]               = self.phoneTextFiled.text;
    params[@"enumSmsType"]         = @(4);
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        if([responseObject[@"Code"] integerValue] == 200){
           ChangePwViewController *changePwVc=[[ChangePwViewController alloc]init];
            changePwVc.phone=self.phoneTextFiled.text;
            changePwVc.msgCode=self.codeTextField.text;
            [self.navigationController pushViewController:changePwVc animated:YES];
        }else{
            [MBHudSet showText:responseObject[@"Msg"] andOnView:self.view];
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


-(void) setUpNavigationBar
{
    self.navigationItem.title = @"修改密码";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame=CGRectMake(30, 12, 20, 20);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
-(void) back
{
    [self.navigationController popViewControllerAnimated:YES];
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
