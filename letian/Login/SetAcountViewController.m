//
//  SetAcountViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/1.
//  Copyright © 2017年 J. All rights reserved.
//

#import "SetAcountViewController.h"
#import "CustomCYLTabBar.h"
#import "MJExtension.h"
#import "BDImagePicker.h"
#import "UIImage+YYExtension.h"
@interface SetAcountViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegment;


@end

@implementation SetAcountViewController

- (IBAction)sexChoose:(id)sender {
//    NSLog(@"选择性别：%li",self.sexSegment.selectedSegmentIndex);
}

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
    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    
    
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendFormat:@"%@",API_NAME_REGISTER];

    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    
    params[@"NickName"]=self.nameTextField.text.trim;
    params[@"Phone"]=self.phone;
    params[@"Password"]=self.passwordTextField.text.trim;
    params[@"VerifyCode"]=self.msgCode;
    
    params[@"EnumSexType"]=@(self.sexSegment.selectedSegmentIndex);
    params[@"EnumUserType"]=@(1);
    
//    NSLog(@"Params=%@",params);
   
    
    [MBHudSet showStatusOnView:self.view];

    [manager POST:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];

//        NSLog(@"注册%@",responseObject);
        
        if([responseObject[@"Code"] integerValue] == 200){
            
            CustomCYLTabBar *tabBarController = [[CustomCYLTabBar alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController.tabBarController;
           
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.nameTextField resignFirstResponder];
    
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
