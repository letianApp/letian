//
//  TestDetailViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/22.
//  Copyright © 2017年 J. All rights reserved.
//

#import "TestDetailViewController.h"
#import <WebKit/WebKit.h>

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
    
    
    //设置navigationBar不透明
    self.navigationController.navigationBar.translucent = NO;
    
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
    
    self.webView=webView;
    
    
}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    [webView evaluateJavaScript:@"document.getElementsByClassName('mediaList')[0].style.display = 'none';                   document.getElementsByClassName('card')[0].style.display = 'none';  document.getElementsByClassName('po_footer')[0].style.display = 'none'; document.getElementsByClassName('mediaTitle')[0].style.display = 'none'; document.getElementsByClassName('recomend-payTest')[0].style.display = 'none';   document.getElementsByClassName('test-jumpBtn')[0].style.display = 'none' ;   document.getElementsByClassName('kuang')[0].style.display = 'none' ;" completionHandler:^(id evaluate, NSError * error) {
        
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
