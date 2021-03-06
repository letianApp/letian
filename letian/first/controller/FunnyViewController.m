//
//  FunnyViewController.m
//  letian
//
//  Created by 郭茜 on 2017/6/5.
//  Copyright © 2017年 J. All rights reserved.
//

#import "FunnyViewController.h"
#import <UShareUI/UShareUI.h>
#import "GQActionSheet.h"
#import "UIImageView+WebCache.h"

@interface FunnyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *detailLabel;

@end

@implementation FunnyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setUpNavigationBar];
    [self creatTableView];
}
-(void)creatTableView
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *bgView=[GQControls createViewWithFrame:CGRectMake(0, 0, SCREEN_W, 100) andBackgroundColor:[UIColor whiteColor]];
    
    UILabel *headLabel=[GQControls createLabelWithFrame:CGRectMake(20, 20, SCREEN_W-40, 50) andText:self.activeModel.ArticleName andTextColor:[UIColor blackColor] andFontSize:20];
    headLabel.numberOfLines=0;
    headLabel.font=[UIFont boldSystemFontOfSize:20];
    [bgView addSubview:headLabel];
    
    UILabel *creatTimeLabel=[GQControls createLabelWithFrame:CGRectMake(20, 70, SCREEN_W-40, 20) andText:self.activeModel.CreatedDate andTextColor:[UIColor darkGrayColor] andFontSize:12];
    creatTimeLabel.textAlignment=NSTextAlignmentRight;
    [bgView addSubview:creatTimeLabel];
    
    self.tableView.tableHeaderView=bgView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return SCREEN_W*0.6;
    }
    return self.detailLabel.height+40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        UIImageView *mainImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0,SCREEN_W-20 , SCREEN_W*0.6)];
        [mainImageView sd_setImageWithURL:[NSURL URLWithString:self.activeModel.ArticleImg] placeholderImage:[UIImage imageNamed:@"mine_bg"]];
        [cell.contentView addSubview:mainImageView];
        return cell;
    }

    self.detailLabel=[GQControls createLabelWithFrame:CGRectMake(20, 30, SCREEN_W-40, 50) andText:self.activeModel.Description andTextColor:[UIColor darkGrayColor] andFontSize:20];
    self.detailLabel.numberOfLines=0;
    [self.detailLabel sizeToFit];
    [cell.contentView addSubview:self.detailLabel];
    
    return cell;

}

-(void) setUpNavigationBar
{
//    self.navigationItem.title=@"详情";
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    backButton.frame=CGRectMake(30, 12, 20, 20);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [shareButton setImage:[UIImage imageNamed:@"pinkshare"] forState:UIControlStateNormal];
//    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    shareButton.frame=CGRectMake(30, 12, 20, 20);
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    self.navigationController.navigationBar.prefersLargeTitles = true;
//    self.navigationItem.backBarButtonItem = 

    
}
-(void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---------弹出分享面板

-(void)shareButtonClick{
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

#pragma mark---------分享截图

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:[GQControls captureScrollView:self.tableView]];
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBHudSet showText:@"分享失败" andOnView:self.view];
        }else{
            [MBHudSet showText:@"分享成功" andOnView:self.view];
        }
    }];
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
