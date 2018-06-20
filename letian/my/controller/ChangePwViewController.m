//
//  ChangePwViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ChangePwViewController.h"
#import "LoginViewController.h"

@interface ChangePwViewController ()

@property (weak, nonatomic) IBOutlet UITextField *changeTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation ChangePwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.confirmButton.layer.masksToBounds=YES;
    self.confirmButton.layer.cornerRadius=8;
    [self.confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpNavigationBar];
}


#pragma mark------------修改密码

-(void)confirmButtonClicked
{
    //密码输入不一致
    if (![self.changeTextField.text isEqualToString:self.confirmTextField.text]) {
        [MBHudSet showText:@"密码不一致" andOnView:self.view];
        return;
    }
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendFormat:@"%@",API_NAME_CHANGEPW];
    NSMutableDictionary *params    = [NSMutableDictionary dictionary];
    params[@"VerifyCode"]            =self.msgCode;
    params[@"Phone"]               = self.phone;
    params[@"NewPassword"]         = self.changeTextField.text;
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        if([responseObject[@"Code"] integerValue] == 200){
            LoginViewController *loginVc=[[LoginViewController alloc]init];
            loginVc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:loginVc animated:YES];
            [MBHudSet showText:@"密码已修改，请重新登录" andOnView:self.view];
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
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    backButton.frame=CGRectMake(30, 12, 20, 20);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//}
//-(void) back
//{
//    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {
    
    UIButton *btn = [[UIButton alloc]init];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 20, 20)];
    backView.image = [UIImage imageNamed:@"pinkback"];
    [btn addSubview:backView];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
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
