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
#import "CYLTabBarController.h"

@interface CounselorInfoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIView *holdView;
@property (nonatomic, strong) UITabBar *tabBar;

@end

@implementation CounselorInfoVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
        
//    self.view.backgroundColor = [UIColor whiteColor];
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
    _mainTableView.estimatedRowHeight = 44.0;
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _holdView = [[UIView alloc]init];
    _holdView.backgroundColor = MAINCOLOR;
    [_mainTableView addSubview:_holdView];

}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConfirmPageCell *cell = [ConfirmPageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;                        //设置cell不可以点
    
    NSArray *lableTagArr = @[@"简介",@"擅长领域",@"咨询风格"];
    cell.labelTag.text = lableTagArr[indexPath.row];
    
    NSArray *detialArr = @[@"国家二级心理咨询师，北京师范大学应用心理学博士，上海心理卫生学会会员，上海某国际中学心理专家，《中学生报》专栏心理专家，心理咨询师考试培训教师，国家注册高级青少年心理成长导师，海南省职业教育研究所名誉顾问",@"青少年成长问题、亲子关系，焦虑、强迫、恐惧等神经症问题，家庭情感问题、人际交往、职场压力。",@"善于通过细致耐心的心理系统分析，准确把握来访者的心理结构、人格特质，以亲和与平易的咨询风格启发和引导来访者的自我探索，陪伴来访者一起心理成长，深度挖掘来访者内在心理资源，发展其自身的心理能量。"];
    cell.detialLab.text = detialArr[indexPath.row];
    
    return cell;
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark 头部视图
- (void)customHeadView {
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H*0.3)];
    _headView.backgroundColor = MAINCOLOR;
    _mainTableView.tableHeaderView = _headView;
    //咨询师头像
    UIImageView *picView = [[UIImageView alloc]init];
    [picView setImage:[UIImage imageNamed:@"wowomen"]];
    picView.layer.cornerRadius = SCREEN_W/10;
    picView.layer.borderWidth = 1;
    picView.layer.borderColor = ([UIColor whiteColor].CGColor);
    picView.layer.masksToBounds = YES;
    [_headView addSubview:picView];
    [picView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_headView.mas_centerX);
        make.centerY.equalTo(_headView.mas_centerY);
        make.width.equalTo(_headView.mas_width).multipliedBy(0.2);
        make.height.equalTo(_headView.mas_width).multipliedBy(0.2);
    }];
    
    float lineHeight = (_headView.height/2-_headView.width*0.1)/7;
    NSLog(@"%f",lineHeight);
    //咨询师名字
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W*2/5, _headView.height-lineHeight*6, SCREEN_W/5, lineHeight*2)];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = @"孙晓平";
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont systemFontOfSize:14 weight:2];
    [_headView addSubview:nameLab];
//    nameLab.backgroundColor = [UIColor yellowColor];
    //咨询师称号
    UILabel *statusLab = [[UILabel alloc]init];
//    statusLab.backgroundColor = [UIColor yellowColor];
    [_headView addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nameLab.mas_centerX);
        make.top.equalTo(nameLab.mas_bottom).offset(lineHeight);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.3);
        make.height.equalTo(nameLab.mas_height);
    }];
    statusLab.textAlignment = NSTextAlignmentCenter;
    statusLab.text = @"专家心理咨询师";
    statusLab.textColor = [UIColor whiteColor];
    statusLab.font = [UIFont systemFontOfSize:12];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _mainTableView) {
        _holdView.frame = CGRectMake(0, 0, SCREEN_W, _mainTableView.contentOffset.y);
    }
}

#pragma mark 定制底部TabBar
- (void)creatBottomBar {
    
    _tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_H-tabBar_H, SCREEN_W, tabBar_H)];
    //预约按钮
    UIButton *AppointmentBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*2/3, 0, SCREEN_W/3, tabBar_H)];
    AppointmentBtn.backgroundColor = MAINCOLOR;
//    [AppointmentBtn setBackgroundImage:[UIImage imageNamed:@"btnBackImage"] forState:UIControlStateNormal];
    [AppointmentBtn setTitle:@"预约" forState:UIControlStateNormal];
    [AppointmentBtn addTarget:self action:@selector(clickAppointmentBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:AppointmentBtn];
    //咨询按钮
    UIButton *askBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 3, tabBar_H*2/3, tabBar_H*2/3)];
    [_tabBar addSubview:askBtn];
    [askBtn setImage:[UIImage imageNamed:@"ask"] forState:UIControlStateNormal];
    [askBtn addTarget:self action:@selector(clickAskBrn) forControlEvents:UIControlEventTouchUpInside];
    UILabel *askLab = [[UILabel alloc]initWithFrame:CGRectMake(15, tabBar_H*2/3, tabBar_H*2/3, tabBar_H/3)];
    [_tabBar addSubview:askLab];
    askLab.text = @"咨询";
    askLab.textAlignment = NSTextAlignmentCenter;
    askLab.font = [UIFont systemFontOfSize:10];
    askLab.textColor = [UIColor darkGrayColor];
    [self.view addSubview:_tabBar];
    //价格lable
    UILabel *priceLab = [[UILabel alloc]init];
    priceLab.adjustsFontSizeToFitWidth = YES;
    [_tabBar addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(AppointmentBtn.mas_left).offset(-SCREEN_W/100);
        make.top.equalTo(_tabBar.mas_top);
        make.width.equalTo(_tabBar.mas_width).multipliedBy(0.3);
        make.height.equalTo(_tabBar.mas_height);
    }];
    priceLab.textColor = MAINCOLOR;
    priceLab.text = @"1000元／小时";
    priceLab.textAlignment = NSTextAlignmentRight;
    priceLab.font = [UIFont boldSystemFontOfSize:15];
    //优惠lable
    UILabel *couponLab = [[UILabel alloc]init];
    [_tabBar addSubview:couponLab];
    [couponLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(priceLab.mas_right);
        make.bottom.equalTo(_tabBar.mas_bottom);
        make.width.equalTo(priceLab.mas_width);
        make.height.equalTo(priceLab.mas_height).multipliedBy(0.5);
    }];
    couponLab.text = @"4小时以上88折";
    couponLab.textColor = [UIColor orangeColor];
    couponLab.textAlignment = NSTextAlignmentRight;
    couponLab.font = [UIFont boldSystemFontOfSize:10];
    
}

- (void)clickAskBrn {
    NSLog(@"点击咨询按钮");
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
