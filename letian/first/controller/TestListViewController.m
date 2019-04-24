//
//  TestListViewController.m
//  letian
//
//  Created by 郭茜 on 2017/5/25.
//  Copyright © 2017年 J. All rights reserved.
//

#import "TestListViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
@interface TestListViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) WKWebView *webView;

@property(nonatomic,copy)NSString *testStr;
@end

@implementation TestListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.testStr=[NSString stringWithFormat:@"http://admin.rightpsy.com/PsychTest/MeasureIndex?userid=%@",kFetchUserId];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self createWebView];
}

- (void)createWebView {

    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.testStr]];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64 ) ];
    webView.allowsBackForwardNavigationGestures=YES;
    [webView loadRequest:request];
    webView.navigationDelegate=self;
    webView.UIDelegate = self;
    webView.hidden=YES;
    webView.scrollView.showsVerticalScrollIndicator=NO;
    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    self.webView=webView;
    [MBHudSet showStatusOnView:self.view];
}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //判断网页是否是测评结果
    if ([webView.URL.absoluteString rangeOfString:@"report/normal/reportviewrdlc.aspx"].location ==NSNotFound) {
        
        [webView evaluateJavaScript: @"var meta = document.createElement('meta'); \
         meta.name = 'viewport'; \
         meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
         var head = document.getElementsByTagName('head')[0];\
         var style=document.createElement('style');\
         style.type='text/css';\
         style.innerHTML='.testtable tr td table tr td {vertical-align:middle;} .testtable td {font-size:12pt} .pageNav {font-size:12pt;}';\
         head.appendChild(meta);\
         head.appendChild(style)" completionHandler:nil];
        
    }else{
        [webView evaluateJavaScript:@"document.getElementsByTagName('div')[2].style.display = 'none';" completionHandler:nil];
        
        [webView evaluateJavaScript:@"document.getElementsByTagName('tbody')[0].style.zoom = '1.4';" completionHandler:nil];
    }
    NSLog(@",,,%@",webView.URL.absoluteString);
    
    [MBHudSet dismiss:self.view];
    [self performSelector:@selector(webViewHidden) withObject:nil afterDelay:0.3f];
    
}



-(void)webViewHidden{
    self.webView.hidden=NO;
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
