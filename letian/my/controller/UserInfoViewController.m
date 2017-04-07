//
//  UserInfoViewController.m
//  letian
//
//  Created by 郭茜 on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *sexLabel;
@property (nonatomic,strong)UILabel *phoneLabel;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray=@[@"头像",@"昵称",@"性别"];
    
    [self createTableView];
    
    [self setUpNavigationBar];
}


- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled=NO;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
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
        return 3;
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
        lineView.frame=CGRectMake(15, 49, SCREEN_W-15, 1);
        
        
        
        if (indexPath.row==0) {
            
            UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W-80, 5, 40, 40)];
            headImageView.image=[UIImage imageNamed:@"women"];
            headImageView.layer.masksToBounds=YES;
            headImageView.layer.cornerRadius=20;
            [cell.contentView addSubview:headImageView];
            
            self.headImageView=headImageView;
            
        }else if (indexPath.row==1){
            
            self.nameLabel=[GQControls createLabelWithFrame:CGRectMake(SCREEN_W-190, 15, 150, 20) andText:self.userInfoModel.NickName andTextColor:[UIColor darkGrayColor] andFontSize:15];
            self.nameLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:self.nameLabel];
            
            
        }else if (indexPath.row==2) {
            lineView.frame=CGRectMake(0, 49, SCREEN_W, 1);
            
            self.sexLabel=[GQControls createLabelWithFrame:CGRectMake(SCREEN_W-190, 15, 150, 20) andText:self.userInfoModel.SexString andTextColor:[UIColor darkGrayColor] andFontSize:15];
            self.sexLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:self.sexLabel];
            
        }
    }else if (indexPath.section==1){
        cell.textLabel.text=@"手机号";
        lineView.frame=CGRectMake(0, 49, SCREEN_W, 1);

        self.phoneLabel=[GQControls createLabelWithFrame:CGRectMake(SCREEN_W-165, 15, 150, 20) andText:self.userInfoModel.MobilePhone andTextColor:[UIColor darkGrayColor] andFontSize:15];
        self.phoneLabel.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:self.phoneLabel];

    }
    
    return cell;
    
    
}


/*** 设置导航栏信息*/
-(void) setUpNavigationBar
{
    
    self.navigationItem.title=@"个人资料";
    
    
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
