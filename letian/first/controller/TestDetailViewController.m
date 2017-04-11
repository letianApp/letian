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
    
    //设置navigationBar不透明
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void)shareButtonClick{
    
    
    //        分享
    NSArray *titles = @[@"分享到朋友圈",@"分享到微信",@"分享到微博",@"分享到空间",@"分享到短信",@"分享到QQ"];
    NSArray *imageNames = @[@"pengyou",@"weixin",@"weibo",@"kongjian",@"mess",@"qq"];
    GQActionSheet *sheet = [[GQActionSheet alloc] initWithTitles:titles iconNames:imageNames];
    [sheet showActionSheetWithClickBlock:^(int btnIndex) {
        NSLog(@"btnIndex:%d",btnIndex);
        NSInteger platformType;
        if (btnIndex==0) {
            platformType=2;
        }else if (btnIndex==1){
            platformType=1;
        }else if (btnIndex==2){
            platformType=0;
        }else if (btnIndex==3){
            platformType=5;
        }else if (btnIndex==4){
            platformType=13;
        }else {
            platformType=4;
        }
        
        [self shareWebPageToPlatformType:platformType];
        
    } cancelBlock:^{
        NSLog(@"取消");
    }];
    
    

    
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"心理测试：%@",self.testModel.title] descr:self.testModel.content thumImage:[UIImage imageNamed:@"乐天logo"]];
    //设置网页地址
    shareObject.webpageUrl =self.testUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}


-(void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

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


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    [webView evaluateJavaScript:@"document.getElementsByClassName('mediaList')[0].style.display = 'none';                   document.getElementsByClassName('card')[0].style.display = 'none';      document.getElementsByClassName('po_footer')[0].style.display = 'none'; document.getElementsByClassName('mediaTitle')[0].style.display = 'none'; document.getElementsByClassName('recomend-payTest')[0].style.display = 'none';   document.getElementsByClassName('test-jumpBtn')[0].style.display = 'none' ;   document.getElementsByClassName('kuang')[0].style.display = 'none' ;             document.getElementsByClassName('mediaList')[1].style.display = 'none';    document.getElementsByClassName('grzy')[0].style.display = 'none';         " completionHandler:^(id evaluate, NSError * error) {
        
    }];
    
    [MBHudSet dismiss:self.view];
    
    [self performSelector:@selector(webViewHidden) withObject:nil afterDelay:0.3f];

    
}


-(void)webViewHidden{
    self.webView.hidden=NO;
    NSLog(@"ee ");
    
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSString *currentURL = webView.URL.absoluteString;
    NSLog(@"当前url%@",currentURL);

    NSLog(@"第一个url%@",self.testUrl);

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
