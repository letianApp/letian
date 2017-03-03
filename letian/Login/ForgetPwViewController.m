//
//  ForgetPwViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/2.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ForgetPwViewController.h"

@interface ForgetPwViewController ()

@end

@implementation ForgetPwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title = @"忘记密码";
    self.navigationController.navigationBar.tintColor = MAINCOLOR;

//    [self setUpNavigationBar];
}


///*** 设置导航栏信息*/
//-(void) setUpNavigationBar
//{
//    self.navigationItem.title = @"忘记密码";
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [backButton sizeToFit];
//    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//}
//
//-(void) back
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

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
