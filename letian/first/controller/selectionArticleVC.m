//
//  selectionArticleVC.m
//  letian
//
//  Created by J on 2018/6/21.
//  Copyright © 2018年 J. All rights reserved.
//

#import "selectionArticleVC.h"
#import <WebKit/WebKit.h>
#import "CommitVC.h"

#import "GQUserManager.h"
#import "GQActionSheet.h"
#import <UShareUI/UShareUI.h>

@interface selectionArticleVC ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *comBtn;
@property (nonatomic,strong) UILabel *comLab;
@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UILabel *likeLab;
@property (nonatomic,strong) UIImpactFeedbackGenerator *feedBackGenertor;

@end

@implementation selectionArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNav];
    [self requestData];
    
    _feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.ArticleUrl]]];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    [MBHudSet showStatusOnView:self.view];
    
}

- (void)customNav {
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"pinkshare"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _comBtn = [[UIButton alloc]init];
    [_comBtn setImage:[UIImage imageNamed:@"pinkComment"] forState:UIControlStateNormal];
    [_comBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [_comBtn addTarget:self action:@selector(clickComBtn) forControlEvents:UIControlEventTouchUpInside];
    _comLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 20, 10)];
    _comLab.font = [UIFont systemFontOfSize:10];
    _comLab.textColor = MAINCOLOR;
    
    _likeBtn = [[UIButton alloc]init];
    [_likeBtn setImage:[UIImage imageNamed:@"pinkLike"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"pinkLikeSel"] forState:UIControlStateSelected];
    [_likeBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [_likeBtn addTarget:self action:@selector(clickLikeBtn) forControlEvents:UIControlEventTouchUpInside];
    _likeLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 20, 10)];
    _likeLab.font = [UIFont systemFontOfSize:10];
    _likeLab.textColor = MAINCOLOR;
    
    if (@available(iOS 11.0, *)){
        
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
        UIView *shareVew = [[UIView alloc] initWithFrame:btn.bounds];
        [shareVew addSubview:btn];
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareVew];
        
        UIView *commitView = [[UIView alloc]initWithFrame:_comBtn.bounds];
        [commitView addSubview:_comBtn];
        [commitView addSubview:_comLab];
        UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithCustomView:commitView];
        
        UIView *likeView = [[UIView alloc]initWithFrame:_likeBtn.bounds];
        [likeView addSubview:_likeBtn];
        [likeView addSubview:_likeLab];
        UIBarButtonItem *likeItem = [[UIBarButtonItem alloc] initWithCustomView:likeView];
        
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 40;
        
        self.navigationItem.rightBarButtonItems = @[shareItem,spaceItem,commitItem,spaceItem,likeItem];

    }
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

- (void)clickComBtn {
    
//    [MBHudSet showText:@"评论" andOnView:self.view];
    CommitVC *commitVC = [[CommitVC alloc]init];
    commitVC.ID = self.ID;
    [self.navigationController pushViewController:commitVC animated:YES];

}

- (void)clickLikeBtn {
    
    [_feedBackGenertor impactOccurred];
    
    if (_likeBtn.isSelected == YES) {
        _likeBtn.selected = NO;
    } else {
        _likeBtn.selected = YES;
    }
    [self doArticlePraise];
}

- (void)requestData {
    
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_ARTICLE];
    [requestString appendString:API_NAME_GETARTICLEINFO];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"articleID"]=@(self.ID);
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"详细：%@",[NSString stringWithFormat:@"%@",responseObject[@"Result"][@"Source"]]);
        __strong typeof(self) strongSelf = weakSelf;
        if (![[NSString stringWithFormat:@"%@",responseObject[@"Result"][@"Source"][@"PraiseCount"]] isEqualToString:@"0"]) {
            strongSelf.likeLab.text = [NSString stringWithFormat:@"%@",responseObject[@"Result"][@"Source"][@"PraiseCount"]];
        } else {
            strongSelf.likeLab.text = @"";
        }
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"Result"][@"Source"][@"IsCurUserPraise"]] isEqualToString:@"1"]) {
            strongSelf.likeBtn.selected = YES;
        } else {
            strongSelf.likeBtn.selected = NO;
        }
        if (![[NSString stringWithFormat:@"%@",responseObject[@"Result"][@"Source"][@"CommentCount"]] isEqualToString:@"0"]) {
            strongSelf.comLab.text = [NSString stringWithFormat:@"%@",responseObject[@"Result"][@"Source"][@"CommentCount"]];
        }
        strongSelf.CreatedByString = responseObject[@"Result"][@"Source"][@"CreatedByString"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}

- (void)doArticlePraise {
    
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_ARTICLE];
    [requestString appendString:API_NAME_DOARTICLEPRAISE];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"articleID"]=@(self.ID);
    params[@"praiseType"]=@(1);
    if ([_likeBtn isSelected]) {
        params[@"IsPraise"]=@"true";
    } else {
        params[@"IsPraise"]=@"false";
    }
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"赞赞：%@",responseObject);
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf requestData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
}


#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSString *navbarJs = @"document.getElementsByClassName('navbar navbar-static-top bs-docs-nav container')[0].style.display = 'NONE'";//获取整个页面的HTMLstring
    [webView evaluateJavaScript:navbarJs completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
//        NSLog(@"这一页：%@",HTMLsource);
    }];
    
    NSString *breadcrumbJs = @"document.getElementsByClassName('breadcrumb')[0].style.display = 'NONE'";
    [webView evaluateJavaScript:breadcrumbJs completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
    }];
    
    NSString *textrightJs = @"document.getElementsByClassName('text-right')[0].style.display = 'NONE'";
    [webView evaluateJavaScript:textrightJs completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
    }];
    
    NSString *sendcommentsJs = @"document.getElementsByClassName('send-comments')[0].style.display = 'NONE'";
    [webView evaluateJavaScript:sendcommentsJs completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
    }];

    NSString *historycommentsJs = @"document.getElementsByClassName('history-comments')[0].style.display = 'NONE'";
    [webView evaluateJavaScript:historycommentsJs completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
    }];
    
//    NSString *zhichiBtncommentsJs = @"document.getElementsByIdName('zhichiBtnBox').style.display = 'NONE'";
//    [webView evaluateJavaScript:zhichiBtncommentsJs completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
//    }];

    NSString *colJs = @"document.getElementsByClassName('col-xs-5')[0].style.display = 'NONE'";
    [webView evaluateJavaScript:colJs completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
        
        [self.bgView removeFromSuperview];
        [MBHudSet dismiss:self.view];

    }];
    
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
//    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
//    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    NSLog(@"%@",message);
    completionHandler();
}

- (void)clickShareBtn {
    NSArray *titles = @[@"分享到朋友圈",@"分享到微信",@"分享到微博",@"分享到空间",@"分享到短信",@"分享到QQ"];
    NSArray *imageNames = @[@"pengyou",@"weixin",@"weibo",@"kongjian",@"mess",@"qq"];
    GQActionSheet *sheet = [[GQActionSheet alloc] initWithTitles:titles iconNames:imageNames];
    [sheet showActionSheetWithClickBlock:^(int btnIndex) {
        //        NSLog(@"btnIndex:%d",btnIndex);
        NSInteger platformType;
        if (btnIndex==0) {
            platformType=ShareTo_WechatTimeLine;
        }else if (btnIndex==1){
            platformType=ShareTo_WechatSession;
        }else if (btnIndex==2){
            platformType=ShareTo_Sina;
        }else if (btnIndex==3){
            platformType=ShareTo_Qzone;
        }else if (btnIndex==4){
            platformType=ShareTo_Sms;
        }else {
            platformType=ShareTo_QQ;
        }
        [self shareWebPageToPlatformType:platformType];
    } cancelBlock:nil];
}

#pragma mark - 分享

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.ArticleTitle descr:self.CreatedByString thumImage:self.ArticleImg];
    shareObject.webpageUrl = self.ArticleUrl;
    messageObject.shareObject = shareObject;

    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBHudSet showText:@"分享失败" andOnView:self.view];
        }else{
            [MBHudSet showText:@"分享成功" andOnView:self.view];
        }
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
