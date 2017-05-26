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
#import "ChatViewController.h"

#import "GQUserManager.h"
#import "LoginViewController.h"

#import "UIImageView+WebCache.h"
#import "Colours.h"
#import "UIImage+ImageEffects.h"

#import "GQActionSheet.h"
#import <UShareUI/UShareUI.h>


@interface CounselorInfoVC ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) UIImageView  *headView;
@property (nonatomic, strong) UIImageView  *naviView;
//@property (nonatomic, strong) UIVisualEffectView *effectview;
@property (nonatomic, strong) UITableView  *mainTableView;
@property (nonatomic, strong) UIView       *holdView;
@property (nonatomic, strong) UITabBar     *tabBar;


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
    UIButton *btn                          = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item                  = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    self.naviView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, navigationBar_H + statusBar_H)];
    self.naviView.contentMode = UIViewContentModeScaleAspectFill;
    self.naviView.clipsToBounds = YES;
    
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


#pragma mark---------弹出分享面板

- (void)clickShareBtn {
    NSArray *titles = @[@"分享到朋友圈",@"分享到微信",@"分享到微博",@"分享到空间",@"分享到短信",@"分享到QQ"];
    NSArray *imageNames = @[@"pengyou",@"weixin",@"weibo",@"kongjian",@"mess",@"qq"];
    GQActionSheet *sheet = [[GQActionSheet alloc] initWithTitles:titles iconNames:imageNames];
    [sheet showActionSheetWithClickBlock:^(int btnIndex) {
        NSLog(@"btnIndex:%d",btnIndex);
        NSInteger platformType;
        if (btnIndex==0) {
            platformType=ShareTo_WechatTimeLine;
        }else if (btnIndex==1){
            platformType=ShareTo_WechatSession;
        }else if (btnIndex==2){
            platformType=ShareTo_Sina;
        }else if (btnIndex==3){
            platformType=ShareTo_Qzone;
        }else if (btnIndex==4){
            platformType=ShareTo_Sms;
        }else {
            platformType=ShareTo_QQ;
        }
        [self shareWebPageToPlatformType:platformType];
    } cancelBlock:nil];
}

#pragma mark---------分享截图

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:[GQControls captureScrollView:self.mainTableView]];
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBHudSet showText:@"分享失败" andOnView:self.view];
        }else{
            [MBHudSet showText:@"分享成功" andOnView:self.view];
        }
    }];
}

#pragma mark 主界面tableview
- (void)customMainTableView {
    
    _mainTableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-tabBar_H) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTableView];
    _mainTableView.backgroundColor    = [UIColor whiteColor];
    _mainTableView.delegate           = self;
    _mainTableView.dataSource         = self;
    //自动计算高度 iOS8
    _mainTableView.estimatedRowHeight = 44.0;
    _mainTableView.rowHeight          = UITableViewAutomaticDimension;
    _mainTableView.separatorStyle     = UITableViewCellSeparatorStyleNone;

    _holdView                         = [[UIView alloc]init];
    _holdView.backgroundColor         = MAINCOLOR;
    [_mainTableView addSubview:_holdView];

}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConfirmPageCell *cell = [ConfirmPageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;                        //设置cell不可以点
    
    NSArray *lableTagArr = @[@"简介",@"擅长领域",@"咨询特点",@"咨询理念"];
    cell.labelTag.text = lableTagArr[indexPath.row];
    NSArray *detialArr = @[self.counselModel.Description,self.counselModel.Expertise,self.counselModel.Specific,self.counselModel.Idea];
    cell.detialLab.text = detialArr[indexPath.row];
    
    return cell;
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

#pragma mark 头部视图
- (void)customHeadView {
    
    _headView                      = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H*0.3)];
//    [_headView sd_setImageWithURL:[NSURL URLWithString:self.counselModel.HeadImg]];
    _headView.contentMode          = UIViewContentModeScaleAspectFill;
    _headView.clipsToBounds        = YES;

    UIView *view                   = [[UIView alloc]init];
    view.frame                     = _headView.frame;
    [view addSubview:_headView];

    _mainTableView.tableHeaderView = view;

    UIImageView *primaryPic = [UIImageView new];
    [primaryPic sd_setImageWithURL:[NSURL URLWithString:self.counselModel.HeadImg] placeholderImage:[UIImage imageNamed:@"mine_bg"]];
    UIImage *blurImage             = [primaryPic.image blurImageWithRadius:15];
    _headView.image                = blurImage;

//咨询师头像
    UIImageView *picView = [[UIImageView alloc]init];
    [picView sd_setImageWithURL:[NSURL URLWithString:self.counselModel.HeadImg]];
    picView.layer.cornerRadius = SCREEN_W/10;
    picView.layer.borderWidth = 1;
    picView.layer.borderColor = ([UIColor whiteColor].CGColor);
    picView.layer.masksToBounds = YES;
    [view addSubview:picView];
    [picView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_headView.mas_centerX);
        make.centerY.equalTo(_headView.mas_centerY);
        make.width.equalTo(_headView.mas_width).multipliedBy(0.2);
        make.height.equalTo(_headView.mas_width).multipliedBy(0.2);
    }];
    
    UIImageView *sexView = [[UIImageView alloc]init];
    [view addSubview:sexView];
    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(picView.mas_bottom);
        make.right.equalTo(picView.mas_right);
        make.width.equalTo(picView.mas_width).multipliedBy(0.3);
        make.height.equalTo(picView.mas_height).multipliedBy(0.3);
    }];
    
    float lineHeight = (_headView.height/2-_headView.width*0.1)/7;
    NSLog(@"%f",lineHeight);
//咨询师名字
    UILabel *nameLab = [[UILabel alloc]init];
    [view addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(picView.mas_centerX);
        make.top.equalTo(picView.mas_bottom).offset(lineHeight);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.3);
        make.height.equalTo(picView.mas_height).multipliedBy(0.25);
    }];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = self.counselModel.UserName;
    nameLab.textColor = [UIColor whiteColor];
    nameLab.shadowOffset = CGSizeMake(0, 1);
    nameLab.font = [UIFont systemFontOfSize:14 weight:2];
//咨询师称号
    UILabel *statusLab = [[UILabel alloc]init];
    [view addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nameLab.mas_centerX);
        make.top.equalTo(nameLab.mas_bottom).offset(lineHeight);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.3);
        make.height.equalTo(nameLab.mas_height);
    }];
    statusLab.textAlignment = NSTextAlignmentCenter;
    statusLab.textColor = [UIColor whiteColor];
    statusLab.shadowOffset = CGSizeMake(0, 1);
    statusLab.font = [UIFont systemFontOfSize:12];
    if ([_counselModel.UserTitleString containsString:@"心理咨询师"]) {
        statusLab.text = _counselModel.UserTitleString;
    } else {
        statusLab.text = [NSString stringWithFormat:@"%@心理咨询师",_counselModel.UserTitleString];
    }

    if (self.counselModel.EnumSexType == 0) {
        
        sexView.image = [UIImage imageNamed:@"male"];
//        nameLab.shadowColor = [UIColor robinEggColor];
//        statusLab.shadowColor = [UIColor robinEggColor];
    } else {
        
        sexView.image = [UIImage imageNamed:@"female"];
//        nameLab.shadowColor = MAINCOLOR;
//        statusLab.shadowColor = MAINCOLOR;
    }


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    
    NSLog(@"%f",self.mainTableView.contentOffset.y - self.headView.height + navigationBar_H + statusBar_H);
    NSLog(@"原：%f",offset.y);
    if (offset.y < 0) {
        
        CGRect rect = self.headView.frame;
        rect.origin.y = offset.y;
        rect.size.height = (SCREEN_H*0.3) - offset.y;
        _headView.frame = rect;
    } else if (offset.y > (self.headView.height - navigationBar_H - statusBar_H)) {
        
        NSLog(@"aaa");
        [self.view addSubview:self.naviView];
        self.naviView.image = self.headView.image;
        self.naviView.height = self.headView.height;
        self.naviView.bottom = navigationBar_H + statusBar_H;
        self.navigationItem.title = self.counselModel.UserName;
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
        
    } else {
        NSLog(@"ddd");
        [self.naviView removeFromSuperview];
        self.navigationItem.title = nil;

    }
}

#pragma mark 定制底部TabBar
- (void)creatBottomBar {
    
    _tabBar                            = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_H-tabBar_H, SCREEN_W, tabBar_H)];
    //预约按钮
    UIButton *AppointmentBtn           = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*2/3, 0, SCREEN_W/3, tabBar_H)];
    AppointmentBtn.backgroundColor     = MAINCOLOR;
//    [AppointmentBtn setBackgroundImage:[UIImage imageNamed:@"btnBackImage"] forState:UIControlStateNormal];
    [AppointmentBtn setTitle:@"预约" forState:UIControlStateNormal];
    [AppointmentBtn addTarget:self action:@selector(clickAppointmentBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:AppointmentBtn];
    //咨询按钮
    UIButton *askBtn                   = [[UIButton alloc]initWithFrame:CGRectMake(15, 3, tabBar_H*2/3, tabBar_H*2/3)];
    [_tabBar addSubview:askBtn];
    [askBtn setImage:[UIImage imageNamed:@"ask"] forState:UIControlStateNormal];
    [askBtn addTarget:self action:@selector(clickAskBrn) forControlEvents:UIControlEventTouchUpInside];
    UILabel *askLab                    = [[UILabel alloc]initWithFrame:CGRectMake(15, tabBar_H*2/3, tabBar_H*2/3, tabBar_H/3)];
    [_tabBar addSubview:askLab];
    askLab.text                        = @"咨询";
    askLab.textAlignment               = NSTextAlignmentCenter;
    askLab.font                        = [UIFont systemFontOfSize:10];
    askLab.textColor                   = [UIColor darkGrayColor];
    [self.view addSubview:_tabBar];
    //价格lable
    UILabel *priceLab                  = [[UILabel alloc]init];
    priceLab.adjustsFontSizeToFitWidth = YES;
    [_tabBar addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(AppointmentBtn.mas_left).offset(-SCREEN_W/100);
        make.top.equalTo(_tabBar.mas_top);
        make.width.equalTo(_tabBar.mas_width).multipliedBy(0.3);
        make.height.equalTo(_tabBar.mas_height);
    }];
    priceLab.textColor                 = MAINCOLOR;
    priceLab.text                      = [NSString stringWithFormat:@"%ld元／小时",_counselModel.ConsultFee];
    priceLab.textAlignment             = NSTextAlignmentRight;
    priceLab.font                      = [UIFont boldSystemFontOfSize:15];
    //优惠lable
    UILabel *couponLab                 = [[UILabel alloc]init];
    [_tabBar addSubview:couponLab];
    [couponLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(priceLab.mas_right);
        make.bottom.equalTo(_tabBar.mas_bottom);
        make.width.equalTo(priceLab.mas_width);
        make.height.equalTo(priceLab.mas_height).multipliedBy(0.5);
    }];
    NSLog(@"%.2f",_counselModel.ConsultDisCount);
    couponLab.text                     = [NSString stringWithFormat:@"%@",_counselModel.ConsultTag];
    couponLab.textColor                = [UIColor orangeColor];
    couponLab.textAlignment            = NSTextAlignmentRight;
    couponLab.font                     = [UIFont boldSystemFontOfSize:10];

}

- (void)clickAskBrn {
    
    if ([GQUserManager isHaveLogin]) {

        ChatViewController *chatVc = [[ChatViewController alloc]init];
        chatVc.hidesBottomBarWhenPushed = YES;
        chatVc.conversationType = ConversationType_PRIVATE;
        chatVc.targetId = @"12";
        chatVc.title = @"小乐";
        [self.navigationController pushViewController:chatVc animated:YES];
    } else {
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"登陆后可以享受15分钟免费咨询哦" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
        __weak typeof(self) weakSelf    = self;
        [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            __strong typeof(self) strongSelf = weakSelf;
            LoginViewController *loginVc     = [[LoginViewController alloc]init];
            loginVc.hidesBottomBarWhenPushed = YES;
            [strongSelf presentViewController:loginVc animated:YES completion:nil];
        }]];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    }

}

- (void)clickAppointmentBtn {
    
    if ([GQUserManager isHaveLogin]) {
    
        ConfirmPageVC *confirmPagevc = [[ConfirmPageVC alloc]init];
        confirmPagevc.counselModel   = self.counselModel;
        [self.rt_navigationController pushViewController:confirmPagevc animated:YES];
    } else {
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
        alertControl.view.tintColor=[UIColor blackColor];
        [self presentViewController:alertControl animated:YES completion:nil];

        __weak typeof(self) weakSelf    = self;
        [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            __strong typeof(self) strongSelf = weakSelf;
            LoginViewController *loginVc     = [[LoginViewController alloc]init];
            loginVc.hidesBottomBarWhenPushed = YES;
            [strongSelf presentViewController:loginVc animated:YES completion:nil];
        }]];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    }

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
