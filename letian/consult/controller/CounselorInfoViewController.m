//
//  CounselorInfoViewController.m
//  letian
//
//  Created by J on 2017/3/2.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CounselorInfoViewController.h"
#import "orderPageCell.h"
#import "counselorInfoModel.h"

@interface CounselorInfoViewController ()<UITableViewDataSource,UITableViewDelegate>




@property (nonatomic, strong) UIScrollView *mainScroview;
@property (nonatomic, strong) UITableView *mainTableview;
@property (nonatomic, strong) UIView *holdView;                      //下滑占用图
@property (nonatomic, copy) NSArray *dataSourceArr;

@end

@implementation CounselorInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAINCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self test];
    [self customNavigation];
    [self creatMainTableview];
    [self creatBottomBar];

    
}

- (void)test {
    
    _dataSourceArr = @[@"毕业于山东大学，国家二级心理咨询师，心理动力学取向。持续接受精神分析系统培训，长期接受心理动力学取向案例督导及个人体验。咨询风格亲和包容。咨询理念：跟随心的指引，勇敢面对真实。",@"亲和、温和、真诚，易建立咨访关系。洞察力敏锐，思路清晰。",@"自我探索与成长、情绪问题（抑郁、焦虑、恐惧）、亲密关系、亲子关系、人际关系等。",@"面对困惑与艰辛，鼓起勇气，让我们一起去探索自我以及生活真实的模样"];
    
}

#pragma mark 返回按钮
- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"whiteback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
    
}

- (void)customNavigation {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)clickShareBtn {
    NSLog(@"分享");
}

#pragma mark 创建主界面滚动视图
- (void)creatMainScroview{
    
    _mainScroview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_H/3, SCREEN_W, SCREEN_H/4*3-tabBar_H)];
    _mainScroview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScroview];
    
}

#pragma mark 底部TabBar
- (void)creatBottomBar {
    
    UITabBar *bar = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_H-tabBar_H, SCREEN_W, tabBar_H)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - 100, 0, 100, tabBar_H)];
    btn.backgroundColor = MAINCOLOR;
    [btn setTitle:@"预约" forState:UIControlStateNormal];
    [bar addSubview:btn];
    
    
    [self.view addSubview:bar];

}



# pragma mark 创建TableView
- (void)creatMainTableview {
    
    _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-tabBar_H) style:UITableViewStyleGrouped];
//    _mainTableview.contentInset = UIEdgeInsetsMake(SCREEN_H/3, 0, 0, 0);
    [self.view addSubview:_mainTableview];
    [self customHeadView];
    _mainTableview.backgroundColor = [UIColor whiteColor];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.estimatedRowHeight = 44.0;
    _mainTableview.rowHeight = UITableViewAutomaticDimension;
    _mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _holdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 0)];
    _holdView.backgroundColor = MAINCOLOR;
    

}

# pragma mark 创建TableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    orderPageCell *cell = [orderPageCell cellWithTableView:tableView];
    cell.textLab.text = _dataSourceArr[indexPath.section];
    return cell;
    
}

# pragma mark 定制头部视图
- (void)customHeadView {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H/3)];
    headView.backgroundColor = MAINCOLOR;
    //
    UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W*2/5, statusBar_H+navigationBar_H, SCREEN_W/5, SCREEN_W/5)];
    [picView setImage:[UIImage imageNamed:@"wowomen"]];
    picView.layer.cornerRadius = SCREEN_W/10;
    picView.layer.borderWidth = 1;
    picView.layer.borderColor = ([UIColor whiteColor].CGColor);
    picView.layer.masksToBounds = YES;
    [headView addSubview:picView];
    //
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W*2/5, (statusBar_H+navigationBar_H+SCREEN_W/5+10), SCREEN_W/5, 20)];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = @"孙晓平";
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont boldSystemFontOfSize:15];
    [headView addSubview:nameLab];
    
    _mainTableview.tableHeaderView = headView;
    
    
}

# pragma mark 滚动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainTableview)
    {
        
        float i = scrollView.contentOffset.y;
        
        NSLog(@"%f",i);
        CGFloat sectionHeaderHeight = SCREEN_H/3; //sectionHeaderHeight
        if (scrollView.contentOffset.y < 0) {
            [scrollView addSubview:_holdView];
            _holdView.frame = CGRectMake(0, 0, SCREEN_W, (scrollView.contentOffset.y));
        } else {
            [scrollView willRemoveSubview:_holdView];
            NSLog(@"移除");
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 20)];
    headSectionView.backgroundColor = [UIColor whiteColor];
    UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 5, 15)];
    tagView.backgroundColor = MAINCOLOR;
    [headSectionView addSubview:tagView];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(18, 5, 100, 15)];
    titleLab.font = [UIFont boldSystemFontOfSize:15];
    NSArray *titleArr = @[@"简介：",@"资讯特点：",@"擅长领域：",@"咨询理念："];
    titleLab.text = titleArr[section];
    [headSectionView addSubview:titleLab];
    
    return headSectionView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


- (void)viewWillDisappear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = NO;

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
