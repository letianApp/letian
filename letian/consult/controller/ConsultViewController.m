//
//  ConsultViewController.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ConsultViewController.h"
#import "consultPageCell.h"
#import "counselorInfoModel.h"
#import "CounselorInfoVC.h"
#import "CYUserManager.h"
#import "LoginViewController.h"

#import "MJExtension.h"
#import "SnailPopupController.h"
#import "MJRefresh.h"


#import "ChatListViewController.h"


@interface ConsultViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy  ) NSMutableArray *mainDataSource;
@property (nonatomic, strong) NSMutableArray <counselorInfoModel *> *counselorArr;


@property (nonatomic, copy  ) NSArray      *mainClassifiedDataSource;
@property (nonatomic, copy  ) NSArray      *counselorStatusDataSource;
@property (nonatomic, copy  ) NSArray      *priceDataSource;

@property (nonatomic, strong) NSMutableArray      *priceData;
@property (nonatomic, copy  ) NSString     *minPriceStr;
@property (nonatomic, copy  ) NSString     *maxPriceStr;
@property (nonatomic) BOOL isMinPrice;
@property (nonatomic, strong) UIPickerView *choosePriceView;

@property (nonatomic, strong) UISearchBar  *searchBar;
@property (nonatomic, strong) UIScrollView *classifiedSectionFirstLine;
@property (nonatomic, strong) UITableView  *counselorInfoTableview;
@property (nonatomic, strong) UIView       *mainHeadView;


@end

@implementation ConsultViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self customSearchBar];

}

- (void)viewDidAppear:(BOOL)animated {
    
    [self customNavigation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _counselorArr = [NSMutableArray new];
    
    
    [self getCounsultDataSource];
    
//    [self customNavigation];
    [self creatTableView];
    [self creatClassifiedSection];
    
    
}

- (void)customSearchBar {
    
    _searchBar             = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/2, 40)];
    _searchBar.placeholder = @"搜索";
    [_searchBar setTranslucent:YES];
//    _searchBar.searchBarStyle = UISearchBarStyleProminent;
    
}

#pragma mark 定制Navigation
- (void)customNavigation {
    
    self.navigationController.navigationBar.tintColor = MAINCOLOR;
    self.navigationItem.titleView                     = _searchBar;

//    UIBarButtonItem *leftButton                       = [[UIBarButtonItem alloc]initWithTitle:@"乐天心理" style:UIBarButtonItemStyleDone target:self action:nil];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MAINCOLOR} forState:UIControlStateDisabled];
//    self.navigationItem.leftBarButtonItem             = leftButton;

//    UIBarButtonItem *rightButton                      = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"mainMessage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(selRightButton)];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
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


- (void)selRightButton {
    
    ChatListViewController *chatListVc  = [[ChatListViewController alloc]init];
    chatListVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatListVc animated:YES];
    
}

#pragma mark 获取咨询师信息
- (void)getCounsultDataSource {
    

    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendFormat:@"%@",API_NAME_GETCONSULTLIST];
    NSLog(@"%@",requestString);
    __weak typeof(self) weakSelf   = self;

    NSMutableDictionary *params    = [[NSMutableDictionary alloc]init];
    params[@"enumPsyCategory"]     = @0;
    params[@"enumUserTitle"]       = @0;

    [PPNetworkHelper GET:requestString parameters:params success:^(id responseObject) {
        
        __strong typeof(self) strongself = weakSelf;
        NSLog(@"%@",responseObject);
        
        strongself.counselorArr = [counselorInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
        
        strongself.mainDataSource = responseObject[@"Result"][@"Source"];
        for (counselorInfoModel *consultDic in strongself.counselorArr) {
            
            NSLog(@"%@",consultDic.UserName);
//            counselorInfoModel *consultModel = [[counselorInfoModel alloc]init];

        }
        
        [strongself.counselorInfoTableview.mj_header endRefreshing];
//        NSLog(@"%@",sourceArr);

    } failure:^(NSError *error) {
        
        __strong typeof(self) strongself = weakSelf;
        
        [strongself.counselorInfoTableview.mj_header endRefreshing];
        [MBHudSet showText:[NSString stringWithFormat:@"获取咨询师列表错误，错误代码：%ld",error.code]andOnView:strongself.view];

    }];
    
   
}
    


#pragma mark 创建分类栏
- (void)creatClassifiedSection {
    
    _mainClassifiedDataSource                 = @[@"全部类型",@"自我成长",@"婚姻情感",@"孩子教育",@"职场心理",@"人际关系",@"情绪压力",@"神经症"];
    _counselorStatusDataSource                = @[@"全部资历",@"首席",@"主任",@"专家",@"资深",@"心理咨询师"];
    _priceDataSource                          = @[@"全部价格",@"最低价",@"最高价"];

    self.automaticallyAdjustsScrollViewInsets = NO;

    [self customClassifiedSectionBtnFotData:_mainClassifiedDataSource withLineNumber:0];
    [self customClassifiedSectionBtnFotData:_counselorStatusDataSource withLineNumber:1];
    [self customClassifiedSectionBtnFotData:_priceDataSource withLineNumber:2];

    [self customPriceSection];
    
}

//分类栏按钮
- (void)customClassifiedSectionBtnFotData:(NSArray *)dataArr withLineNumber:(int)n{
    
    UIScrollView *ParentView                  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, n*navigationBar_H, SCREEN_W, navigationBar_H)];
    [_mainHeadView addSubview:ParentView];
    ParentView.backgroundColor                = WEAKPINK;
    ParentView.showsHorizontalScrollIndicator = NO;
    ParentView.contentSize                    = CGSizeMake(dataArr.count * SCREEN_W/4 , navigationBar_H);
    ParentView.tag                            = 50+n;

    for (int i                                = 0; i < dataArr.count; i++) {
    UIButton *btn                             = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/4*i+10, 8, SCREEN_W/4-12, navigationBar_H-16)];
        [btn setTitle:dataArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn.backgroundColor                       = [UIColor whiteColor];
    btn.layer.borderColor                     = MAINCOLOR.CGColor;
    btn.layer.borderWidth                     = 1;
    btn.layer.cornerRadius                    = 15;
    btn.titleLabel.font                       = [UIFont systemFontOfSize:12];

    btn.tag                                   = n*100+i+1;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];

        [ParentView addSubview:btn];
    }
    [self beginningButtonSelectedWithTag:n*100 + 1];
    ParentView.contentSize                    = CGSizeMake(SCREEN_W/4 * dataArr.count , navigationBar_H);

}

#pragma mark 定制价格界面
- (void)customPriceSection {
    
    UIScrollView *scroview      = [self.view viewWithTag:52];
    
    UIButton *minPriceBtn       = [self.view viewWithTag:202];
    minPriceBtn.backgroundColor = [UIColor whiteColor];
    [minPriceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    minPriceBtn.frame           = CGRectMake(SCREEN_W/4+10, 8, SCREEN_W/4, navigationBar_H-16);
    
    UILabel *line               = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/2+20, navigationBar_H/2, 20, 2)];
    [scroview addSubview:line];
    line.backgroundColor        = MAINCOLOR;
    
    UIButton *maxPriceBtn       = [self.view viewWithTag:203];
    maxPriceBtn.backgroundColor = [UIColor whiteColor];
    [maxPriceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    maxPriceBtn.frame           = CGRectMake(SCREEN_W/2+50, 8, SCREEN_W/4, navigationBar_H-16);
    
}

//首按钮初始点击状态
- (void)beginningButtonSelectedWithTag:(int)tagg {
    
    UIButton *beginningButton       = [self.view viewWithTag:tagg];
    beginningButton.selected        = YES;
    beginningButton.backgroundColor = MAINCOLOR;
}

//点击按钮方法
- (void)clickBtn:(UIButton *)btn {
    
    [self animationbegin:btn];
    if (btn.tag < 100) {
        for (int i = 1; i < _mainClassifiedDataSource.count+1; i++) {
            UIButton *otherBtn       = [self.view viewWithTag:i];
            otherBtn.selected        = NO;
            otherBtn.backgroundColor = [UIColor whiteColor];
        }
        btn.selected         = YES;
        btn.backgroundColor  = MAINCOLOR;

    } else if (btn.tag < 200) {
        for (int i = 1; i < _counselorStatusDataSource.count+1; i++) {
            UIButton *otherBtn       = [self.view viewWithTag:i+100];
            otherBtn.selected        = NO;
            otherBtn.backgroundColor = [UIColor whiteColor];
        }
        btn.selected         = YES;
        btn.backgroundColor  = MAINCOLOR;

    } else {
        
        self.sl_popupController                          = [[SnailPopupController alloc] init];
        self.sl_popupController.layoutType               = PopupLayoutTypeCenter;
        self.sl_popupController.maskType                 = PopupMaskTypeWhiteBlur;
        self.sl_popupController.transitStyle             = PopupTransitStyleSlightScale;
        self.sl_popupController.dismissOppositeDirection = YES;
        
        UIButton *allPriceBtn    = [self.view viewWithTag:201];
        UIButton *minPriceBtn    = [self.view viewWithTag:202];
        UIButton *maxPriceBtn    = [self.view viewWithTag:203];

        if (btn == allPriceBtn) {
            
            [minPriceBtn setTitle:@"最低价" forState:UIControlStateNormal];
            [minPriceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            [maxPriceBtn setTitle:@"最高价" forState:UIControlStateNormal];
            [maxPriceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            allPriceBtn.selected         = YES;
            allPriceBtn.backgroundColor  = MAINCOLOR;
            
        } else if (btn == minPriceBtn) {
            
            _isMinPrice = YES;
            [self.sl_popupController presentContentView:[self setupChoosePriceViewForBtn:btn]];
            
        } else {
            
            if ([minPriceBtn.titleLabel.text isEqualToString:@"最低价"]) {
                [MBHudSet showText:@"请确认最低价" andOnView:self.view];
            } else {
                _isMinPrice = NO;
                [self.sl_popupController presentContentView:[self setupChoosePriceViewForBtn:btn]];
            }
        }
    }
}

#pragma mark 选择价格界面
- (UIView *)setupChoosePriceViewForBtn:(UIButton *)btn {
    
    if (_isMinPrice == YES) {
        _priceData = [[NSMutableArray alloc]initWithArray:@[@"300",@"400",@"500",@"600",@"700",@"800",@"900",@"1000",@"1100"]];
        _minPriceStr = _priceData[0];

    } else {
        
        if (_minPriceStr == _priceData[_priceData.count-1]) {
            
            _priceData = [[NSMutableArray alloc]initWithObjects:_minPriceStr, nil];
            _maxPriceStr = _priceData[0];
            
        } else {
            int index = 0;
            for (int i = 0; i < _priceData.count; i++) {
                if (_priceData[i] == _minPriceStr) {
                    index = i;
                    NSRange range = {0,index+1};
                    [_priceData removeObjectsInRange:range];
                    break;
                }
            }
            _maxPriceStr = _priceData[0];

        }
    }
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H/4, SCREEN_W, SCREEN_H*0.4)];
    
    _choosePriceView = [[UIPickerView alloc]initWithFrame:CGRectMake(SCREEN_W*0.3, 0, SCREEN_W*0.4, backView.height*0.7)];
    [backView addSubview:_choosePriceView];
    _choosePriceView.dataSource = self;
    _choosePriceView.delegate   = self;
    
    UIButton *affirmBtn = [GQControls createButtonWithFrame:CGRectMake(SCREEN_W/4, _choosePriceView.bottom+10, SCREEN_W/2, 30) andTitle:@"确定" andTitleColor:MAINCOLOR andFontSize:15 andTag:234 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
    [backView addSubview:affirmBtn];
    [affirmBtn addTarget:self action:@selector(clickAffirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return backView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _priceData.count;
    }
    return 1;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return _priceData[row];
    }
    return @"元";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (_isMinPrice) {
        _minPriceStr = _priceData[row];
    } else {
        _maxPriceStr = _priceData[row];
    }
}

- (void)clickAffirmBtn:(UIButton *)btn {
    
    [self animationbegin:btn];
    
    UIButton *allPriceBtn    = [self.view viewWithTag:201];
    UIButton *minPriceBtn = [self.view viewWithTag:202];
    UIButton *maxPriceBtn = [self.view viewWithTag:203];

    if (_isMinPrice == YES) {
        
        [maxPriceBtn setTitle:@"最高价" forState:UIControlStateNormal];
        [maxPriceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        [minPriceBtn setTitle:[NSString stringWithFormat:@"%@ 元",_minPriceStr] forState:UIControlStateNormal];
        [minPriceBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        
    } else {
        
        [maxPriceBtn setTitle:[NSString stringWithFormat:@"%@ 元",_maxPriceStr] forState:UIControlStateNormal];
        [maxPriceBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];

    }
    allPriceBtn.selected        = NO;
    allPriceBtn.backgroundColor = [UIColor whiteColor];

    
    [self.sl_popupController dismiss];
}

#pragma mark 创建tabview
- (void)creatTableView {
    
    _counselorInfoTableview                 = [[UITableView alloc]initWithFrame:CGRectMake(0, statusBar_H + navigationBar_H, SCREEN_W, SCREEN_H-statusBar_H - navigationBar_H) style:UITableViewStylePlain];
    _counselorInfoTableview.dataSource      = self;
    _counselorInfoTableview.delegate        = self;
    _counselorInfoTableview.backgroundColor = WEAKPINK;
    [self.view addSubview:_counselorInfoTableview];
    _counselorInfoTableview.rowHeight       = 100;
    _mainHeadView                           = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, navigationBar_H*3)];
    _counselorInfoTableview.tableHeaderView = _mainHeadView;
    
    _counselorInfoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCounsultDataSource)];


}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    consultPageCell *cell = [consultPageCell cellWithTableView:tableView];
    return cell;
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

    CounselorInfoVC *counselorInfoMainVC = [[CounselorInfoVC alloc]init];
//    counselorInfoMainVC.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:counselorInfoMainVC animated:YES];    
    
}


#pragma mark 按钮动画
- (void)animationbegin:(UIView *)view {
    /* 放大缩小 */
    
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
    
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
