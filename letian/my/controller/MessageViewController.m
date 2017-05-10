//
//  MessageViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/7.
//  Copyright © 2017年 J. All rights reserved.
//

#import "MessageViewController.h"
#import "SystomMsgViewController.h"
#import "ChatListViewController.h"
#import "GQSegmentedControl.h"

@interface MessageViewController ()<GQSegmentDelegate>

@property (nonatomic,strong ) GQSegmentedControl *segment;

@end

@implementation MessageViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSegment];
}


-(void)createSegment
{
    ChatListViewController * vc1 = [[ChatListViewController alloc]init];
    vc1.title=@"咨询消息";
    SystomMsgViewController * vc2 = [[SystomMsgViewController alloc]init];
    vc2.title=@"系统消息";
    NSMutableArray *vcArray=[[NSMutableArray alloc]initWithObjects:vc1,vc2, nil];
    
    self.segment = [[GQSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64)];
    self.segment.delegate = self;
    self.segment.tintColor = MAINCOLOR;
    self.segment.viewControllers = vcArray;
    self.segment.segmentedControl.width = 60;
    [self.segment showsInNavBarOf:self withFrame:CGRectMake(5, 5, 120, 30)];
    [self.view addSubview:self.segment];
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    backButton.frame=CGRectMake(30, 12, 20, 20);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}


//-(void) back
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)segmentDidselectTab:(NSUInteger)index
{
    UIViewController * vc = self.segment.viewControllers[index];
    [vc viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
