//
//  ConsultViewController.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ConsultViewController.h"

@interface ConsultViewController ()

@end

@implementation ConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavigation];
    
    
    
    
}

#pragma mark 定制TabBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customTabBar];
    }
    return self;
}

- (void)customTabBar {
    
    self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"咨询" image:[[UIImage imageNamed:@"consultPagTab"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"consultPagTabSel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

}

#pragma mark 定制Navigation
- (void)customNavigation {
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:227/255.0 green:111/255.0 blue:117/255.0 alpha:1];
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/2, 40)];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"乐天心理" style:UIBarButtonItemStyleDone target:self action:@selector(selLeftButton)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"mainMessage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(selRightButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)selLeftButton {
    
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
