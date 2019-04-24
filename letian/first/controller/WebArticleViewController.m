//
//  WebArticleViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/17.
//  Copyright © 2017年 J. All rights reserved.
//

#import "WebArticleViewController.h"
#import <WebKit/WebKit.h>
#import "WebArticleModel.h"
#import "MJExtension.h"
#import <UShareUI/UShareUI.h>
#import "GQActionSheet.h"

@interface WebArticleViewController ()<UITextViewDelegate>

@property(nonatomic,strong)WebArticleModel *articleModel;
@property(nonatomic,strong)UITextView *textView;


@end

@implementation WebArticleViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpNavigationBar];

    [self requestData];
}


#pragma mark-------获取文章详情

-(void)requestData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_WEBARTICLE];
    [requestString appendString:API_NAME_GETWEBACTIVEL];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"articleID"]=@(self.articleID);
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"文章详情:%@",responseObject);
        [MBHudSet dismiss:self.view];
        weakSelf.articleModel = [WebArticleModel mj_objectWithKeyValues:responseObject[@"Result"][@"Source"]];
//        NSLog(@"responseObject=%@",responseObject);
        [self createRichTextView:self.articleModel.Content];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


#pragma mark--------创建富文本

-(void)createRichTextView:(NSString *)textStr
{
    
    UITextView *textview=[[UITextView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64)];
    textview.editable=NO;
    textview.delegate=self;
    textview.showsVerticalScrollIndicator=NO;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.paragraphSpacing = 15;
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithData:[textStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSDictionary *attributes=@{
                               NSFontAttributeName:[UIFont systemFontOfSize:15],
                               NSParagraphStyleAttributeName:paragraphStyle,
                               };
    [str addAttributes:attributes range:NSMakeRange(0, str.length)];
    textview.attributedText=str;
    
    UILabel *titleLabel=[GQControls createLabelWithFrame:CGRectZero andText:self.articleModel.Title andTextColor:[UIColor blackColor] andFontSize:20];
    titleLabel.font=[UIFont boldSystemFontOfSize:20];
    titleLabel.numberOfLines=0;
    CGSize expectSize = [titleLabel sizeThatFits:CGSizeMake(SCREEN_W-30, 999)];
    titleLabel.frame = CGRectMake(15, 20, expectSize.width, expectSize.height);

    [textview addSubview:titleLabel];
    
    UILabel *authorLabel=[GQControls createLabelWithFrame:CGRectMake(30, titleLabel.height+35, SCREEN_W-60, 15) andText:[NSString stringWithFormat:@"作者：%@",self.articleModel.CreatedBy] andTextColor:[UIColor darkGrayColor] andFontSize:12];
    authorLabel.textAlignment=NSTextAlignmentRight;
    [textview addSubview:authorLabel];
    
    textview.textContainerInset = UIEdgeInsetsMake(titleLabel.height+45+authorLabel.height, 15, 0, 15);
    [self.view addSubview:textview];
    
    self.textView=textview;
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

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.articleModel.Title descr:self.articleModel.Abstract thumImage:[UIImage imageNamed:@"乐天logo"]];
    shareObject.webpageUrl = self.articleModel.OriginalUrl;
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBHudSet showText:@"分享失败" andOnView:self.view];
        }else{
            [MBHudSet showText:@"分享成功" andOnView:self.view];
        }
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setNeedsStatusBarAppearanceUpdate];
    if (self.textView.contentOffset.y >= 20) {
        
        self.navigationItem.title = self.articleModel.Title;
    }else{
        self.navigationItem.title = @"文章";
    }
}

-(void) setUpNavigationBar {
    
    self.navigationItem.title=@"文章";
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"pinkshare"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    shareButton.frame=CGRectMake(0, 0, 20, 20);
    
    UIView *shareVew = [[UIView alloc] initWithFrame:shareButton.bounds];
    [shareVew addSubview:shareButton];
//    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareVew];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareVew];
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
