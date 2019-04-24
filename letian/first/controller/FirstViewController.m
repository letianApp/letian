//
//  FirstViewController.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "FirstViewController.h"
#import "ConsultViewController.h"
#import "HomeCell.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "CategoryViewController.h"
#import "TestViewController.h"
#import "ActivityListViewController.h"
#import "UserInfoViewController.h"
#import "CustomCYLTabBar.h"
#import "CounselorInfoVC.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "ActiveModel.h"
#import "WebArticleModel.h"
#import "GQUserManager.h"
#import "SystomMsgViewController.h"
#import "TestDetailViewController.h"
#import "GQScrollView.h"
#import "ActivityDetailViewController.h"
#import "FunnyViewController.h"
#import "selectionArticleVC.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"
#import "Colours.h"
#import "MNFloatBtn.h"



@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSDictionary *counselorCategoryDic;
@property (nonatomic, strong) NSMutableArray *counselorCategoryArr;
@property (nonatomic, strong) UserInfoModel *userInfoModel;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIButton *suspBtn;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *sectionHeaderLabel;
@property (nonatomic, strong) GQScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray <ActiveModel *> *funnyListArray;
@property (nonatomic, strong) NSMutableArray <counselorInfoModel  *> *counselorArr;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong) NSArray *datas;



@end

@implementation FirstViewController

- (NSMutableArray *)funnyListArray {
    if (_funnyListArray == nil) {
        _funnyListArray = [NSMutableArray array];
    }
    return _funnyListArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.counselorArr = [NSMutableArray new];
    [self getCounsultTypeSource];
    [self customSearchBar];
    [self customNavigation];
    [self createTableView];
    [self requestData];
//    if ([GQUserManager isHaveLogin]) {
//    }
    [self setUpRefresh];
    if (@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    });
//    [self cellTab];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserChoise];
    [self createSuspBtn];

}

- (void)customSearchBar {
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/2, 40)];
    if (@available(iOS 11.0, *)){
        [[_searchBar.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
    }
    _searchBar.placeholder = @"搜索咨询师";
    UITextField *searchField = [_searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor seashellColor];
    //    [searchField setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
    _searchBar.delegate    = self;
//    [bgView addSubview:_searchBar];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    self.tabBarController.selectedIndex = 1;
    return NO;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

#pragma mark 定制Navigation
- (void)customNavigation {

    self.navigationController.navigationBar.tintColor = MAINCOLOR;
    self.navigationController.navigationBar.clipsToBounds = YES;
    [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
    self.navigationItem.titleView = _searchBar;
    self.navigationItem.backBarButtonItem.title = @"";
}

#pragma mark-------下拉刷新

-(void)setUpRefresh {
    
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    header.stateLabel.textColor = MAINCOLOR;
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer = [RefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
}

- (void)cellTab {
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/4*3, 20, 40, 40)];
    [self.view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"cell"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cellPhone) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)cellPhone {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-109-2007"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark - 创建悬浮的按钮
- (void)createSuspBtn {
    [MNFloatBtn show];
    [MNFloatBtn sharedBtn].btnClick = ^(UIButton *sender) {
        
        [self getCounsultListSource];
    };
}


#pragma mark-------创建TableView

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBar_H + navigationBar_H, SCREEN_W, SCREEN_H-49) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.funnyListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *funnyTestModuleLabel = [GQControls createLabelWithFrame:CGRectMake(0, 0, SCREEN_W, 25) andText:@"乐天派·每日文章" andTextColor:[UIColor darkGrayColor] andFontSize:15];
    funnyTestModuleLabel.backgroundColor = [UIColor whiteColor];
    funnyTestModuleLabel.textAlignment = NSTextAlignmentCenter;
    self.sectionHeaderLabel = funnyTestModuleLabel;
    return self.sectionHeaderLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

#pragma mark------cell定制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCell *cell = [HomeCell cellWithTableView:tableView];
    cell.titleLabel.text = self.funnyListArray[indexPath.row].ArticleName;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.funnyListArray[indexPath.row].ArticleImg]];
    cell.detailLabel.text = self.funnyListArray[indexPath.row].ArticleContent;

    return cell;
}

#pragma mark------cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    selectionArticleVC *articleVC = [[selectionArticleVC alloc]init];
    articleVC.ArticleUrl = self.funnyListArray[indexPath.row].ArticleUrl;
    articleVC.ID = self.funnyListArray[indexPath.row].ID;
    articleVC.ArticleTitle = self.funnyListArray[indexPath.row].ArticleName;
    articleVC.ArticleImg = self.funnyListArray[indexPath.row].ArticleImg;
//    funnyVc.activeModel=self.funnyListArray[indexPath.row];
//    articleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:articleVC animated:YES];
}

#pragma mark------------获取用户信息
- (void)requestUserData {
    
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_GETUSERINFO];
    __weak typeof(self) weakSelf = self;
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
//        NSLog(@"token------------%@",kFetchToken);
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;
        
//        NSLog(@"sr:%@",responseObject[@"Result"][@"Source"][@"Birhtday"]);
        [MBHudSet dismiss:strongSelf.view];
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            strongSelf.userInfoModel = [UserInfoModel mj_objectWithKeyValues:responseObject[@"Result"][@"Source"]];
            
            if (NULLString(responseObject[@"Result"][@"Source"][@"Birhtday"])) {
                UIAlertController *alertControl  = [UIAlertController alertControllerWithTitle:@"为使测评结果更准确" message:@"请前往设置生日" preferredStyle:UIAlertControllerStyleAlert];
                __weak typeof(self) weakSelf = self;
                [alertControl addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    
                    UserInfoViewController *userInfoVc = [[UserInfoViewController alloc]init];
                    userInfoVc.hidesBottomBarWhenPushed = YES;
                    userInfoVc.userInfoModel = self.userInfoModel;
                    [weakSelf.navigationController pushViewController:userInfoVc animated:YES];
                }]];
                [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertControl animated:YES completion:nil];
                
            } else {
                TestViewController *testVc = [[TestViewController alloc]init];
                testVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:testVc animated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        __strong typeof(self) strongSelf = weakSelf;
        
        [MBHudSet dismiss:strongSelf.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:strongSelf.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:strongSelf.view];
        }
    }];
}

#pragma mark 获取咨询师列表
- (void)getCounsultListSource {
    
    __weak typeof(self) weakSelf = self;
    [MBHudSet showStatusOnView:self.view];
    
    NSMutableString *requestConsultListString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestConsultListString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestConsultListString appendFormat:@"%@",API_NAME_GETCONSULTLIST];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//    [params setValue:@(1) forKey:@"pageIndex"];
    [params setValue:@(0) forKey:@"EnumPsyCategory"];
    [params setValue:@(0) forKey:@"EnumUserTitle"];
//    [_requestParams setValue:@(_pageIndex) forKey:@"pageIndex"];
    [PPNetworkHelper GET:requestConsultListString parameters:params success:^(id responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        [MBHudSet dismiss:strongSelf.view];
        strongSelf.counselorArr = [counselorInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
//        NSLog(@"%@",strongSelf.counselorArr);
        CounselorInfoVC *eacInfo = [[CounselorInfoVC alloc]init];
        eacInfo.counselModel = strongSelf.counselorArr[1];
        eacInfo.hidesBottomBarWhenPushed = YES;
        [strongSelf.navigationController pushViewController:eacInfo animated:YES];
        
    } failure:^(NSError *error) {
        
        __strong typeof(self) strongSelf = weakSelf;
        [MBHudSet dismiss:strongSelf.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:strongSelf.view];
        } else {
            [MBHudSet showText:@"请求失败" andOnView:strongSelf.view];
        }
    }];
}

#pragma mark------精选文章列表
-(void)requestData {
    
    self.pageIndex = 1;
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_ARTICLE];
    [requestString appendString:API_NAME_GETARTICLELIST];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"pageIndex"] = @(self.pageIndex);
    params[@"pageSize"] = @(10);
    params[@"enumArticleType"] = @(0);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [MBHudSet dismiss:self.view];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.funnyListArray = [ActiveModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];

        if (weakSelf.funnyListArray.count >= 10) {
            weakSelf.tableView.mj_footer.hidden = NO;
        }else{
            weakSelf.tableView.mj_footer.hidden=YES;
        }
        [_tableView reloadData];
        [_pagerView reloadData];
        [_whiteView removeFromSuperview];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBHudSet dismiss:self.view];

        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}

-(void)requestMoreData {
    
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_ARTICLE];
    [requestString appendString:API_NAME_GETARTICLELIST];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"pageIndex"] = @(++self.pageIndex);
    params[@"pageSize"] = @(10);
    params[@"enumArticleType"] = @(0);

    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        
        NSArray *array = [ActiveModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
//        NSArray *array=[WebArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];

        if (array.count >= 10) {
            weakSelf.tableView.mj_footer.hidden = NO;
            [weakSelf.tableView.mj_footer endRefreshing];
        }else{
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.funnyListArray addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark------头视图

#pragma mark 获取类型信息
- (void)getCounsultTypeSource {
    
    _counselorCategoryDic = [NSMutableDictionary new];
    _counselorCategoryArr = [NSMutableArray new];
    
    __weak typeof(self) weakSelf   = self;
    
    NSMutableString *requestConsultPsyAndTitleListString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestConsultPsyAndTitleListString appendFormat:@"%@/",API_MODULE_UTILS];
    [requestConsultPsyAndTitleListString appendFormat:@"%@",API_NAME_GETCONSULTTITLELIST];
    
    [PPNetworkHelper GET:requestConsultPsyAndTitleListString parameters:nil success:^(id responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.counselorCategoryDic = responseObject[@"Result"][@"Source"][@"PsyCategoryDic"];
        strongSelf.counselorCategoryArr = [strongSelf arrangeForKeyWithDic:strongSelf.counselorCategoryDic];
        
        strongSelf.tableView.tableHeaderView = [strongSelf createHeadBgView];
        
    } failure:^(NSError *error) {
        
        __strong typeof(self) strongSelf = weakSelf;
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:strongSelf.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:strongSelf.view];
        }
        
    }];
}

#pragma mark 根据key排列dic
- (NSMutableArray *)arrangeForKeyWithDic:(NSDictionary *)dic {
    
    NSMutableArray *keyArr = [[NSMutableArray alloc]initWithArray:dic.allKeys];
    for (int i = 0; i < keyArr.count; i++) {
        for (int k = 0; k < keyArr.count-1; k++) {
            if ([keyArr[k] integerValue] > [keyArr[k+1] integerValue]) {
                [keyArr exchangeObjectAtIndex:k withObjectAtIndex:k+1];
            }
        }
    }
    
    NSMutableArray *valuesArr = [NSMutableArray new];
    for (int i = 0; i < keyArr.count; i++) {
        [valuesArr addObject:dic[keyArr[i]]];
    }
    
    return valuesArr;
}


- (UIView *)createHeadBgView {
    
    UIView *headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 250+SCREEN_W*0.6)];
    [self addPagerView:headBgView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _pagerView.bottom, SCREEN_W, 170)];
//    view.backgroundColor = MAINCOLOR;
    
    NSArray *nameArray = self.counselorCategoryArr;
    for (int k = 0; k < 2; k++) {
        for (int i = 0; i < 4; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W / 4 * i, view.height/2 * k, SCREEN_W / 4, view.height/2)];
            [view addSubview:btn];
            [btn setTitle:nameArray[i + k * 4] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"first%d",i + k * 4 + 1]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100 + i + k * 4;
            [self textUnderImageButton:btn];
        }
    }
    
    [headBgView addSubview:view];
    
    UIButton *tabBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, view.bottom + 20, SCREEN_W * 3 / 10, 60)];
    [headBgView addSubview:tabBtn];
    tabBtn.tag = 10;
    [self customBtn:tabBtn WithL1:@"寻找专家" withL2:@"资深·专家"];
    
    NSArray *L1arr = @[@"心理测试",@"成长乐园",@"专栏文章"];
    NSArray *L2arr = @[@"准确·免费",@"活动·课程",@"分类·丰富"];
    for (int i = 0; i < 3; i++) {
        UIButton *tabB = [[UIButton alloc]initWithFrame:CGRectMake(tabBtn.right + 10 + (SCREEN_W * 2 / 3 - 20) / 3 * i, view.bottom + 20, (SCREEN_W * 2 / 3 - 45) / 3, 60)];
        [headBgView addSubview:tabB];
        tabB.tag = 11 + i;
        [self customBtn:tabB WithL1:L1arr[i] withL2:L2arr[i]];
    }
    
    return headBgView;
}

- (void)textUnderImageButton:(UIButton *)button {
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height, 0, 0, -button.titleLabel.intrinsicContentSize.width)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(button.currentImage.size.height + 20, -button.currentImage.size.width, 0, 0)];
    button.imageView.clipsToBounds = YES;
    button.imageView.layer.cornerRadius = button.imageView.width*0.5;
    button.imageView.layer.masksToBounds = YES;
}

- (void)customBtn:(UIButton *)button WithL1:(NSString *)str1 withL2:(NSString *)str2 {
    
    button.layer.borderColor = MAINCOLOR.CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 10;
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",str1] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:MAINCOLOR}];
    NSAttributedString *time = [[NSAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [title appendAttributedString:time];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:5];
//    paraStyle.alignment = NSTextAlignmentLeft;
    [title addAttributes:@{NSParagraphStyleAttributeName:paraStyle} range:NSMakeRange(0, title.length)];
    
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button setAttributedTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark------点击头视图模块
- (void)headBtnClick:(UIButton *)btn {
    
    if (btn.tag == 13) {
        CategoryViewController *articleVc = [[CategoryViewController alloc]init];
        articleVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:articleVc animated:YES];
        //跳到测试
    } else if (btn.tag == 11) {
        if (![GQUserManager isHaveLogin]) {
            //未登录
            UIAlertController *alertControl  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self) weakSelf = self;
            [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                RegistViewController *loginVc = [[RegistViewController alloc]init];
                loginVc.hidesBottomBarWhenPushed = YES;
                [weakSelf presentViewController:loginVc animated:YES completion:nil];
            }]];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertControl animated:YES completion:nil];
            
        } else {
            [self requestUserData];
        }
        //跳到活动
    } else if (btn.tag == 12) {
        ActivityListViewController *activityVc=[[ActivityListViewController alloc]init];
        activityVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activityVc animated:YES];
    } else if (btn.tag == 10) {
        self.tabBarController.selectedIndex = 1;
    } else {
        
        for (NSString *key in self.counselorCategoryDic) {
            if (btn.titleLabel.text == self.counselorCategoryDic[key]) {
                [[NSUserDefaults standardUserDefaults] setObject:key forKey:kUserChoise];
                break;
            }
        }
        self.tabBarController.selectedIndex = 1;
    }
}



#pragma mark 轮播图
- (void)addPagerView:(UIView *)bgView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W*5/9)];
//    pagerView.layer.borderWidth = 1;
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 4.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    // registerClass or registerNib
    [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [bgView addSubview:pagerView];
    _whiteView = [[UIView alloc]initWithFrame:pagerView.frame];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_whiteView];
    _pagerView = pagerView;
}

//- (void)addPageControl {
//    TYPageControl *pageControl = [[TYPageControl alloc]init];
//    pageControl.currentPageIndicatorSize = CGSizeMake(6, 6);
//    pageControl.pageIndicatorSize = CGSizeMake(12, 6);
//    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
//    pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    [_pagerView addSubview:pageControl];
//    _pageControl = pageControl;
//}


- (void)loadData {
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 0; i < 7; ++i) {
        if (i == 0) {
            [datas addObject:[UIColor redColor]];
            continue;
        }
        [datas addObject:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:arc4random()%255/255.0]];
    }
    _datas = [datas copy];
    _pageControl.numberOfPages = _datas.count;
    [_pagerView reloadData];
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 4;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
//    cell.bgImg.contentMode = UIViewContentModeScaleToFill;
    if (!self.funnyListArray.count) {
        [cell.bgImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"index_%ld",index+1]]];
    } else if (index == 0) {
        [cell.bgImg setImage:[UIImage imageNamed:@"EAP"]];
        cell.label.text = @"中科院上海生科院专用预约通道";
    } else {
        [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:self.funnyListArray[index].ArticleImg]];
        cell.label.text = [NSString stringWithFormat:@"%@",self.funnyListArray[index].ArticleName];
    }
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.85, CGRectGetHeight(pageView.frame)*0.85);
    layout.itemSpacing = 13;
    layout.layoutType = 1;
    //layout.minimumAlpha = 0.3;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
//    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    
    if (index == 0) {
        
        [self getCounsultListSource];
    } else {
        
        selectionArticleVC *articleVC = [[selectionArticleVC alloc]init];
        articleVC.ArticleUrl = self.funnyListArray[index-1].ArticleUrl;
        articleVC.ID = self.funnyListArray[index].ID;
        //    articleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:articleVC animated:YES];
    }
}

- (GQScrollView *)createScrollView {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 4; i++) {
    
        UIImageView *imgView = [[UIImageView alloc]init];
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.funnyListArray[i].ArticleImg] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"index_%d",i+1]]];
        
        [imageArray addObject:imgView.image];
    }
    
    _scrollView = [[GQScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W*0.6) withImages:imageArray withIsRunloop:YES withBlock:^(NSInteger index) {
//        NSLog(@"点击了index%zd",index);
//        imageArray[index]
        //跳到咨询页面
        
        selectionArticleVC *articleVC = [[selectionArticleVC alloc]init];
        articleVC.ArticleUrl = self.funnyListArray[index].ArticleUrl;
        articleVC.ID = self.funnyListArray[index].ID;
//        articleVC.ArticleTitle = self.funnyListArray[index].ArticleName;
//        articleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:articleVC animated:NO];
    
    }];
    
    _scrollView.color_currentPageControl = MAINCOLOR;
    return _scrollView;
}

//视图将要消失
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MNFloatBtn hidden];
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
