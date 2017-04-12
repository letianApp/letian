//
//  OrderPageVC.m
//  letian
//
//  Created by J on 2017/3/22.
//  Copyright © 2017年 J. All rights reserved.
//

#import "OrderPageVC.h"
#import "ConfirmPageCell.h"
#import "UILabel+CustomLab.h"
#import "Colours.h"


@interface OrderPageVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UITabBar    *tabBar;
@property (nonatomic, strong) UIButton    *confirmBtn;

@property (nonatomic, copy  ) NSArray     *titleDataArr;
@property (nonatomic, copy  ) NSArray     *detialDataArr;
@property (nonatomic, copy  ) NSArray     *customerInfoArr;
@property (nonatomic, copy  ) NSArray     *orderInfoArr;

@end

@implementation OrderPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleDataArr = @[@[@"付款金额"],@[@"咨询师",@"咨询方式",@"咨询时间"],@[@"姓名",@"性别",@"年龄",@"电话",@"邮箱"],@[@"创建时间",@"订单状态",@"订单编号"]];
//    _detialDataArr = @[@[self.orderModel.orderPrice],@[self.orderModel.conserlorName,self.orderModel.orderChoice,self.orderModel.orderDateStr],@[self.orderModel.orderInfoName,self.orderModel.orderInfoSex,self.orderModel.orderInfoAge,self.orderModel.orderInfoPhone,self.orderModel.orderInfoEmail],@[]];
    
    
    [self customNavigation];
    [self customMainTableView];
    
    [self creatBottomBar];
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    self.navigationItem.title = @"订单详情";
    _orderModel.conserlorName = self.navigationItem.title;
    
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {
    
    UIButton *btn         = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

#pragma mark 主界面tableview
- (void)customMainTableView {
    
    _mainTableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, navigationBar_H+statusBar_H, SCREEN_W, SCREEN_H-navigationBar_H-statusBar_H-tabBar_H) style:UITableViewStylePlain];
    [self.view addSubview:_mainTableView];
    _mainTableView.delegate   = self;
    _mainTableView.dataSource = self;

}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell     = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellId"];
    cell.selectionStyle       = UITableViewCellSelectionStyleNone;//设置cell不可以点
    cell.textLabel.text       = _titleDataArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor  = [UIColor lightGrayColor];
    cell.detailTextLabel.text = @"3000";
    if (indexPath.section != 0) {
        cell.textLabel.font       = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }

    
    
    
    return cell;
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleDataArr[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 60;
    }
    return 44;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 20)];
//    headView.backgroundColor = [UIColor lightGrayColor];
//    return headView;
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

#pragma mark 定制底部TabBar
- (void)creatBottomBar {
    
    _tabBar                     = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_H-tabBar_H, SCREEN_W, tabBar_H)];
    _confirmBtn                 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/2, 0, SCREEN_W/2, tabBar_H)];
    _confirmBtn.backgroundColor = MAINCOLOR;
    [_confirmBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:_confirmBtn];

    UIButton *cancelBtn         = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/2, tabBar_H)];
    [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:cancelBtn];

    [self.view addSubview:_tabBar];
    
}

- (void)clickConfirmBtn {
    
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
