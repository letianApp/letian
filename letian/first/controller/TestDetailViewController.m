//
//  TestDetailViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/22.
//  Copyright © 2017年 J. All rights reserved.
//

#import "TestDetailViewController.h"
#import <WebKit/WebKit.h>
#import "GQActionSheet.h"
#import <UShareUI/UShareUI.h>

@interface TestDetailViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation TestDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    [self createWebView];
   
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


#pragma mark---------分享网页

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"心理测试：%@",self.testModel.title] descr:self.testModel.content thumImage:[UIImage imageNamed:@"乐天logo"]];
    shareObject.webpageUrl =self.testUrl;
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBHudSet showText:@"分享失败" andOnView:self.view];
        }else{
            [MBHudSet showText:@"分享成功" andOnView:self.view];
        }
    }];
}


#pragma mark---------创建webView

-(void)createWebView
{
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.testUrl]];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, -45, SCREEN_W, SCREEN_H+45 )];
    webView.allowsBackForwardNavigationGestures=YES;
    [webView loadRequest:request];
    webView.navigationDelegate=self;
    webView.UIDelegate = self;
    webView.scrollView.showsVerticalScrollIndicator=NO;
    webView.scrollView.bounces = NO;//禁止下拉
    [self.view addSubview:webView];
    webView.hidden=YES;
    self.webView=webView;
    [MBHudSet showStatusOnView:self.view];
}


#pragma mark---------嵌入JS代码

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    NSLog(@"当前网页%@",webView.URL.absoluteString);
//    隐藏下载广告
    [webView evaluateJavaScript:@"document.getElementsByClassName('advertiseBar')[0].style.display = 'none'; " completionHandler:nil];
    
//    隐藏头部导航栏
    [webView evaluateJavaScript:@"document.getElementsByClassName('header')[0].style.display = 'none';" completionHandler:nil];
//    隐藏分享
    [webView evaluateJavaScript:@"document.getElementsById('nativeShare').style.display = 'none';" completionHandler:nil];
    [webView evaluateJavaScript:@"document.getElementsByClassName('grzy')[0].style.display = 'none';" completionHandler:nil];

//    隐藏底部下一页
    [webView evaluateJavaScript:@"document.getElementsByClassName('po_footer')[0].style.display = 'none';" completionHandler:nil];
    
    [webView evaluateJavaScript:@"document.getElementsByClassName('mediaTitle')[0].style.display = 'none'; ;" completionHandler:nil];
//    隐藏付费推荐
    [webView evaluateJavaScript:@"document.getElementsByClassName('recomend-payTest')[0].style.display = 'none';" completionHandler:nil];
//    隐藏大家都爱的专业测评
    [webView evaluateJavaScript:@"document.getElementsByClassName('test-jumpBtn')[0].style.display = 'none' ;" completionHandler:nil];
    [webView evaluateJavaScript:@"document.getElementsByClassName('mediaList')[1].style.display = 'none';" completionHandler:nil];
//    隐藏底部广告
    [webView evaluateJavaScript:@"document.getElementsById('TencentAdContainer').style.display = 'none';" completionHandler:nil];
//    隐藏头部广告
    [webView evaluateJavaScript:@"document.getElementsById('datacross').style.display = 'none';" completionHandler:nil];
    
    if (![self.webView.URL.absoluteString isEqualToString:self.testUrl]) {
        self.webView.hidden=YES;
        [webView evaluateJavaScript:@"document.getElementsByClassName('test-result')[0].getElementsByTagName('div')[1].style.display='none';" completionHandler:nil];
        
        
        
        [webView evaluateJavaScript:@"var parent = document.getElementsByClassName('test-result')[0].getElementsByTagName('div')[2];var child = parent.lastChild ;parent.removeChild(child)" completionHandler:nil];
    }
    [MBHudSet dismiss:self.view];
    [self performSelector:@selector(webViewHidden) withObject:nil afterDelay:0.3f];    
}


-(void)webViewHidden{
    self.webView.hidden=NO;
}


-(void) setUpNavigationBar
{
    self.navigationItem.title=@"心理测试";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame=CGRectMake(30, 12, 20, 20);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"pinkshare"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    shareButton.frame=CGRectMake(30, 12, 20, 20);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationController.navigationBar.translucent = NO;
}
-(void) back
{
    [self.navigationController popViewControllerAnimated:YES];
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
