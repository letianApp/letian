//
//  TestListViewController.m
//  letian
//
//  Created by 郭茜 on 2017/5/25.
//  Copyright © 2017年 J. All rights reserved.
//

#import "TestListViewController.h"
#import <WebKit/WebKit.h>

@interface TestListViewController ()<WKNavigationDelegate,WKUIDelegate>

@end

@implementation TestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self createWebView];
}


-(void)createWebView
{
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://admin.rightpsy.com/PsychTest/MeasureIndex?userid=%@",kFetchUserId]]];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64 )];
    webView.allowsBackForwardNavigationGestures=YES;
    [webView loadRequest:request];
    webView.navigationDelegate=self;
    webView.UIDelegate = self;
    webView.scrollView.showsVerticalScrollIndicator=NO;
    webView.scrollView.bounces = NO;//禁止下拉
    [self.view addSubview:webView];
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
