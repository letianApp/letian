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
    
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {
    
    UIButton *btn = [[UIButton alloc]init];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 20, 20)];
    backView.image = [UIImage imageNamed:@"pinkback"];
    [btn addSubview:backView];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

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
