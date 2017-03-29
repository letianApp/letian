//
//  SetAcountViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/1.
//  Copyright © 2017年 J. All rights reserved.
//

#import "SetAcountViewController.h"
#import "CustomCYLTabBar.h"
#import "RegisterModel.h"
#import "MJExtension.h"
@interface SetAcountViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *sexTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;





@end

@implementation SetAcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.confirmBtn.layer.masksToBounds=YES;
    self.confirmBtn.layer.cornerRadius=8;
    
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
}

//确认
-(void)confirmBtnClick
{
    if (![self.sexTextField.text isEqualToString:@"男"] && ![self.sexTextField.text isEqualToString:@"女"]) {
        
        NSLog(@"请输入“男”或“女”");
        
        return;
    }
    
    
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendFormat:@"%@",API_NAME_REGISTER];

    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    
    params[@"NickName"]=self.nameTextField.text;
    params[@"Phone"]=self.phone;
    params[@"Password"]=self.passwordTextField.text;
    params[@"VerifyCode"]=self.msgCode;
    
    if ([self.sexTextField.text isEqualToString:@"男"]) {
        params[@"EnumSexType"]=@(0);
    }else if ([self.sexTextField.text isEqualToString:@"女"]){
        params[@"EnumSexType"]=@(1);
        
    }
    params[@"EnumUserType"]=@(1);
    
    NSLog(@"Params=%@",params);
   
    
    
    [manager POST:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"注册%@",responseObject);
        
        if([responseObject[@"Code"] integerValue] == 200){
            
            CustomCYLTabBar *tabBarController = [[CustomCYLTabBar alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController.tabBarController;
           
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误%@",error);
        //        [SVProgressHUD dismiss];
        // 如果是取消了任务，就不算请求失败，就直接返回
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            //            [SVProgressHUD showErrorWithStatus:@"发送短信超时"];
        } else {
            //            [SVProgressHUD showErrorWithStatus:@"发送短信失败"];
        }
    }];
    

    
    

    
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
