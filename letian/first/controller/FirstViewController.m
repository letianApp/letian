//
//  FirstViewController.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "FirstViewController.h"
#import "HomeCell.h"
#import "LoginViewController.h"
#import "CategoryViewController.h"
#import "TestViewController.h"
#import "ActivityListViewController.h"
#import "CustomCYLTabBar.h"
#import "ConsultViewController.h"
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


@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *sectionHeaderLabel;
@property (nonatomic,strong) GQScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray <ActiveModel *> *funnyListArray;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong) NSArray *datas;


@end

@implementation FirstViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (self.tableView.contentOffset.y >= 220) {

        return UIStatusBarStyleDefault;
    } else {
        
        return UIStatusBarStyleLightContent;
    }
}

//-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden=YES;
//}

-(NSMutableArray *)funnyListArray
{
    if (_funnyListArray == nil) {
        _funnyListArray = [NSMutableArray array];
    }
    return _funnyListArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self customSearchBar];
    [self customNavigation];
    [self createTableView];
    [self requestData];
    [self setUpRefresh];
    if (@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
//    [self cellTab];
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
    
//    [_searchBar setShowsCancelButton:YES animated:YES];
//    NSLog(@"点击");
//    [_searchBar endEditing:YES];
//    self.tabBarController.selectedIndex = 1;
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

//    if (NULLString(searchText)) {
//        [_requestParams removeObjectForKey:@"SearchName"];
//        [self getCounsultListSource];
//    }
//}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

//    [_requestParams setValue:searchBar.text forKey:@"SearchName"];
//    [self.searchBar resignFirstResponder];
//    [self getCounsultListSource];
//}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [_requestParams removeObjectForKey:@"SearchName"];
//    [self getCounsultListSource];
//    searchBar.text = @"";
//    [self.searchBar resignFirstResponder];
//    [self.searchBar setShowsCancelButton:NO animated:YES];
//}

#pragma mark 定制Navigation
- (void)customNavigation {

    self.navigationController.navigationBar.tintColor = MAINCOLOR;
    self.navigationController.navigationBar.clipsToBounds = YES;
    [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
    self.navigationItem.titleView = _searchBar;
    self.navigationItem.backBarButtonItem.title = @"";
}

#pragma mark-------下拉刷新

-(void)setUpRefresh
{
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
//    [btn setTitle:@"400-109-2007" forState:UIControlStateNormal];
//    [btn setTitleColor:WEAKPINK forState:UIControlStateNormal];
//    btn.titleLabel.textAlignment = NSTextAlignmentRight;
//    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:@selector(cellPhone) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)cellPhone {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-109-2007"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark-------创建TableView

-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBar_H + navigationBar_H, SCREEN_W, SCREEN_H-49) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    

    self.tableView.tableHeaderView = [self createHeadBgView];
    
//    UILabel *footLabel=[GQControls createLabelWithFrame:CGRectMake(0, 0, SCREEN_W, 30) andText:@"没有更多内容咯～" andTextColor:MAINCOLOR andFontSize:10];
//    footLabel.textAlignment=NSTextAlignmentCenter;
//    self.tableView.tableFooterView=footLabel;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.funnyListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *funnyTestModuleLabel = [GQControls createLabelWithFrame:CGRectMake(0, 0, SCREEN_W, 1) andText:@"" andTextColor:MAINCOLOR andFontSize:15];
    funnyTestModuleLabel.backgroundColor = [UIColor lightGrayColor];
//    funnyTestModuleLabel.textAlignment = NSTextAlignmentCenter;
    self.sectionHeaderLabel = funnyTestModuleLabel;
    return self.sectionHeaderLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    [self setNeedsStatusBarAppearanceUpdate];
//    if (self.tableView.contentOffset.y >= 325) {
//
//        self.sectionHeaderLabel.hidden = YES;
//        self.navigationItem.title = @"乐天派";
//        self.navigationController.navigationBarHidden = NO;
//    }else{
//
//        self.sectionHeaderLabel.hidden = NO;
//        self.navigationController.navigationBarHidden = YES;
//    }
//}



#pragma mark------cell定制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCell *cell = [HomeCell cellWithTableView:tableView];
    cell.titleLabel.text = self.funnyListArray[indexPath.row].ArticleName;
    cell.timeLabel.text = self.funnyListArray[indexPath.row].CreatedDate;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.funnyListArray[indexPath.row].ArticleImg]];
    

    return cell;
}

#pragma mark------cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    selectionArticleVC *articleVC = [[selectionArticleVC alloc]init];
    articleVC.ArticleUrl = self.funnyListArray[indexPath.row].ArticleUrl;
    articleVC.ID = self.funnyListArray[indexPath.row].ID;
//    articleVC.ArticleTitle = self.funnyListArray[indexPath.row].ArticleName;
//    articleVC.ArticleImg = self.funnyListArray[indexPath.row].ArticleImg;
//    funnyVc.activeModel=self.funnyListArray[indexPath.row];
    articleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:articleVC animated:YES];
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
        
//        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
//        for (int i = 0; i < 3; i++) {
//            [_scrollView.imageViews[i] sd_setImageWithURL:[NSURL URLWithString:weakSelf.funnyListArray[i].ArticleImg]];
//
//        }
//        [weakSelf.tableView.tableHeaderView addSubview:[self createScrollView]];


        
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

- (UIView *)createHeadBgView {
    
    UIView *headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 75+SCREEN_W*0.6)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_W*0.6, SCREEN_W, 70)];
//    view.backgroundColor = MAINCOLOR;
    
    NSArray *nameArray = @[@"心理专栏",@"专业测试",@"成长乐园"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W / 3 * i, 0, SCREEN_W / 3, view.height)];
        [view addSubview:btn];
        [btn setTitle:nameArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"first%d",i+1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        [self textUnderImageButton:btn];
    }
    [headBgView addSubview:view];
    [self addPagerView:headBgView];
//    [self customSearchBar:headBgView];
//    [self loadData];
    return headBgView;
}

- (void)textUnderImageButton:(UIButton *)button {
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

#pragma mark------点击头视图模块
- (void)headBtnClick:(UIButton *)btn {
    
    if (btn.tag == 100) {
        CategoryViewController *articleVc = [[CategoryViewController alloc]init];
        articleVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:articleVc animated:YES];
        //跳到测试
    } else if (btn.tag == 101) {
        if (![GQUserManager isHaveLogin]) {
            //            NSLog(@"登录一下");
            //未登录
            UIAlertController *alertControl  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self) weakSelf = self;
            [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                LoginViewController *loginVc = [[LoginViewController alloc]init];
                loginVc.hidesBottomBarWhenPushed = YES;
                [weakSelf presentViewController:loginVc animated:YES completion:nil];
            }]];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertControl animated:YES completion:nil];
            
        }else{
            
            TestViewController *testVc = [[TestViewController alloc]init];
            testVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:testVc animated:YES];
        }
        //跳到活动
    } else if (btn.tag == 102) {
        ActivityListViewController *activityVc=[[ActivityListViewController alloc]init];
        activityVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activityVc animated:YES];
    }
}



#pragma mark 轮播图
- (void)addPagerView:(UIView *)bgView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W*0.6)];
//    pagerView.layer.borderWidth = 1;
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 4.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    // registerClass or registerNib
    [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [bgView addSubview:pagerView];
    _pagerView = pagerView;
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    //pageControl.numberOfPages = _datas.count;
    pageControl.currentPageIndicatorSize = CGSizeMake(6, 6);
    pageControl.pageIndicatorSize = CGSizeMake(12, 6);
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    //    pageControl.pageIndicatorImage = [UIImage imageNamed:@"Dot"];
    //    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"DotSelected"];
    //    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    //    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    [_pagerView addSubview:pageControl];
    _pageControl = pageControl;
}

//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    _pagerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200);
//    _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame), 26);
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
    //[_pagerView scrollToItemAtIndex:3 animate:YES];
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 4;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
//    cell.backgroundColor = MAINCOLOR;
    if (!self.funnyListArray.count) {
        [cell.bgImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"index_%ld",index+1]]];
    } else {
        [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:self.funnyListArray[index].ArticleImg]];
    }
    
//    [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:self.funnyListArray[index].ArticleImg] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"index_%ld",index+1]]];
//    [cell.bgImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"index_%ld",index+1]]];
    cell.label.text = [NSString stringWithFormat:@"index->%ld",index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.8, CGRectGetHeight(pageView.frame)*0.8);
    layout.itemSpacing = 15;
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
    
    NSLog(@"%d",index);
    selectionArticleVC *articleVC = [[selectionArticleVC alloc]init];
    articleVC.ArticleUrl = self.funnyListArray[index].ArticleUrl;
    articleVC.ID = self.funnyListArray[index].ID;
    articleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:articleVC animated:YES];

}








-(GQScrollView *)createScrollView
{
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
        articleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:articleVC animated:NO];
        
        
//        if (index==0) {
//            self.tabBarController.selectedIndex=1;
//            //跳到文章列表
//        }else if (index==1) {
//            CategoryViewController *articleVc=[[CategoryViewController alloc]init];
//            articleVc.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:articleVc animated:NO];
//            //跳到测试
//        }else if (index==2) {
//            if (![GQUserManager isHaveLogin]) {
////                NSLog(@"登录一下");
//                //未登录
//                UIAlertController *alertControl  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
//                __weak typeof(self) weakSelf = self;
//                [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//
//                    LoginViewController *loginVc = [[LoginViewController alloc]init];
//                    loginVc.hidesBottomBarWhenPushed = YES;
//                    [weakSelf presentViewController:loginVc animated:YES completion:nil];
//                }]];
//                [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//
//                [self presentViewController:alertControl animated:YES completion:nil];
//
//            }else{
//
//                TestViewController *testVc=[[TestViewController alloc]init];
//                testVc.hidesBottomBarWhenPushed=YES;
//                [self.navigationController pushViewController:testVc animated:NO];
//            }
//            //跳到活动
//        }else if (index==3){
//            ActivityListViewController *activityVc=[[ActivityListViewController alloc]init];
//            activityVc.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:activityVc animated:YES];
//        }

    
    }];
    
   
    _scrollView.color_currentPageControl = MAINCOLOR;
//    [_scrollView reloadInputViews];
//    NSLog(@"%@",_scrollView.scrollView.subviews);
    
    
    return _scrollView;
}

//
////是否可以旋转
//- (BOOL)shouldAutorotate
//{
//    return false;
// }
////支持的方向
// -(UIInterfaceOrientationMask)supportedInterfaceOrientations
// {
//    return UIInterfaceOrientationMaskPortrait;
// }
#pragma mark------特效

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    CATransform3D rotation;
//    rotation = CATransform3DMakeRotation((90.0*M_PI/180), 0.0, 0.7, 0.4);
//    rotation.m44 = 1.0/-600;
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    cell.layer.transform = rotation;
//    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
//    [UIView beginAnimations:@"rotaion" context:NULL];
//    [UIView setAnimationDuration:0.3];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
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
