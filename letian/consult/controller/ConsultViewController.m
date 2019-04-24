//
//  ConsultViewController.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ConsultViewController.h"
#import "consultPageCell.h"
#import "SpecialCollectionViewCell.h"
#import "counselorInfoModel.h"
#import "CounselorInfoVC.h"
#import "GQUserManager.h"
#import "LoginViewController.h"

#import "ZLDropDownMenuUICalc.h"
#import "ZLDropDownMenuCollectionViewCell.h"
#import "ZLDropDownMenu.h"
#import "NSString+ZLStringSize.h"

#import "MJExtension.h"
#import "SnailPopupController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "Colours.h"
//#import "JSDropDownMenu.h"

#import "ChatListViewController.h"


@interface ConsultViewController ()<ZLDropDownMenuDelegate, ZLDropDownMenuDataSource, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray <counselorInfoModel  *> *counselorArr;

@property (nonatomic, copy  ) NSDictionary        *counselorCategoryDic;
@property (nonatomic, copy  ) NSDictionary        *counselorTitleDic;
@property (nonatomic, strong) NSMutableArray      *counselorCategoryArr;
@property (nonatomic, strong) NSMutableArray      *counselorTitleArr;
@property (nonatomic, copy  ) NSArray             *priceDataSource;
@property (nonatomic, strong) NSMutableArray      *regionArr;
@property (nonatomic, strong) NSMutableArray      *regionDicArr;
@property (nonatomic, strong) NSMutableDictionary *requestParams;
@property (nonatomic        ) NSInteger           pageIndex;

@property (nonatomic, copy  ) NSArray             *mainTitleArray;
@property (nonatomic, strong) NSMutableArray      *subTitleArray;
@property (nonatomic, strong) NSMutableArray      *priceData;

@property (nonatomic, strong) UISearchBar         *searchBar;
@property (nonatomic, strong) ZLDropDownMenu      *menu;
@property (nonatomic, strong) UIScrollView        *classifiedSectionFirstLine;
@property (nonatomic, strong) UITableView         *counselorInfoTableview;
@property (nonatomic, strong) UICollectionView    *mainCollectionView;
@property (nonatomic, strong) UILabel             *noDataLab;
@property (nonatomic, strong) UIView              *mainHeadView;


@end

@implementation ConsultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.automaticallyAdjustsScrollViewInsets = NO;

    _counselorArr = [NSMutableArray new];
    _requestParams = [NSMutableDictionary new];
    
    [self customSearchBar];
    [self customNavigation];
    [self creatTableView];
//    [self creatCollectionView];
    if (!kFetchUChoise) {
        [_requestParams setValue:@(0) forKey:@"enumPsyCategory"];
        [self relodeDate];
    }
    [self setupMJRefresh];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (kFetchUChoise) {
        [_requestParams setValue:kFetchUChoise forKey:@"enumPsyCategory"];
        [self relodeDate];
    }
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
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

    [_searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (NULLString(searchText)) {
        [_requestParams removeObjectForKey:@"SearchName"];
        [self getCounsultListSource];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [_requestParams setValue:searchBar.text forKey:@"SearchName"];
    [self.searchBar resignFirstResponder];
    [self getCounsultListSource];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_requestParams removeObjectForKey:@"SearchName"];
    [self getCounsultListSource];
    searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark 定制Navigation
- (void)customNavigation {
    
    self.navigationController.navigationBar.tintColor = MAINCOLOR;
    self.navigationController.navigationBar.clipsToBounds = YES;
    [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
    self.navigationItem.titleView = _searchBar;
    self.navigationItem.backBarButtonItem.title = @"";
}

- (void)selRightButton {
    
    ChatListViewController *chatListVc  = [[ChatListViewController alloc]init];
    chatListVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatListVc animated:YES];
}

#pragma mark - 获取Date
- (void)relodeDate {
    
    [_requestParams setValue:@(0) forKey:@"enumUserTitle"];
    [_requestParams removeObjectForKey:@"MinFee"];
    [_requestParams removeObjectForKey:@"MaxFee"];

    [self getCounsultTypeSource];
    [self getCounsultListSource];
}


#pragma mark 获取类型信息
- (void)getCounsultTypeSource {
    
    _counselorCategoryDic = [NSMutableDictionary new];
    _counselorTitleDic = [NSMutableDictionary new];
    _counselorCategoryArr = [NSMutableArray new];
    _counselorTitleArr = [NSMutableArray new];
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableString *requestConsultPsyAndTitleListString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestConsultPsyAndTitleListString appendFormat:@"%@/",API_MODULE_UTILS];
    [requestConsultPsyAndTitleListString appendFormat:@"%@",API_NAME_GETCONSULTTITLELIST];
    
    [PPNetworkHelper GET:requestConsultPsyAndTitleListString parameters:nil success:^(id responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.counselorCategoryDic = responseObject[@"Result"][@"Source"][@"PsyCategoryDic"];
        strongSelf.counselorCategoryArr = [strongSelf arrangeForKeyWithDic:strongSelf.counselorCategoryDic];
        strongSelf.counselorTitleDic = responseObject[@"Result"][@"Source"][@"UserTitleDic"];
        strongSelf.counselorTitleArr = [strongSelf arrangeForKeyWithDic:strongSelf.counselorTitleDic];
        [strongSelf getRegionList];
    } failure:^(NSError *error) {
        
        __strong typeof(self) strongSelf = weakSelf;
//        [MBHudSet dismiss:strongSelf.view];
        [strongSelf.counselorInfoTableview.mj_header endRefreshing];
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

- (void)getRegionList {
    
    __weak typeof(self) weakSelf = self;
    _regionArr = [NSMutableArray new];
    _regionDicArr = [NSMutableArray new];
    
    NSMutableString *requestConsultPsyAndTitleListString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestConsultPsyAndTitleListString appendFormat:@"%@/",API_MODULE_REGION];
    [requestConsultPsyAndTitleListString appendFormat:@"%@",API_NAME_GETBUSINESSREGIN];
    
    [PPNetworkHelper GET:requestConsultPsyAndTitleListString parameters:nil success:^(id responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;

        strongSelf.regionDicArr = responseObject[@"Result"][@"Source"];
        [strongSelf.regionArr addObject:@"全部地区"];
        for (NSDictionary *dic in responseObject[@"Result"][@"Source"]) {
//            NSLog (dic[@"FullName"]);
            [strongSelf.regionArr addObject:dic[@"FullName"]];
        }
        
        [strongSelf.mainHeadView removeAllSubviews];
        [strongSelf creatClassifiedSection];

    } failure:^(NSError *error) {
        
        __strong typeof(self) strongSelf = weakSelf;
        //        [MBHudSet dismiss:strongSelf.view];
        [strongSelf.counselorInfoTableview.mj_header endRefreshing];
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
    
    _pageIndex = 1;
    [_counselorInfoTableview.mj_footer endRefreshing];

    __weak typeof(self) weakSelf = self;
    [MBHudSet showStatusOnView:self.view];

    NSMutableString *requestConsultListString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestConsultListString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestConsultListString appendFormat:@"%@",API_NAME_GETCONSULTLIST];
    [_requestParams setValue:@(_pageIndex) forKey:@"pageIndex"];
    [PPNetworkHelper GET:requestConsultListString parameters:_requestParams success:^(id responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        [MBHudSet dismiss:strongSelf.view];
        [strongSelf.counselorArr removeAllObjects];
        strongSelf.counselorArr = [counselorInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
        
        if (strongSelf.counselorArr.count == 0) {
            strongSelf.counselorInfoTableview.mj_footer.hidden = YES;
            [strongSelf.counselorInfoTableview addSubview:strongSelf.noDataLab];
        } else if (strongSelf.counselorArr.count < 10) {
            [strongSelf.noDataLab removeFromSuperview];
            strongSelf.counselorInfoTableview.mj_footer.hidden = YES;
        } else {
            [strongSelf.noDataLab removeFromSuperview];
            strongSelf.counselorInfoTableview.mj_footer.hidden = NO;
        }
        
        [strongSelf.counselorInfoTableview reloadData];
        [strongSelf.counselorInfoTableview.mj_header endRefreshing];
        [strongSelf.counselorInfoTableview.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        __strong typeof(self) strongSelf = weakSelf;
        [MBHudSet dismiss:strongSelf.view];
        [strongSelf.counselorInfoTableview.mj_header endRefreshing];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:strongSelf.view];
        } else {
            [MBHudSet showText:@"请求失败" andOnView:strongSelf.view];
        }
    }];
}

- (void)getMoreDate {
    
    _pageIndex++;
    __weak typeof(self) weakSelf   = self;
    
    NSMutableString *requestConsultListString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestConsultListString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestConsultListString appendFormat:@"%@",API_NAME_GETCONSULTLIST];
    [_requestParams setValue:@(_pageIndex) forKey:@"pageIndex"];
    
    [PPNetworkHelper GET:requestConsultListString parameters:_requestParams success:^(id responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;
        NSArray <counselorInfoModel  *> *moreConselor =  [counselorInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
        if (moreConselor.count >= 10) {
            strongSelf.counselorInfoTableview.mj_footer.hidden = NO;
            [strongSelf.counselorInfoTableview.mj_footer endRefreshing];
        }else{
            [strongSelf.counselorInfoTableview.mj_footer endRefreshingWithNoMoreData];
        }

        [strongSelf.counselorArr addObjectsFromArray:moreConselor];

        [strongSelf.counselorInfoTableview reloadData];
        
        
    } failure:^(NSError *error) {
        
        __strong typeof(self) strongSelf = weakSelf;
        [MBHudSet dismiss:strongSelf.view];
        [strongSelf.counselorInfoTableview.mj_header endRefreshing];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:strongSelf.view];
        } else {
            [MBHudSet showText:@"请求失败" andOnView:strongSelf.view];
        }
        [strongSelf.counselorInfoTableview.mj_footer endRefreshing];

    }];
    
}

#pragma mark - 创建分类栏
- (void)creatClassifiedSection {

    _mainTitleArray = @[@"咨询类型", @"咨询师资历", @"价格", @"地区"];
    _priceDataSource = @[@"全部价格(元)",@"500及以下",@"500-1000",@"1000及以上"];
//    _regionArr = @[@"全部地区",@"上海"];
    _subTitleArray = [NSMutableArray new];
    [_subTitleArray addObject:_counselorCategoryArr];
    [_subTitleArray addObject:_counselorTitleArr];
    [_subTitleArray addObject:_priceDataSource];
    [_subTitleArray addObject:_regionArr];

    _menu = [[ZLDropDownMenu alloc] initWithFrame:CGRectMake(0, statusBar_H + navigationBar_H, deviceWidth(), 50.f)];
    _menu.delegate = self;
    _menu.dataSource = self;
    _counselorInfoTableview.tableHeaderView = _menu;
    

}

// ZLDropDownMenuDataSource
- (NSInteger)numberOfColumnsInMenu:(ZLDropDownMenu *)menu {
    return _mainTitleArray.count;
}

- (NSInteger)menu:(ZLDropDownMenu *)menu numberOfRowsInColumns:(NSInteger)column {
    return [self.subTitleArray[column] count];
}

- (NSString *)menu:(ZLDropDownMenu *)menu titleForColumn:(NSInteger)column {
    return self.mainTitleArray[column];
}

- (NSString *)menu:(ZLDropDownMenu *)menu titleForRowAtIndexPath:(ZLIndexPath *)indexPath {
    NSArray *array = self.subTitleArray[indexPath.column];
    if (kFetchUChoise && indexPath.column == 0 && indexPath.row == 0) {
        NSString *vel = kFetchUChoise;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserChoise];
        return _counselorCategoryDic[vel];
    } else {
        return array[indexPath.row];
    }
}

// ZLDropDownMenuDelegate
- (void)menu:(ZLDropDownMenu *)menu didSelectRowAtIndexPath:(ZLIndexPath *)indexPath {
    NSArray *array = self.subTitleArray[indexPath.column];
    if (indexPath.column == 0) {
//        [_requestParams setValue:array[indexPath.row] forKey:@"enumPsyCategory"];
        NSArray *categoryKeyArr = _counselorCategoryDic.allKeys;
        for (id key in categoryKeyArr) {
            if ([array[indexPath.row] isEqual:_counselorCategoryDic[key]]) {
                [_requestParams setValue:key forKey:@"enumPsyCategory"];
            }
        }
    } else if (indexPath.column == 1) {
        NSArray *keyArr = _counselorTitleDic.allKeys;
        for (id key in keyArr) {
            if ([array[indexPath.row] isEqual:_counselorTitleDic[key]]) {
                [_requestParams setValue:key forKey:@"enumUserTitle"];
            }
        }
    } else if (indexPath.column == 2) {
        if (indexPath.row == 0) {
            [_requestParams removeObjectForKey:@"MinFee"];
            [_requestParams removeObjectForKey:@"MaxFee"];
        } else if (indexPath.row == 1) {
            [_requestParams setValue:@(0) forKey:@"MinFee"];
            [_requestParams setValue:@(500) forKey:@"MaxFee"];
        } else if (indexPath.row == 2) {
            [_requestParams setValue:@(500) forKey:@"MinFee"];
            [_requestParams setValue:@(1000) forKey:@"MaxFee"];
        } else if (indexPath.row == 3) {
            [_requestParams setValue:@(1000) forKey:@"MinFee"];
            [_requestParams removeObjectForKey:@"MaxFee"];
        }
    } else {
        for (int i = 0; i < _regionDicArr.count; i++) {
            if (array[indexPath.row] == _regionDicArr[i][@"FullName"]) {
//                NSLog(@"%@",_regionDicArr[i][@"ID"]);
                NSInteger ID = [_regionDicArr[i][@"ID"] integerValue];
                [_requestParams setValue:@(ID) forKey:@"RegionID"];
                break;
            } else {
                [_requestParams removeObjectForKey:@"RegionID"];
            }
        }
    }
    
    [self getCounsultListSource];
}

#pragma mark - 创建CollectionView
- (void)creatCollectionView {
    
    //流式布局对象--用来布局的
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //创建集合视图--用flowLayout来布局
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, statusBar_H + navigationBar_H, SCREEN_W, 85) collectionViewLayout:flowLayout];
    [self.view addSubview:_mainCollectionView];
    _mainCollectionView.dataSource = self;
    _mainCollectionView.delegate = self;
    _mainCollectionView.backgroundColor = [UIColor whiteColor];
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"SpecialCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SpecialCollectionViewCell"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //先复用，如果复用失败会自动创建
    SpecialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
//    cell.backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
//    cell.backgroundView.layer.shadowOpacity = 0.8f;
//    cell.backgroundView.layer.shadowRadius = 4.f;
//    cell.backgroundView.layer.shadowOffset = CGSizeMake(4, 4);
    
    return cell;
}

#pragma mark flowLayout协议方法
//返回cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(130, 75);
}

//当前组相对于上下左右cell的偏移的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 5);
}

//返回最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}

//返回最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}





#pragma mark - 创建tabview
- (void)creatTableView {
    
    _counselorInfoTableview                 = [[UITableView alloc]initWithFrame:CGRectMake(0, statusBar_H + navigationBar_H + 0, SCREEN_W, SCREEN_H - statusBar_H - navigationBar_H - tabBar_H) style:UITableViewStylePlain];
    _counselorInfoTableview.dataSource      = self;
    _counselorInfoTableview.delegate        = self;
    _counselorInfoTableview.backgroundColor = [UIColor snowColor];
    [self.view addSubview:_counselorInfoTableview];
    _counselorInfoTableview.rowHeight       = 100;
    _counselorInfoTableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    _noDataLab = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_H*0.4, SCREEN_W, SCREEN_W*0.2)];
    _noDataLab.text               = @"没有符合条件的咨询师";
    _noDataLab.textColor          = MAINCOLOR;
    _noDataLab.textAlignment      = NSTextAlignmentCenter;
}

- (void)setupMJRefresh {
    
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCounsultListSource)];
    //    header.lastUpdatedTimeLabel.textColor = MAINCOLOR;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = MAINCOLOR;
    header.stateLabel.hidden = YES;
    _counselorInfoTableview.mj_header = header;
    _counselorInfoTableview.mj_header.automaticallyChangeAlpha = YES;
    
    _counselorInfoTableview.mj_footer = [RefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreDate)];
    _counselorInfoTableview.mj_footer.hidden = YES;

}


//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    consultPageCell *cell = [consultPageCell cellWithTableView:tableView];
    
    cell.conselorName.text = _counselorArr[indexPath.row].UserName;
    [cell.conselorImage sd_setImageWithURL:[NSURL URLWithString:_counselorArr[indexPath.row].HeadImg] placeholderImage:[UIImage imageNamed:@"乐天logo"]];
    if (_counselorArr[indexPath.row].EnumSexType == 0) {
        cell.conserlorSex.image = [UIImage imageNamed:@"male"];
    } else {
        cell.conserlorSex.image = [UIImage imageNamed:@"female"];
    }
    if ([_counselorArr[indexPath.row].UserTitleString containsString:@"心理咨询师"]) {
        cell.conselorStatus.text = _counselorArr[indexPath.row].UserTitleString;
    } else {
        cell.conselorStatus.text = [NSString stringWithFormat:@"%@心理咨询师",_counselorArr[indexPath.row].UserTitleString];
    }
    cell.conserlorAbout.text = _counselorArr[indexPath.row].Description;
    cell.conserlorPrice.text = [NSString stringWithFormat:@"%ld元/小时",_counselorArr[indexPath.row].ConsultFee];
    cell.conserVisitors.text = [NSString stringWithFormat:@"%@人咨询过",_counselorArr[indexPath.row].TotalConsultCount];
    cell.conserlorRegion.text = _counselorArr[indexPath.row].RegionIDString;
    
    return cell;
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _counselorArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    CounselorInfoVC *counselorInfoMainVC = [[CounselorInfoVC alloc]init];
    counselorInfoMainVC.counselModel = _counselorArr[indexPath.row];
//    counselorInfoMainVC.headImage = _counselorArr[indexPath.row].HeadImg;
    counselorInfoMainVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:counselorInfoMainVC animated:YES];
    
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
