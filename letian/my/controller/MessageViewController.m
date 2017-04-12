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
@interface MessageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property(nonatomic,weak)CALayer *LGLayer;
@property(nonatomic,strong)UISegmentedControl *segment;

@end

@implementation MessageViewController

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden=NO;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    [self addChildViewController];

    [self setContentScrollView];
    
  
}


/*** 设置导航栏信息*/
-(void) setUpNavigationBar
{
    
    NSArray *array = [NSArray arrayWithObjects:@"咨询消息",@"系统消息", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.frame = CGRectMake(0, 0, 80, 30);
    segment.tintColor=MAINCOLOR;
    segment.selectedSegmentIndex=0;
    self.segment=segment;
    
    self.navigationItem.titleView=self.segment;
    
    
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


-(void)setContentScrollView {

    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    
    [self.view addSubview:sv];
    sv.bounces = NO;
    sv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    sv.contentOffset = CGPointMake(0, 0);
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    sv.scrollEnabled = YES;
    sv.userInteractionEnabled = YES;
    sv.delegate = self;
    
    for (int i=0; i<self.childViewControllers.count; i++) {
        UIViewController * vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(i * SCREEN_W, 0, SCREEN_W, SCREEN_H);
        [sv addSubview:vc.view];
        
    }
    
    sv.contentSize = CGSizeMake(2 * SCREEN_W, 0);
    self.contentScrollView = sv;
    
}



-(void)addChildViewController{
    
    ChatListViewController * vc1 = [[ChatListViewController alloc]init];
    
    [self addChildViewController:vc1];
    
    SystomMsgViewController * vc2 = [[SystomMsgViewController alloc]init];
    
    [self addChildViewController:vc2];
    
   
}


#pragma mark - UIScrollViewDelegate
//实现LGSegment代理方法

-(void)scrollToPage:(int)Page {
    
    CGPoint offset = self.contentScrollView.contentOffset;
    
    offset.x = SCREEN_W * Page;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentScrollView.contentOffset = offset;
        
    }];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    
    self.segment.selectedSegmentIndex=offsetX/SCREEN_W;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
