//
//  OrderDetailViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/16.
//  Copyright © 2017年 J. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wayLabel;
@property (weak, nonatomic) IBOutlet UILabel *consultTimelabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {    
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    [self SetUpViewLayer];
 }


#pragma mark------设置控件Layer

-(void)SetUpViewLayer{
    self.payButton.layer.borderWidth=1;
    self.payButton.layer.borderColor=[MAINCOLOR CGColor];
    self.payButton.layer.masksToBounds=YES;
    self.payButton.layer.cornerRadius=8;
    self.cancelButton.layer.borderWidth=1;
    self.cancelButton.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    self.cancelButton.layer.masksToBounds=YES;
    self.cancelButton.layer.cornerRadius=8;
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
