//
//  OrderViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/10.
//  Copyright © 2017年 J. All rights reserved.
//

#import "OrderViewController.h"
#import "GQSegment.h"
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

-(void)setSegment {
    
    [self buttonList];
    //初始化
    //    LGSegment *segment = [[LGSegment alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - LG_scrollViewH - 50, self.view.frame.size.width, LG_segmentH)];
    GQSegment *segment = [[GQSegment alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    segment.delegate = self;
    self.segment = segment;
    [self.view addSubview:segment];
    [self.buttonList addObject:segment.buttonList];
    self.LGLayer = segment.LGLayer;
    
}
//实现LGSegment代理方法
-(void)scrollToPage:(int)Page {
    [UIView animateWithDuration:0.3 animations:^{
        
        NSLog(@"fewfewfweffwef");
    }];
}

-(void)createTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:UITableViewStylePlain];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    MessageCell *cell=[MessageCell cellWithTableView:tableView];
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text=@"fewfwe";
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 150;
    
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
    NSLog(@"cell被点击%li",indexPath.row);
    
}

/*** 设置导航栏信息*/
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
