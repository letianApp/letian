//
//  SetAcountViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/1.
//  Copyright © 2017年 J. All rights reserved.
//

#import "SetAcountViewController.h"


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
    
    UITabBarController *mainTbc = [[UITabBarController alloc]init];
    
    NSArray *vcName = @[@"FirstViewController",@"ConsultViewController",@"MyViewController"];
    NSMutableArray *vcArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < vcName.count; i++) {
        Class cls = NSClassFromString(vcName[i]);
        UIViewController *vc = [[cls alloc]init];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
        [vcArr addObject:nc];
    }
    
    mainTbc.viewControllers = vcArr;
    
    
    [UIApplication sharedApplication].keyWindow.rootViewController = mainTbc;

    
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
