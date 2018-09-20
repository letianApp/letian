//
//  CommitVC.m
//  letian
//
//  Created by J on 2018/7/5.
//  Copyright © 2018年 J. All rights reserved.
//

#import "CommitVC.h"
#import "CommitCell.h"
#import "CommitModel.h"
#import "ZYKeyboardUtil.h"
#import "UIImageView+WebCache.h"
#import "GQUserManager.h"
#import "RegistViewController.h"


@interface CommitVC ()<UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTab;
@property (nonatomic, strong) NSMutableArray <CommitModel *> *mainArr;
@property (nonatomic, strong) UITextField *tabBar;
@property (nonatomic, strong) ZYKeyboardUtil *keyboardUtil;



@end

@implementation CommitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"评论列表";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MAINCOLOR,NSForegroundColorAttributeName, nil]];

    
    self.keyboardUtil = [[ZYKeyboardUtil alloc] init];
    
    [self creatTab];
    [self requestData];
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self creatBottomBar];
    [self configKeyBoardRespond];

}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {
    
    UIButton *btn = [[UIButton alloc]init];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 20, 20)];
    backView.image = [UIImage imageNamed:@"pinkback"];
    [btn addSubview:backView];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (void)creatTab {
    
    _mainTab = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_mainTab];
    _mainTab.delegate = self;
    _mainTab.dataSource = self;
    _mainTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _mainTab.estimatedRowHeight = 44.0;
    _mainTab.rowHeight = UITableViewAutomaticDimension;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommitCell *cell = [CommitCell cellWithTableView:_mainTab];
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:self.mainArr[indexPath.row].HeadImg]];
    cell.nameLab.text = self.mainArr[indexPath.row].CreatedByString;
    cell.dateLab.text = self.mainArr[indexPath.row].CreatedDate;
    cell.detailLab.text = self.mainArr[indexPath.row].CommentContent;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



//返回第section组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainArr.count;
}

- (void)requestData {
    
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_ARTICLE];
    [requestString appendString:API_NAME_GETARTICLECOMMIT];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"articleID"] = @(self.ID);
    params[@"pageIndex"] = @(1);
    params[@"pageSize"] = @(10);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.mainArr = [CommitModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
        NSLog(@"详细：%@",strongSelf.mainArr);
        [strongSelf.mainTab reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}

- (void)creatBottomBar {
    
    //点击空白收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    _tabBar = [[UITextField alloc]initWithFrame:CGRectMake(0, SCREEN_H-tabBar_H, SCREEN_W, tabBar_H)];
    _tabBar.borderStyle = UITextBorderStyleRoundedRect;
    _tabBar.delegate = self;
    _tabBar.placeholder = @"说点什么...";
    _tabBar.returnKeyType = UIReturnKeySend;
    
    [self.view addSubview:_tabBar];
    
}

#pragma mark 键盘处理
- (void)configKeyBoardRespond {
    __weak CommitVC *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.tabBar, nil];
    }];
}

- (void)hideKeyboard {
    //    [self.view endEditing:YES];
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (![GQUserManager isHaveLogin]) {
        
        NSLog(@"点击评论");
        [textField resignFirstResponder];
        textField.tintColor = [UIColor clearColor];
        UIAlertController *alertControl  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertControl animated:YES completion:nil];

        __weak typeof(self) weakSelf = self;
        [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            __strong typeof(self) strongSelf = weakSelf;
            RegistViewController *loginVc     = [[RegistViewController alloc]init];
            loginVc.hidesBottomBarWhenPushed = YES;
            [strongSelf presentViewController:loginVc animated:YES completion:nil];
        }]];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
//    NSLog(@"--发送%@--", textField.text);
    
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_ARTICLE];
    [requestString appendString:API_NAME_DOARTICLECOMMIT];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"ArticleID"] = @(self.ID);
    params[@"CommentContent"] = textField.text;
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    
    [manager POST:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        NSLog(@"发：%@",responseObject);
        [strongSelf requestData];
        textField.text = nil;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
    
    return YES;
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
