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

    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://mp.weixin.qq.com/mp/homepage?__biz=MzA3NjA4ODcxMQ==&hid=2&sn=2961ee681490a42a9e103ebd04126296#wechat_redirect"]];

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H )];

    webView.allowsBackForwardNavigationGestures=YES;
    
    [webView loadRequest:request];
    
    webView.scrollView.showsVerticalScrollIndicator=NO;

    webView.navigationDelegate=self;
    
    webView.UIDelegate = self;

    
    self.webView=webView;
    
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
