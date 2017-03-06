//
//  ForgetPwViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/2.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ForgetPwViewController.h"
#import "ChangePwViewController.h"



@interface ForgetPwViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end

@implementation ForgetPwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    
    
    self.getCodeButton.layer.masksToBounds=YES;
    
    self.getCodeButton.layer.cornerRadius=8;
    
    self.nextButton.layer.masksToBounds=YES;
    
    self.nextButton.layer.cornerRadius=8;
    
    [self.nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    

    [self setUpNavigationBar];
    
    
}


/*** 设置导航栏信息*/
-(void) setUpNavigationBar
{
    self.navigationItem.title = @"忘记密码";
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


-(void)nextButtonClicked{
    
    ChangePwViewController *changePwVc=[[ChangePwViewController alloc]init];
    
    [self.navigationController pushViewController:changePwVc animated:YES];
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
