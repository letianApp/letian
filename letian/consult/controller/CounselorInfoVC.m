//
//  CounselorInfoVC.m
//  letian
//
//  Created by J on 2017/3/9.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CounselorInfoVC.h"
#import "ConfirmPageCell.h"
#import "ThankLetterCell.h"
#import "UserLetterModel.h"
#import "ConfirmPageVC.h"
#import "CYLTabBarController.h"
#import "ChatViewController.h"
#import "RCDCustomerServiceViewController.h"
#import "RegistViewController.h"

#import "GQUserManager.h"
#import "LoginViewController.h"

#import "UIImageView+WebCache.h"
#import "Colours.h"
#import "UIImage+ImageEffects.h"
#import "TDImageColors.h"
//#import "UIImage+MostColor.h"


#import "GQActionSheet.h"
#import <UShareUI/UShareUI.h>

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}


@interface CounselorInfoVC ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) UIImageView  *headView;
@property (nonatomic, strong) UIImageView  *naviView;
//@property (nonatomic, strong) UIVisualEffectView *effectview;
@property (nonatomic, strong) UITableView  *mainTableView;
@property (nonatomic, strong) UIView       *holdView;
@property (nonatomic, strong) UITabBar     *tabBar;

@property (nonatomic, strong) NSMutableArray<UserLetterModel *> *userLetterArr;


@end

@implementation CounselorInfoVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _userLetterArr = [NSMutableArray new];
    
    [self customNavigation];
    [self customMainTableView];
    [self customHeadView];
    [self getUserLetter];
    [self creatBottomBar];
}


#pragma mark - 定制导航栏
- (void)customNavigation {
    
    self.navigationController.navigationBar.clipsToBounds = YES;

    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    btn.translatesAutoresizingMaskIntoConstraints = YES;
    [btn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    if (@available(iOS 11.0, *)){
        [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
//        NSLog(@"导航栏：%@",self.navigationController.navigationBar.subviews);

        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        UIView *containVew = [[UIView alloc] initWithFrame:btn.bounds];
        [containVew addSubview:btn];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containVew];
        self.navigationItem.rightBarButtonItem = item;

    } else {
    
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = item;
    }
    self.naviView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, navigationBar_H + statusBar_H)];
    self.naviView.contentMode = UIViewContentModeScaleAspectFill;
    self.naviView.clipsToBounds = YES;
    
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {

    UIButton *btn = [[UIButton alloc]init];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 20, 20)];
    backView.image = [UIImage imageNamed:@"whiteback"];
    [btn addSubview:backView];
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
//        NSLog(@"btnIndex:%d",btnIndex);
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

#pragma mark - 分享截图

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

#pragma mark - 主界面tableview
- (void)customMainTableView {
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - navigationBar_H) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTableView];
//    _mainTableView.backgroundColor    = [UIColor whiteColor];
    _mainTableView.delegate           = self;
    _mainTableView.dataSource         = self;
    //自动计算高度 iOS8
    _mainTableView.estimatedRowHeight = 44.0;
    _mainTableView.rowHeight          = UITableViewAutomaticDimension;
    _mainTableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
//     [_mainTableView registerClass:[ThankLetterCell class] forCellReuseIdentifier:@"ThankLetterCell"];
    [_mainTableView registerNib:[UINib nibWithNibName:@"ThankLetterCell" bundle:nil] forCellReuseIdentifier:@"ThankLetterCell"];


    _holdView                         = [[UIView alloc]init];
    _holdView.backgroundColor         = [UIColor easterPinkColor];
    [_mainTableView addSubview:_holdView];

    if (@available(iOS 11.0, *)){
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ConfirmPageCell *cell = [ConfirmPageCell cellWithTableView:tableView atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *lableTagArr = @[self.counselModel.DescriptionLabelString,self.counselModel.ExpertiseLabelString,self.counselModel.SpecificLabelString,self.counselModel.IdeaLabelString];
        cell.labelTag.text = lableTagArr[indexPath.row];
        NSArray *detialArr = @[self.counselModel.Description,self.counselModel.Expertise,self.counselModel.Specific,self.counselModel.Idea];
        if (NULLString(detialArr[indexPath.row])) {
            cell.detialLab.text = @"暂无";
        } else {
            cell.detialLab.text = detialArr[indexPath.row];
        }
        
        return cell;
        
    } else {
        ThankLetterCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"ThankLetterCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:_userLetterArr[indexPath.row].HeadImg]];
        cell.nameLab.text = _userLetterArr[indexPath.row].CreatedByString;
        NSString *timeStr = [_userLetterArr[indexPath.row].CreatedDate substringToIndex:10];
        cell.timeLab.text = timeStr;
        cell.detailLab.text = _userLetterArr[indexPath.row].LetterContent;

        return cell;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1 && self.userLetterArr.count) {
        UIView *bgview = [[UIView alloc]init];
        UILabel *clView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_W-20, 30)];
        clView.text = @"感谢信";
        clView.textColor = [UIColor whiteColor];
        clView.font = [UIFont boldSystemFontOfSize:17];
        clView.textAlignment = NSTextAlignmentCenter;
        clView.backgroundColor = [UIColor coralColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:clView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = clView.bounds;
        maskLayer.path = maskPath.CGPath;
        clView.layer.mask = maskLayer;
        [bgview addSubview:clView];
        return bgview;
    } else {
        return NULL;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 && self.userLetterArr.count) {
        return 30;
    } else {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1 && self.userLetterArr.count) {
        UIView *bgview = [[UIView alloc]init];
        UILabel *clView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_W-20, 20)];
        clView.backgroundColor = [UIColor coralColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:clView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = clView.bounds;
        maskLayer.path = maskPath.CGPath;
        clView.layer.mask = maskLayer;
        [bgview addSubview:clView];
        return bgview;
    } else {
        return NULL;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    } else {
        return 15;
    }
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _userLetterArr.count;
    } else {
        return 4;
    }}
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
    _headView.backgroundColor = [UIColor easterPinkColor];
    _mainTableView.backgroundColor = [UIColor easterPinkColor];

//    TDImageColors *imageColors = [[TDImageColors alloc] initWithImage:primaryPic.image count:5];
//    _headView.backgroundColor = imageColors.colors[0];
//    _mainTableView.backgroundColor = imageColors.colors[0];

    
    
//    UIImage *blurImage             = [primaryPic.image blurImageWithRadius:15];
//    _headView.image                = blurImage;

//咨询师头像
    UIImageView *picView = [[UIImageView alloc]init];
    [picView sd_setImageWithURL:[NSURL URLWithString:self.counselModel.HeadImg] placeholderImage:[UIImage imageNamed:@"乐天logo"]];
    picView.layer.cornerRadius = _headView.height*0.2;
    picView.layer.borderWidth = 1;
    picView.layer.borderColor = ([UIColor whiteColor].CGColor);
    picView.layer.masksToBounds = YES;
    [view addSubview:picView];
    [picView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_headView.mas_centerX);
        make.centerY.equalTo(_headView.mas_centerY);
        make.width.equalTo(_headView.mas_height).multipliedBy(0.4);
        make.height.equalTo(_headView.mas_height).multipliedBy(0.4);
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

    NSLog(@"aaaaa:%f",lineHeight);
//咨询师名字
    UILabel *nameLab = [[UILabel alloc]init];
    [view addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(picView.mas_centerX);
        make.top.equalTo(picView.mas_bottom).offset(lineHeight);
//        make.width.equalTo(self.view.mas_width).multipliedBy(0.3);
        make.height.equalTo(picView.mas_height).multipliedBy(0.25);
    }];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = self.counselModel.UserName;
    nameLab.textColor = [UIColor whiteColor];
    nameLab.shadowOffset = CGSizeMake(0, 1);
    nameLab.font = [UIFont systemFontOfSize:17 weight:2];
    [nameLab sizeToFit];
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
    
//    NSLog(@"%f",self.mainTableView.contentOffset.y - self.headView.height + navigationBar_H + statusBar_H);
//    NSLog(@"原：%f",offset.y);
    if (offset.y < 0) {
        
        CGRect rect = self.headView.frame;
        rect.origin.y = offset.y;
        rect.size.height = (SCREEN_H*0.3) - offset.y;
        _headView.frame = rect;
    } else if (offset.y > (self.headView.height - navigationBar_H - statusBar_H)) {
        
//        NSLog(@"aaa");
        [self.view addSubview:self.naviView];
//        self.naviView.image = self.headView.image;
        self.naviView.backgroundColor = [UIColor easterPinkColor];
        self.naviView.height = self.headView.height;
        self.naviView.bottom = navigationBar_H + statusBar_H;
        self.navigationItem.title = self.counselModel.UserName;
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
        
    } else {
//        NSLog(@"ddd");
        [self.naviView removeFromSuperview];
        self.navigationItem.title = nil;

    }
}

#pragma mark 获取感谢信
- (void)getUserLetter {
    
    __weak typeof(self) weakSelf = self;
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendFormat:@"%@",API_NAME_GETUSERLETTER];
    
    NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
    parames[@"doctorID"] = @(self.counselModel.UserID);
    
    [PPNetworkHelper setValue:kFetchToken forHTTPHeaderField:@"token"];
    //    NSLog(@"token:%@",kFetchToken);
    [PPNetworkHelper GET:requestString parameters:parames success:^(id responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
//        NSLog(@"感谢：%@",responseObject);
        strongSelf.userLetterArr = [UserLetterModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
//        if (!strongSelf.userLetterArr.count) {
//            [strongSelf.mainTableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//        }
        [strongSelf.mainTableView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


#pragma mark 定制底部TabBar
- (void)creatBottomBar {
    
    _tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_H - TAB_BAR_HEIGHT, SCREEN_W, tabBar_H)];
    [self.view addSubview:_tabBar];
    //预约按钮
    UIButton *AppointmentBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*2/3, 0, SCREEN_W/3, tabBar_H)];
    AppointmentBtn.backgroundColor = [UIColor colorWithRed:253/255.0 green:216/255.0 blue:126/255.0 alpha:1];
    [AppointmentBtn setTitle:@"预约" forState:UIControlStateNormal];
    [AppointmentBtn addTarget:self action:@selector(clickAppointmentBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:AppointmentBtn];
    //咨询按钮
    UIButton *askBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 3, tabBar_H*2/3, tabBar_H*2/3)];
    [_tabBar addSubview:askBtn];
    [askBtn setImage:[UIImage imageNamed:@"ask"] forState:UIControlStateNormal];
    [askBtn addTarget:self action:@selector(clickAskBrn) forControlEvents:UIControlEventTouchUpInside];
    UILabel *askLab = [[UILabel alloc]initWithFrame:CGRectMake(15, tabBar_H*2/3, tabBar_H, tabBar_H/3)];
    [_tabBar addSubview:askLab];
    askLab.centerX = askBtn.centerX;
    askLab.text                        = @"在线倾诉";
    askLab.textAlignment               = NSTextAlignmentCenter;
    askLab.font                        = [UIFont systemFontOfSize:10];
    askLab.textColor                   = [UIColor darkGrayColor];
    //价格lable
    UILabel *priceLab                  = [[UILabel alloc]init];
    priceLab.adjustsFontSizeToFitWidth = YES;
    [_tabBar addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(AppointmentBtn.mas_left).offset(-SCREEN_W/100);
        make.top.equalTo(_tabBar.mas_top);
        make.width.equalTo(_tabBar.mas_width).multipliedBy(0.3);
        make.height.equalTo(AppointmentBtn.mas_height);
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
        make.bottom.equalTo(priceLab.mas_bottom);
        make.width.equalTo(priceLab.mas_width);
        make.height.equalTo(priceLab.mas_height).multipliedBy(0.5);
    }];
    couponLab.text                     = [NSString stringWithFormat:@"%@",_counselModel.ConsultTag];
    couponLab.textColor                = [UIColor colorWithRed:253/255.0 green:216/255.0 blue:126/255.0 alpha:1];
    couponLab.textAlignment            = NSTextAlignmentRight;
    couponLab.font                     = [UIFont boldSystemFontOfSize:10];
    //EAP通道
    if (self.counselModel.ConsultDisCount == 1) {
        couponLab.hidden = YES;
    }
    

}

- (void)clickAskBrn {
    
    if ([GQUserManager isHaveLogin]) {

        RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
        chatService.hidesBottomBarWhenPushed = YES;
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = RONGYUN_SERVICE_ID;
        chatService.title = @"乐天心理咨询";
        [self.navigationController pushViewController:chatService animated:YES];
    } else {
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
        
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

- (void)clickAppointmentBtn {
    
    if ([GQUserManager isHaveLogin]) {
    
        ConfirmPageVC *confirmPagevc = [[ConfirmPageVC alloc]init];
        confirmPagevc.counselModel   = self.counselModel;
        [self.navigationController pushViewController:confirmPagevc animated:YES];
    } else {

        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
        alertControl.view.tintColor=[UIColor blackColor];
        [self presentViewController:alertControl animated:YES completion:nil];

        __weak typeof(self) weakSelf    = self;
        [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

            __strong typeof(self) strongSelf = weakSelf;
            RegistViewController *loginVc     = [[RegistViewController alloc]init];
            loginVc.hidesBottomBarWhenPushed = YES;
            [strongSelf presentViewController:loginVc animated:YES completion:nil];
        }]];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    }

}

- (UIColor*)mostColor:(UIImage*)image{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(100, 100);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    NSArray *MaxColor=nil;
    // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    float maxScore=0;
    for (int x=0; x<thumbSize.width*thumbSize.height; x++) {
        
        int offset = 4*x;
        int red = data[offset];
        int green = data[offset+1];
        int blue = data[offset+2];
        int alpha =  data[offset+3];
        
        if (alpha<25)continue;
        
        float h,s,v;
        
        RGBtoHSV(red, green, blue, &h, &s, &v);
        
        float y = MIN(abs(red*2104+green*4130+blue*802+4096+131072)>>13, 235);
        y= (y-16)/(235-16);
        if (y>0.9) continue;
        
        float score = (s+0.1)*x;
        if (score>maxScore) {
            maxScore = score;
        }
        MaxColor=@[@(red),@(green),@(blue),@(alpha)];
        
    }
    
    CGContextRelease(context);
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
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
