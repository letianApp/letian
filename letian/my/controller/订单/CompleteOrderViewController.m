//
//  CompleteOrderViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/16.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CompleteOrderViewController.h"

@interface CompleteOrderViewController ()

@end

@implementation CompleteOrderViewController

- (void)viewDidLoad {    
    [super viewDidLoad];
    
    [self setUpNavigationBar];
}


-(void) setUpNavigationBar
{
    self.navigationItem.title=@"订单详情";
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
