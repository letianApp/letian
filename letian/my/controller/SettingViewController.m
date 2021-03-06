//
//  SettingViewController.m
//  letian
//
//  Created by 郭茜 on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "SettingViewController.h"
#import "GQUserManager.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ChangePwCodeViewController.h"

#import "SDImageCache.h"
#import <RongIMKit/RongIMKit.h>
#import "Colours.h"


@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *cancalButton;

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self.cancalButton removeFromSuperview];
    if ([GQUserManager isHaveLogin]) {
        
        [self.view addSubview:self.cancalButton];
    } else {
        
        [self.cancalButton removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self createTableView];
    
    [self createCancelButton];
    
    [self setUpNavigationBar];
}


#pragma mark-----创建tableview

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64) style:UITableViewStylePlain];
//    tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor snowColor];
//    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


#pragma mark-----创建退出登录按钮

-(void)createCancelButton {
    
    UIButton *cancalButton = [GQControls createButtonWithFrame:CGRectMake(0, SCREEN_H - TAB_BAR_HEIGHT, SCREEN_W, TAB_BAR_HEIGHT) andTitle:@"退出登录" andTitleColor:[UIColor whiteColor] andFontSize:15 andBackgroundColor:MAINCOLOR];
    cancalButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [cancalButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancalButton];
    self.cancalButton = cancalButton;
}


#pragma mark--------注销登录

- (void)cancelButtonClick {
    
    UIAlertController *alertControl  = [UIAlertController alertControllerWithTitle:@"确定要退出？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertControl animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        __strong typeof(self) strongSelf = weakSelf;
        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:kFetchUserId];
        [GQUserManager removeAllUserInfo];
        [[RCIM sharedRCIM] logout];
        RegistViewController *loginVc = [[RegistViewController alloc]init];
        
        [strongSelf presentViewController:loginVc animated:YES completion:^{
            
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];

//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [strongSelf.navigationController popToRootViewControllerAnimated:YES];
//                });  
//            });
        }];

    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
}


#pragma mark--------TableViewDelegate----------

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
        view.backgroundColor=[UIColor snowColor];
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 9, SCREEN_W, 1)];
        lineView.backgroundColor=[UIColor lightGrayColor];
        [view addSubview:lineView];
        return view;
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    view.backgroundColor=[UIColor snowColor];
    [view addSubview:[GQControls createLabelWithFrame:CGRectMake(15, 5, 80, 19) andText:@"通知" andTextColor:[UIColor darkGrayColor] andFontSize:15]];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_W, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:lineView];
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
//cell定制
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UIView *lineView=[[UIView alloc]init];
    //分割线
    if (indexPath.row==0) {
        lineView.frame=CGRectMake(15, 49, SCREEN_W-15, 1);
    }else if (indexPath.row==1){
        lineView.frame=CGRectMake(0, 49, SCREEN_W, 1);
    }
    lineView.backgroundColor=[UIColor lightGrayColor];
    [cell.contentView addSubview:lineView];
    //cell赋值
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"修改密码";
        }else if (indexPath.row==1) {
            cell.textLabel.text  = @"清除缓存(正在计算中........)";
            cell.userInteractionEnabled = NO;
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [indicatorView startAnimating];
            cell.accessoryView =indicatorView;            
            [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
                NSString *cachesFile = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"default"];
                NSInteger size = cachesFile.fileSize;
                CGFloat unit = 1000.0;
                NSString *sizeText = @"";
                //大于1GB
                if (size>= pow(10, 9)) {
                    sizeText = [NSString stringWithFormat:@"%.1fGB",size / unit / unit/unit];
                }else if (size>= pow(10, 6) ){//大于1MB
                    sizeText = [NSString stringWithFormat:@"%.1fMB",size / unit / unit];
                }else if (size>= pow(10, 3)  ){//大于1KB
                    sizeText = [NSString stringWithFormat:@"%.1fKB",size / unit];
                }else{
                    sizeText = [NSString stringWithFormat:@"%zdB",size];
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [sizeText isEqualToString:@"0B"] ? (cell.textLabel.text  = @"清除缓存") : (cell.textLabel.text = [NSString stringWithFormat:@"清除缓存(%@)",sizeText]);
                    cell.userInteractionEnabled = YES;
                    cell.accessoryView = nil;
                    
                }];
                
            }];

        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            cell.textLabel.text=@"活动更新推送";
            lineView.frame=CGRectMake(0, 49, SCREEN_W, 1);
            UISwitch *switchView=[GQControls createSwitchWithFrame:CGRectMake(SCREEN_W-65, 10, 0, 0)];
            [switchView addTarget:self action:@selector(changePostActiveState:) forControlEvents:UIControlEventValueChanged];
            switchView.onTintColor = MAINCOLOR;
            [cell.contentView addSubview:switchView];
        }else if (indexPath.row==1){
            cell.textLabel.text=@"订单消息推送";
            lineView.frame=CGRectMake(0, 49, SCREEN_W, 1);
            UISwitch *switchView=[GQControls createSwitchWithFrame:CGRectMake(SCREEN_W-65, 10, 0, 0)];
            switchView.onTintColor = MAINCOLOR;
            [switchView addTarget:self action:@selector(changePostOrderState:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:switchView];
        }
        
    }
    return cell;
}


#pragma mark--------活动更新推送开关

-(void)changePostActiveState:(UISwitch *)switchView
{
    //推送默认是打开的
    switchView.selected=!switchView.selected;
    NSString *state;
    if (switchView.selected==1) {
        state=@"false";
    }else{
        state=@"true";
    }
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_SETPOSTACTIVE];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"isPostActive"]=state;
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
//        NSLog(@"活动更新推送responseObject=%@",responseObject);
        [MBHudSet showText:responseObject[@"Msg"] andOnView:self.view];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
    }];    
}

#pragma mark--------订单消息推送开关

-(void)changePostOrderState:(UISwitch *)switchView{
    
    //推送默认是打开的
    switchView.selected=!switchView.selected;
    NSString *state;
    if (switchView.selected==1) {
        state=@"false";
    }else{
        state=@"true";
    }
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_SETPOSTACTIVE];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"isPostOrder"]=state;
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
//        NSLog(@"订单消息推送responseObject=%@",responseObject);
        [MBHudSet showText:responseObject[@"Msg"] andOnView:self.view];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
    }];
    
}


#pragma mark--------cell点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            //修改密码
            ChangePwCodeViewController *changePwCodeVc=[[ChangePwCodeViewController alloc]init];
            [self.navigationController pushViewController:changePwCodeVc animated:YES];
        }else if (indexPath.row==1){
            //清除缓存
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
            
            [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:^{
                [NSThread sleepForTimeInterval:0.5];
                NSString *cachesFile = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"default"];
                [[NSFileManager defaultManager] removeItemAtPath:cachesFile error:nil];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [MBHudSet showText:@"缓存清除成功！" andOnView:self.view];
                    cell.textLabel.text  = @"清除缓存";
                    cell.userInteractionEnabled = YES;
                    
                }];
            }];
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            //是否推送活动消息
        }
    }
}


-(void) setUpNavigationBar
{
    self.navigationItem.title=@"系统设置";
//    [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;

//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    backButton.frame=CGRectMake(30, 12, 20, 20);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//}
//-(void) back
//{
//    [self.navigationController popViewControllerAnimated:YES];
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
