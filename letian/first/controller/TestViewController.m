//
//  TestViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import "TestViewController.h"
#import <WebKit/WebKit.h>

@interface TestViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation TestViewController


-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden=NO;
    
}

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
    
    
    //设置navigationBar不透明
    self.navigationController.navigationBar.translucent = NO;

}



-(void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createWebView
{
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://m.yidianling.com/test/jiankang/"]];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, -84, SCREEN_W, SCREEN_H )];
    
    webView.allowsBackForwardNavigationGestures=YES;
    
    [webView loadRequest:request];
    
    webView.navigationDelegate=self;
    
    webView.UIDelegate = self;
    
    webView.scrollView.showsVerticalScrollIndicator=NO;
    

    
    [self.view addSubview:webView];
    
    self.webView=webView;

    
}

//-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    [webView evaluateJavaScript:@"document.getElementById(\"content\").offsetHeight;"completionHandler:^(id_Nullableresult,NSError *_Nullable error) {
//        //获取页面高度，并重置webview的frame
//        CGFloat documentHeight = [result doubleValue];
//        CGRect frame = webView.frame;
//        frame.size.height = documentHeight;
//        webView.frame = frame;
//    }];
//}

// 类似 UIWebView的 -webView: shouldStartLoadWithRequest: navigationType:
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler {

//    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSLog(@"fffffff");
//    if([strRequest isEqualToString:@"http://www.weiceyan.com/"]) {//主页面加载内容
//        decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
//    } else {//截获页面里面的链接点击
//        //do something you want
//        decisionHandler(WKNavigationActionPolicyCancel);//不允许跳转
//    }
//}


//-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    [webView evaluateJavaScript:@"document.getElementsByTagName('header')[0].hidden = true;document.getElementsByClassName('img_ad')[0].hidden = true;document.getElementsByClassName('m-comment ui-list')[0].hidden = true;document.getElementsByClassName('m-down m-down-tie')[0].hidden = true;document.getElementsByClassName('m-video-recommond')[0].hidden = true;document.getElementsByClassName('m-hotnews js-hotnews-1')[0].hidden = true;document.getElementsByClassName('m-hotnews js-hotnews-2')[0].hidden = true;document.getElementsByClassName('m-vedios js-vedios')[0].hidden = true;document.getElementsByClassName('m-bottom-banner')[0].hidden = true;document.getElementById('instant-news').hidden = true;" completionHandler:^(id evaluate, NSError * error) {
//     
//     }];
//    //redirect是跳转页面的地址中的一个关键字。进入网页以后，加载完毕以后会跳转到另外一个页面，所以我们等它跳转到加载完毕哪个页面，webView.URL的路径中包含了redirect以后，再显示网页。
//    if ([webView.URL.absoluteString rangeOfString:@"redirect"].location != NSNotFound) {
//        self.webView.hidden = NO;
////        [LCLoadingHUD hideInView:self.view];
//    }
//}

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
