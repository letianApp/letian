//
//  ZhiChiViewController.m
//  letian
//
//  Created by J on 2019/1/8.
//  Copyright © 2019 J. All rights reserved.
//

#import "ZhiChiViewController.h"
#import <WebKit/WebKit.h>


@interface ZhiChiViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation ZhiChiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.sobot.com/chat/h5/index.html?sysNum=05119bce202340a5935f61aaf94d9542&source=2"]]];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {
    
    UIButton *btn = [[UIButton alloc]init];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 20, 20)];
    backView.image = [UIImage imageNamed:@"pinkback"];
    [btn addSubview:backView];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
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
