//
//  ArticleViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/17.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ArticleViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"

@interface ArticleViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) WKWebView *webView;


@end

@implementation ArticleViewController


-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden=NO;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setUpNavigationBar];
    
    [self createWebView];
    
}

-(void) setUpNavigationBar
{
    
    self.navigationItem.title=@"文章";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    backButton.frame=CGRectMake(30, 12, 20, 20);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}


-(void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createWebView
{

    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.wzright.com/psychological-counseling/3264.html"]];

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H )];

    webView.allowsBackForwardNavigationGestures=YES;
    
    [webView loadRequest:request];
    
    webView.scrollView.showsVerticalScrollIndicator=NO;

    webView.navigationDelegate=self;
    
    webView.UIDelegate = self;

    webView.hidden=YES;
    
    self.webView=webView;
    
    [self.view addSubview:webView];
    
    [MBHudSet showStatusOnView:self.view];

}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    //嵌入js代码
    [webView evaluateJavaScript:@"document.getElementsByClassName('nav-top')[0].style.display = 'none';                                                      document.getElementsByClassName('share-box')[0].style.display = 'none';    document.getElementsByClassName('entry')[0].style.display = 'none';         document.getElementsByClassName('current-info')[0].style.display = 'none';      document.getElementsByClassName('tab-fixed')[0].style.display = 'none';     document.getElementsByClassName('gclear')[0].style.display = 'none';            document.getElementsByClassName('nav-unlogin')[0].style.display = 'none';  document.getElementsByClassName('gotop-btn')[0].style.display = 'none';  document.getElementsByClassName('content-block')[0].style.display = 'none';                                         var navbar = document.getElementsByClassName('wap-navbar');for(var i in navbar){navbar[i].style.display = 'none'};         "    completionHandler:^(id evaluate, NSError * error) {
        
    }];
    
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
