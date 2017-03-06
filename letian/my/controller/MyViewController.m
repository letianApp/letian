//
//  MyViewController.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;


@end

@implementation MyViewController


-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden=YES;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
}


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.dataArray=@[@"系统设置",@"客服电话",@"客服电话",@"关于我们"];
    
    [self createTableView];
    
}


-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableHeaderView=[self createHeadView];
    
}


#pragma mark--------账户头像

-(UIView *)createHeadView{
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 220)];
    
    headView.backgroundColor=MAINCOLOR;
    
    return headView;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}

#pragma mark--------订单view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *orderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    
    UILabel *allOrderLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_W-20, 30)];
    
    allOrderLabel.text=@"全部订单 >>";
    allOrderLabel.textAlignment=NSTextAlignmentRight;
    allOrderLabel.font=[UIFont systemFontOfSize:15];
    [orderView addSubview:allOrderLabel];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 31, SCREEN_W, 0.5)];
    lineView1.backgroundColor=[UIColor lightGrayColor];
    [orderView addSubview:lineView1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, 99, SCREEN_W, 0.5)];
    lineView2.backgroundColor=[UIColor lightGrayColor];
    [orderView addSubview:lineView2];
    
    
    //左边隔 30        按钮  40       中间  (screen-60-40*3)/2
    
    NSArray *orderSrateArray=@[@"我的预约",@"待支付",@"已完成"];
    for (NSInteger i=0; i<3; i++) {
        
        UIButton *orderButton=[[UIButton alloc]initWithFrame:CGRectMake(30+((SCREEN_W-60-40*3)/2+40)*i, 38, 40, 40)];
        UILabel *orderLabel=[[UILabel alloc]initWithFrame:CGRectMake(20+((SCREEN_W-40-60*3)/2+60)*i, 82, 60, 10)];
        orderLabel.text=orderSrateArray[i];
        orderLabel.textAlignment=NSTextAlignmentCenter;
        orderLabel.font=[UIFont systemFontOfSize:10];
        
        [orderButton addTarget:self action:@selector(orderSrateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [orderView addSubview:orderButton];
        [orderView addSubview:orderLabel];
        
    }
    
    
    return orderView;
    
}

//点击进入订单页面
-(void)orderSrateButtonClick:(UIButton *)btn
{
    
    
    
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 100;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    cell.textLabel.text=self.dataArray[indexPath.row];
    
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_W, 0.5)];
    
    lineView.backgroundColor=[UIColor lightGrayColor];
    
    [cell.contentView addSubview:lineView];
    
    
    
    return cell;
    
    
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];

    NSLog(@"cell被点击%li",indexPath.row);
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
