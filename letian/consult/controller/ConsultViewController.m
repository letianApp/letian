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

#import "ChatListViewController.h"

#import <YYModel/YYModel.h>

@interface ConsultViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy ) NSMutableArray *mainDataSource;

@property (nonatomic, copy  ) NSArray      *mainClassifiedDataSource;
@property (nonatomic, copy  ) NSArray      *counselorStatusDataSource;
@property (nonatomic, copy  ) NSArray      *priceDataSource;

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

    UIBarButtonItem *leftButton                       = [[UIBarButtonItem alloc]initWithTitle:@"乐天心理" style:UIBarButtonItemStyleDone target:self action:nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MAINCOLOR} forState:UIControlStateDisabled];
    self.navigationItem.leftBarButtonItem             = leftButton;

    UIBarButtonItem *rightButton                      = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"mainMessage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(selRightButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
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
//    params[@"searchName"] = @"aaa";
    params[@"enumPsyCategory"]     = @0;
    params[@"enumUserTitle"]       = @0;
//    params[@"minFee"] = @(122);
//    params[@"maxFee"] = @(233);
//    params[@"pageIndex"] = @(1);
//    params[@"pageSize"] = @(10);
    
    [PPNetworkHelper GET:requestString parameters:params success:^(id responseObject) {
        
        // 将 JSON (NSData,NSString,NSDictionary) 转换为 Model:
//        counselorInfoModel *user = [counselorInfoModel yy_modelWithJSON:responseObject];
//        NSDictionary *dataDict = [user valueForKey:@"data"];
        
        __strong typeof(self) strongself = weakSelf;
        
        strongself.mainDataSource = responseObject[@"Result"][@"Source"];
        for (NSDictionary *consultDic in strongself.mainDataSource) {
            
            NSLog(@"%@",consultDic);
            counselorInfoModel *consultModel = [[counselorInfoModel alloc]init];

        }
        
//        NSLog(@"%@",sourceArr);

    } failure:^(NSError *error) {
        
        __strong typeof(self) strongself = weakSelf;

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

//首按钮初始点击状态
- (void)beginningButtonSelectedWithTag:(int)tagg {
    
    UIButton *beginningButton       = [self.view viewWithTag:tagg];
    beginningButton.selected        = YES;
    beginningButton.backgroundColor = MAINCOLOR;
}

//点击按钮方法
- (void)clickBtn:(UIButton *)btn {

    if (btn.tag < 100) {
    for (int i           = 1; i < _mainClassifiedDataSource.count+1; i++) {
    UIButton *btnn       = [self.view viewWithTag:i];
    btnn.selected        = NO;
    btnn.backgroundColor = [UIColor whiteColor];
        }
    }
    else if (btn.tag < 200) {
    for (int i           = 1; i < _counselorStatusDataSource.count+1; i++) {
    UIButton *btnn       = [self.view viewWithTag:i+100];
    btnn.selected        = NO;
    btnn.backgroundColor = [UIColor whiteColor];
        }
    }

    btn.selected         = YES;
    btn.backgroundColor  = MAINCOLOR;
}

//定制价格栏
- (void)customPriceSection {
    
    UIScrollView *scroview      = [self.view viewWithTag:52];

    UIButton *minPriceBtn       = [self.view viewWithTag:202];
    minPriceBtn.backgroundColor = [UIColor whiteColor];
    minPriceBtn.selected        = NO;
    [minPriceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [minPriceBtn removeTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    minPriceBtn.frame           = CGRectMake(SCREEN_W/4+10, 8, SCREEN_W/4, navigationBar_H-16);

    UILabel *line               = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/2+20, navigationBar_H/2, 20, 2)];
    [scroview addSubview:line];
    line.backgroundColor        = MAINCOLOR;

    UIButton *maxPriceBtn       = [self.view viewWithTag:203];
    maxPriceBtn.backgroundColor = [UIColor whiteColor];
    maxPriceBtn.selected        = NO;
    [maxPriceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [maxPriceBtn removeTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    maxPriceBtn.frame           = CGRectMake(SCREEN_W/2+50, 8, SCREEN_W/4, navigationBar_H-16);

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
    counselorInfoMainVC.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:counselorInfoMainVC animated:YES];    
    
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
