//
//  AboutUsPageVC.m
//  letian
//
//  Created by J on 2017/3/30.
//  Copyright © 2017年 J. All rights reserved.
//

#import "AboutUsPageVC.h"

@interface AboutUsPageVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AboutUsPageVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self customNavigation];
    
    [self customTableView];
}

#pragma mark---------定制导航栏
- (void)customNavigation {
    self.navigationItem.title = @"关于我们";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.barTintColor = MAINCOLOR;
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"whiteback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (void)customTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navigationBar_H + statusBar_H, SCREEN_W, SCREEN_H - navigationBar_H - statusBar_H) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    [self customHeadViewWithTableView:tableView];
    NSLog(@"%f",SCREEN_H);
    
    UILabel *companyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_H - 40 - navigationBar_H - statusBar_H, SCREEN_W, 15)];
    [tableView addSubview:companyLab];
    companyLab.text = @"上海乐天心理咨询中心";
    companyLab.textAlignment = NSTextAlignmentCenter;
    companyLab.textColor = [UIColor darkGrayColor];
    companyLab.font = [UIFont systemFontOfSize:15];

}

- (void)customHeadViewWithTableView:(UITableView *)tableview {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H*0.37)];
    tableview.tableHeaderView = headView;
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"乐天logo"]];
    [headView addSubview:logoView];
    logoView.frame = CGRectMake(SCREEN_W*3/8, headView.height/4, SCREEN_W/4, SCREEN_W/4);
    logoView.layer.cornerRadius = 15;
    logoView.layer.borderWidth = 2;
    logoView.layer.borderColor = (MAINCOLOR.CGColor);
    logoView.layer.masksToBounds = YES;
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(logoView.x, logoView.bottom+10, SCREEN_W/4, 30)];
    [headView addSubview:titleLab];
    titleLab.text = @"乐天心理";
    titleLab.textAlignment = NSTextAlignmentCenter;
    UILabel *versionLab = [[UILabel alloc]initWithFrame:CGRectMake(logoView.x, titleLab.bottom, SCREEN_W/4, 20)];
    [headView addSubview:versionLab];
    versionLab.text = @"v0.8";
    versionLab.textAlignment = NSTextAlignmentCenter;
    versionLab.font = [UIFont systemFontOfSize:15];
    versionLab.textColor = [UIColor darkGrayColor];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AboutUsCellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;                        //设置cell不可以点
    NSArray *titleArr = @[@"微信公众号",@"联系电话",@"邮箱",@"官方网站"];
    NSArray *detailArr = @[@"乐天心理咨询",@"021-37702979",@"rightpsy@126.com",@"www.wzright.com"];
    cell.textLabel.text = titleArr[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = detailArr[indexPath.row];
    cell.detailTextLabel.textColor = MAINCOLOR;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
