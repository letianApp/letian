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
    
   
    CustomCYLTabBar *tabBarController = [[CustomCYLTabBar alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController.tabBarController;
    
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
