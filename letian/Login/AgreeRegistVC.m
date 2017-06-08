//
//  AgreeRegistVC.m
//  letian
//
//  Created by 郭茜 on 2017/6/8.
//  Copyright © 2017年 J. All rights reserved.
//

#import "AgreeRegistVC.h"
#import <WebKit/WebKit.h>

@interface AgreeRegistVC ()

@end

@implementation AgreeRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建WKWebView
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 69, SCREEN_W, SCREEN_H - 69)];
    // 设置访问的URL
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"注册协议" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    //    NSURL *url = [NSURL URLWithString:@"http://www.jianshu.com"];
    // 根据URL创建请求
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // WKWebView加载请求
    [webView loadRequest:request];
    // 将WKWebView添加到视图
    [self.view addSubview:webView];
    
    //    [self customNavigation];
    UIButton *btn = [[UIButton alloc]init];
    [self.view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(10, 30, 20, 20)];
    [btn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    UILabel *bar = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 69)];
    [self.view addSubview:bar];
    UIButton *btn = [[UIButton alloc]init];
    [bar addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(10, 20, 20, 20)];
    [btn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickBackBtn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
