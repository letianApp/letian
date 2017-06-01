//
//  TestHistoryViewController.m
//  letian
//
//  Created by 郭茜 on 2017/5/25.
//  Copyright © 2017年 J. All rights reserved.
//

#import "TestHistoryViewController.h"
#import <WebKit/WebKit.h>

@interface TestHistoryViewController ()<WKNavigationDelegate,WKUIDelegate>

@end

@implementation TestHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self createWebView];
}


-(void)createWebView
{
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://admin.rightpsy.com/PsychTest/PsychTestHistoryIndex?userid=%@",kFetchUserId]]];
    NSLog(@"token:%@",kFetchToken);
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64 )];
    webView.allowsBackForwardNavigationGestures=YES;
    [webView loadRequest:request];
    webView.navigationDelegate=self;
    webView.UIDelegate = self;
    webView.scrollView.showsVerticalScrollIndicator=NO;
    webView.scrollView.bounces = NO;//禁止下拉
    [self.view addSubview:webView];
}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"目前网页%@",webView.URL.absoluteString);
    if ([webView.URL.absoluteString rangeOfString:@"report/normal/reportviewrdlc.aspx"].location    !=NSNotFound) {

        [webView evaluateJavaScript:@"document.getElementsByTagName('div')[2].style.display = 'none';" completionHandler:nil];
        
        [webView evaluateJavaScript:@"document.getElementsByTagName('tbody')[0].style.zoom = '1.4';" completionHandler:nil];
        

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
