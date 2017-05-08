//
//  WebArticleViewController.m
//  letian
//
//  Created by 郭茜 on 2017/3/17.
//  Copyright © 2017年 J. All rights reserved.
//

#import "WebArticleViewController.h"
#import <WebKit/WebKit.h>
#import "WebArticleModel.h"
#import "MJExtension.h"

@interface WebArticleViewController ()

@property(nonatomic,strong)WebArticleModel *articleModel;

@end

@implementation WebArticleViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setUpNavigationBar];

    [self requestData];
}


#pragma mark-------获取文章详情

-(void)requestData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_WEBARTICLE];
    [requestString appendString:API_NAME_GETWEBACTIVEL];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"articleID"]=@(self.articleID);
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"什么情况？文章详情%@",responseObject);
        [MBHudSet dismiss:self.view];
        weakSelf.articleModel=[WebArticleModel mj_objectWithKeyValues:responseObject[@"Result"][@"Source"]];
        NSLog(@"responseObject=%@",responseObject);
        self.navigationItem.title=self.articleModel.Title;
        [self createRichTextView:self.articleModel.Content];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


#pragma mark--------创建富文本

-(void)createRichTextView:(NSString *)textStr
{
    UITextView *textview=[[UITextView alloc]initWithFrame:CGRectMake(20, 64, SCREEN_W-40, SCREEN_H-64)];
    textview.editable=NO;
    textview.showsVerticalScrollIndicator=NO;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.paragraphSpacing = 15;
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithData:[textStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSDictionary *attributes=@{
                               NSFontAttributeName:[UIFont systemFontOfSize:15],
                               NSParagraphStyleAttributeName:paragraphStyle,
                               };
    [str addAttributes:attributes range:NSMakeRange(0, str.length)];
    textview.attributedText=str;
    [self.view addSubview:textview];
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
