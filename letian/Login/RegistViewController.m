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

    params[@"authCode"]            =AUTHCODE;
    params[@"phone"]               = self.phoneTextField.text;
    params[@"enumSmsType"]         = @(2);
    
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
    
    
    
}

#pragma mark  ----------下一步

//下一步
- (void)nextButtonClick{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_UTILS];
    [requestString appendFormat:@"%@",API_NAME_CHECKCODE];
//    __weak typeof(self) weakSelf   = self;
    NSMutableDictionary *params    = [NSMutableDictionary dictionary];
    
    params[@"verifyCode"]            =self.codeTextField.text;
    params[@"phone"]               = self.phoneTextField.text;
    params[@"enumSmsType"]         = @(2);
    
    [MBHudSet showStatusOnView:self.view];

    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBHudSet dismiss:self.view];

//        NSLog(@"验证短信验证码%@",responseObject);
        
        if([responseObject[@"Code"] integerValue] == 200){
            
            
            SetAcountViewController *setAcountVc=[[SetAcountViewController alloc]init];
            setAcountVc.phone=self.phoneTextField.text;
            setAcountVc.msgCode=self.codeTextField.text;
            
            [self presentViewController:setAcountVc animated:YES completion:nil];
            
            
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
            
        }    }];
    

    
    
}

//登录
- (IBAction)loginButtonClick:(id)sender {
    
//    LoginViewController *loginVc=[[LoginViewController alloc]init];
//    [self presentViewController:loginVc animated:YES completion:nil];
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
