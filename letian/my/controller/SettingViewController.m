//
//  SettingViewController.m
//  letian
//
//  Created by 郭茜 on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "SettingViewController.h"
#import "CYUserManager.h"
#import "LoginViewController.h"
#import "ChangePwCodeViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray=@[@"修改密码",@"清除缓存"];

    [self createTableView];
    
    [self createCancelButton];
    
    [self setUpNavigationBar];
}


- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-44) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled=NO;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
}

-(void)createCancelButton
{
    UIButton *cancalButton=[GQControls createButtonWithFrame:CGRectMake(0, SCREEN_H-44, SCREEN_W, 44) andTitle:@"退出登录" andTitleColor:[UIColor whiteColor] andFontSize:15 andBackgroundColor:MAINCOLOR];
    cancalButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [cancalButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancalButton];
}

//注销登录
-(void)cancelButtonClick{
    
    
    [CYUserManager removeAllUserInfo];
    
    
    LoginViewController *loginVc=[[LoginViewController alloc]init];
    
    [self.navigationController pushViewController:loginVc animated:YES];
    
    
    
}


#pragma mark--------TableViewDelegate----------

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 9, SCREEN_W, 1)];
        lineView.backgroundColor=[UIColor lightGrayColor];
        [view addSubview:lineView];
        return view;
    }
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:[GQControls createLabelWithFrame:CGRectMake(15, 5, 80, 19) andText:@"通知" andTextColor:[UIColor darkGrayColor] andFontSize:15]];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_W, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:lineView];

    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    
    cell.textLabel.textColor=[UIColor darkGrayColor];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    UIView *lineView=[[UIView alloc]init];
    
    if (indexPath.row==0) {
        lineView.frame=CGRectMake(15, 49, SCREEN_W-15, 1);
    }else if (indexPath.row==1){
        lineView.frame=CGRectMake(0, 49, SCREEN_W, 1);
    }
    lineView.backgroundColor=[UIColor lightGrayColor];

    [cell.contentView addSubview:lineView];
    
    if (indexPath.section==0) {
        cell.textLabel.text=self.dataArray[indexPath.row];
        
        [cell.contentView addSubview:[GQControls createImageButtonWithFrame:CGRectMake(SCREEN_W-30, 17.5, 15, 15) withImageName:@"detail"]];
        

    }else if (indexPath.section==1){
        cell.textLabel.text=@"文章更新推送";
        lineView.frame=CGRectMake(0, 49, SCREEN_W, 1);

    }
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
    if (indexPath.section==0) {
        //修改密码
        ChangePwCodeViewController *changePwCodeVc=[[ChangePwCodeViewController alloc]init];
        
        [self.navigationController pushViewController:changePwCodeVc animated:YES];
        
        if (indexPath.row==0) {
            
        }
        
        
    }else if (indexPath.section==1){
        
    }
}

/*** 设置导航栏信息*/
-(void) setUpNavigationBar
{
    
    self.navigationItem.title=@"系统设置";
    
    
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
