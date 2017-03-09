//
//  CounselorInfoVC.m
//  letian
//
//  Created by J on 2017/3/9.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CounselorInfoVC.h"
#import "ConfirmPageCell.h"
#import "ConfirmPageVC.h"

@interface CounselorInfoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UITabBar *tabBar;

@end

@implementation CounselorInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor = MAINCOLOR;
    [self customNavigation];
    [self customMainTableView];
    [self customHeadView];
    [self creatBottomBar];
}


#pragma mark 定制导航栏
- (void)customNavigation {
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
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

- (void)clickShareBtn {
    NSLog(@"分享");
}

#pragma mark 主界面tableview
- (void)customMainTableView {
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-tabBar_H) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTableView];
    _mainTableView.backgroundColor = [UIColor whiteColor];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    //自动计算高度 iOS8
    _mainTableView.estimatedRowHeight=44.0;
    _mainTableView.rowHeight=UITableViewAutomaticDimension;
    
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConfirmPageCell *cell = [ConfirmPageCell cellWithTableView:tableView];
    
    NSArray *lableTagArr = @[@"简介",@"资讯特点",@"擅长领域",@"咨询理念"];
    cell.labelTag.text = lableTagArr[indexPath.row];
    
    
    return cell;
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

#pragma mark 头部视图
- (void)customHeadView {
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H/3-10)];
    _headView.backgroundColor = MAINCOLOR;
    _mainTableView.tableHeaderView = _headView;
    //咨询师头像
    UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W*2/5, statusBar_H+navigationBar_H, SCREEN_W/5, SCREEN_W/5)];
    [picView setImage:[UIImage imageNamed:@"wowomen"]];
    picView.layer.cornerRadius = SCREEN_W/10;
    picView.layer.borderWidth = 1;
    picView.layer.borderColor = ([UIColor whiteColor].CGColor);
    picView.layer.masksToBounds = YES;
    [_headView addSubview:picView];
    //咨询师名字
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W*2/5, (statusBar_H+navigationBar_H+SCREEN_W/5+10), SCREEN_W/5, 20)];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = @"孙晓平";
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont boldSystemFontOfSize:15];
    [_headView addSubview:nameLab];
    
}



#pragma mark 定制底部TabBar
- (void)creatBottomBar {
    
    _tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_H-tabBar_H, SCREEN_W, tabBar_H)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*2/3, 0, SCREEN_W/3, tabBar_H)];
    btn.backgroundColor = MAINCOLOR;
    [btn setTitle:@"预约" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAppointmentBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:btn];
    
    [self.view addSubview:_tabBar];
}

- (void)clickAppointmentBtn {
    NSLog(@"点击预约按钮");
    ConfirmPageVC *cvc = [[ConfirmPageVC alloc]init];
    [self.rt_navigationController pushViewController:cvc animated:YES];
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
