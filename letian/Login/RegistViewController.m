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



@end

@implementation RegistViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    self.getCodeBtn.layer.masksToBounds=YES;
    self.getCodeBtn.layer.cornerRadius=8;
    
    self.nextButton.layer.masksToBounds=YES;
    self.nextButton.layer.cornerRadius=8;
    

    [self.doButton addTarget:self action:@selector(doButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];


}

//是否选中
-(void)doButtonClick:(UIButton *)btn
{
    
    btn.selected=!btn.selected;
    
}


//乐天用户协议
- (IBAction)agreementBtnClick:(id)sender {
    
    
    
}

//下一步
- (void)nextButtonClick{
    
    SetAcountViewController *setAcountVc=[[SetAcountViewController alloc]init];
    
    [self presentViewController:setAcountVc animated:YES completion:nil];
    
}

//登录
- (IBAction)loginButtonClick:(id)sender {
    
    LoginViewController *loginVc=[[LoginViewController alloc]init];
    
    [self presentViewController:loginVc animated:YES completion:nil];
    
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
