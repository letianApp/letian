//
//  TestViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import "TestViewController.h"
#import "MJExtension.h"
#import "GQSegmentedControl.h"
#import "TestListViewController.h"
#import "TestHistoryViewController.h"
#import "AppDelegate.h"

@interface TestViewController ()<GQSegmentDelegate>

@property (nonatomic,strong ) GQSegmentedControl *segment;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    
    [self createSegment];
}



-(void)createSegment
{
    TestListViewController * vc1 = [[TestListViewController alloc]init];
    vc1.title=@"开始测评";
    TestHistoryViewController * vc2 = [[TestHistoryViewController alloc]init];
    vc2.title=@"测评历史";
    NSMutableArray *vcArray=[[NSMutableArray alloc]initWithObjects:vc1,vc2, nil];
    
    self.segment = [[GQSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64)];
    self.segment.delegate = self;
    self.segment.tintColor = MAINCOLOR;
    self.segment.viewControllers = vcArray;
    self.segment.segmentedControl.width = 60;
    [self.segment showsInNavBarOf:self withFrame:CGRectMake(5, 5, 120, 30)];
    [self.view addSubview:self.segment];
    
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame=CGRectMake(30, 12, 20, 20);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}


-(void) back
{
    
    [self.navigationController popViewControllerAnimated:YES];
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.rotation_Style = 0;
}
//
//-(void)viewWillAppear:(BOOL)animated{
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.rotation_Style = 1;
//    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
//    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
//    
//    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
//}
//
//-(BOOL)shouldAutorotate{
//    return true;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations//当前viewcontroller支持哪些转屏方向
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}


-(void)segmentDidselectTab:(NSUInteger)index
{
    UIViewController * vc = self.segment.viewControllers[index];
    [vc viewWillAppear:YES];
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
