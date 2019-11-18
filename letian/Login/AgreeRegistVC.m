//
//  AgreeRegistVC.m
//  letian
//
//  Created by 郭茜 on 2017/6/8.
//  Copyright © 2017年 J. All rights reserved.
//

#import "AgreeRegistVC.h"
#import <WebKit/WebKit.h>

@interface AgreeRegistVC ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation AgreeRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建WKWebView
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_W, SCREEN_H - NAVIGATION_BAR_HEIGHT)];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    NSURL *url = [NSURL URLWithString:@"https://www.rightpsy.com/app/yinsi"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    [self customNavigation];
    _webView.hidden = YES;
    [MBHudSet showStatusOnView:self.view];
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, NAVIGATION_BAR_HEIGHT)];
    [self.view addSubview:bar];
    UIButton *btn = [[UIButton alloc]init];
    [bar addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(10, NAVIGATION_BAR_HEIGHT - 30, 20, 20)];
    [btn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickBackBtn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.getElementsByTagName('header')[0].hidden = true;document.getElementsByClassName('breadcrumb')[0].hidden = true;document.getElementsByClassName('right-side-bar new-right-side-bar')[0].hidden = true;"
      completionHandler:^(id evaluate, NSError * error) {
          _webView.hidden = NO;
          [MBHudSet dismiss:self.view];
     }];
}


- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {
    
    UIButton *btn         = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
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
