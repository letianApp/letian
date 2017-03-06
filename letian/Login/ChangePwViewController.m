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


/*** 设置导航栏信息*/
-(void) setUpNavigationBar
{
    self.navigationItem.title = @"重设密码";
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


-(void)confirmButtonClicked
{
    
    LoginViewController *loginVc=[[LoginViewController alloc] init];
    
    [self.navigationController pushViewController:loginVc animated:YES];
    
    
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
