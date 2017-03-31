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



@interface OrderPageVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, copy) NSArray *consultInfoArr;
@property (nonatomic, copy) NSArray *customerInfoArr;
@property (nonatomic, copy) NSArray *orderInfoArr;

@end

@implementation OrderPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _consultInfoArr = @[@"咨询师",@"咨询方式",@"咨询时间"];
    _customerInfoArr = @[@"姓名",@"性别",@"年龄",@"电话",@"邮箱"];
    _orderInfoArr = @[@"创建时间",@"订单状态",@"订单编号"];
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

#pragma mark 主界面tableview
- (void)customMainTableView {
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navigationBar_H+statusBar_H, SCREEN_W, SCREEN_H-navigationBar_H-statusBar_H-tabBar_H) style:UITableViewStylePlain];
    [self.view addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
//    自动计算高度 iOS8
//    _mainTableView.estimatedRowHeight = 44.0;
//    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConfirmPageCell *cell = [ConfirmPageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;                        //设置cell不可以点
    
    NSArray *lableTagArr = @[@"付款金额",@"预约方式及时间",@"预约信息",@"订单详情"];
    cell.labelTag.text = lableTagArr[indexPath.row];
//    NSLog(@"%f",cell.labelTag.height);
    cell.detialLab.hidden = YES;
    //    cell.backView.backgroundColor = [UIColor yellowColor];
    
    [self customCell:cell withBgView:cell.backView forRowAtIndexPath:indexPath];
    
    return cell;
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return 44+30;
            break;
            
        case 1:
            return 44*_consultInfoArr.count+30;
        case 2:
            return 44*_customerInfoArr.count+30;
        case 3:
            return 44*_orderInfoArr.count+30;
        default:
            break;
    }
    return 100;
}


- (void)customCell:(ConfirmPageCell *)cell withBgView:(UIView *)view forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/2, 0, SCREEN_W/2-20, 44.0)];
            [view addSubview:priceLab];
            priceLab.textAlignment = NSTextAlignmentRight;
            priceLab.text = @"¥3000";
            priceLab.font = [UIFont boldSystemFontOfSize:20];
        
            break;
        }
        case 1:
            
            [self creatTitleLabelWithData:_consultInfoArr withBackview:cell.backView];
            break;
        case 2:
            
            [self creatTitleLabelWithData:_customerInfoArr withBackview:cell.backView];
            break;
        case 3:
            
            [self creatTitleLabelWithData:_orderInfoArr withBackview:cell.backView];
            break;
        default:
            break;

    }
    
}


- (void)creatTitleLabelWithData:(NSArray *)titleArr withBackview:(UIView *)backView {
    
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 44*i, SCREEN_W*0.2, 44.0)];
        lab.text = titleArr[i];
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:15];
        [lab LabelTextAutoFitWidth];
        [backView addSubview:lab];
    }

    
}


#pragma mark 定制底部TabBar
- (void)creatBottomBar {
    
    _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_H-tabBar_H, SCREEN_W, tabBar_H)];
    _confirmBtn.backgroundColor = MAINCOLOR;
    [_confirmBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_confirmBtn];
    
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
