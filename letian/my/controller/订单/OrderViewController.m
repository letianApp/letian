//
//  OrderViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/10.
//  Copyright © 2017年 J. All rights reserved.
//

#import "OrderViewController.h"
#import "GQSegment.h"
#import "OrderCell.h"
#import "OrderDetailViewController.h"

@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,SegmentDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, weak) GQSegment *segment;
@property(nonatomic,weak)CALayer *LGLayer;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    
    [self setUpNavigationBar];
    
    [self setSegment];

    [self createTableView];
}

- (NSMutableArray *)buttonList
{
    if (!_buttonList)
    {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}


#pragma mark-------创建Segment

-(void)setSegment {
    [self buttonList];
    GQSegment *segment = [[GQSegment alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    segment.delegate = self;
    self.segment = segment;
    [self.view addSubview:segment];
    [self.buttonList addObject:segment.buttonList];
    self.LGLayer = segment.LGLayer;
}


#pragma mark-------滑动到页面
-(void)scrollToPage:(int)Page {
    [UIView animateWithDuration:0.3 animations:^{
        NSLog(@"fewfewfweffwef");
    }];
}


#pragma mark-------创建TableView

-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.tableHeaderView=self.segment;
    self.tableView = tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell=[OrderCell cellWithTableView:tableView];
    return cell;
}


#pragma mark------跳到订单详情

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    OrderDetailViewController *orderDetailVc=[[OrderDetailViewController alloc]init];
    [self.navigationController pushViewController:orderDetailVc animated:YES];
}


-(void) setUpNavigationBar
{
    self.navigationItem.title=@"我的订单";
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
