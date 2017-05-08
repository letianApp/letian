//
//  TestListViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import "TestListViewController.h"
#import "HomeCell.h"
#import "TestDetailViewController.h"
#import "TestListModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

@interface TestListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray <TestListModel *> *testList;

@end

@implementation TestListViewController

-(NSMutableArray *)testList
{
    if (_testList == nil) {
        _testList = [NSMutableArray array];
    }
    return _testList;
}


-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self setUpNavigationBar];
    
    [self createTableView];
    
    [self requestData];
    
}


#pragma mark------获取趣味测试列表

-(void)requestData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:@"http://bapi.xinli001.com/ceshi/ceshis.json/?rows=10&offset=0&category_id=2&rmd=-1&key=86467ca472d76f198f8aa89d186fa85e"];
    __weak typeof(self) weakSelf = self;
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        weakSelf.testList=[TestListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}


#pragma mark--------创建tableview
-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


#pragma mark -----------------tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.testList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

//cell定制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell=[HomeCell cellWithTableView:tableView];
    cell.titleLabel.text=self.testList[indexPath.row].title;
    cell.detailLabel.text=self.testList[indexPath.row].content;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.testList[indexPath.row].cover]];
    return cell;
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
    TestDetailViewController *testDetailVc=[[TestDetailViewController alloc]init];
    testDetailVc.testUrl=self.testList[indexPath.row].absolute_url;
    testDetailVc.testModel=self.testList[indexPath.row];
    [self.navigationController pushViewController:testDetailVc animated:NO];
    
}

//cell动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    CATransform3D rotation;
    rotation = CATransform3DMakeRotation((90.0*M_PI/180), 0.0, 0.7, 0.4);
    rotation.m44 = 1.0/-600;
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [UIView beginAnimations:@"rotaion" context:NULL];
    [UIView setAnimationDuration:0.3];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}


-(void) setUpNavigationBar
{
    self.navigationItem.title=@"心理测试";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame=CGRectMake(30, 12, 20, 20);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationController.navigationBar.translucent = NO;
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
