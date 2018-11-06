//
//  CategoryViewController.m
//  letian
//
//  Created by 郭茜 on 2017/5/1.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CategoryViewController.h"
#import "ArticleListViewController.h"
#import "GQSegmentButton.h"
#import "WebArticleModel.h"
#import "WebArticleCateModel.h"
#import "WebArticleCell.h"
#import "WebArticleViewController.h"

@interface CategoryViewController ()<GQSegmentDelegate>

@property(nonatomic,strong)GQSegmentButton *segment;
@property (nonatomic,strong) NSMutableArray <WebArticleCateModel *> *articleCateList;

@end

@implementation CategoryViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self requestCategory];

}

#pragma mark-------获取文章类别

-(void)requestCategory{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_WEBARTICLE];
    [requestString appendString:API_NAME_GETWEBARCTIVECATE];
    __weak typeof(self) weakSelf = self;
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
//        NSLog(@"获取网站文章类别%@",responseObject);
        weakSelf.articleCateList=[WebArticleCateModel mj_objectArrayWithKeyValuesArray:responseObject[@"Result"][@"Source"]];
        [self createSegment];
//        NSLog(@"%@",weakSelf.articleCateList);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
    }];
}

#pragma mark-------创建滚动视图

-(void)createSegment{
    NSMutableArray *viewControllers = [NSMutableArray new];
    if (self.adjustScreen) {
        [self.articleCateList removeObjectsInRange:NSMakeRange(3, self.articleCateList.count-3)];
    }
    for (int i = 0 ; i<self.articleCateList.count; i++) {
        ArticleListViewController *vc = [ArticleListViewController new];
        vc.cateID=self.articleCateList[i].CateID;
        vc.title = self.articleCateList[i].CateName;
        [viewControllers addObject:vc];
    }
    self.segment = [[GQSegmentButton alloc] initWithFrame:CGRectMake(0, statusBar_H + navigationBar_H, SCREEN_W, SCREEN_H - 64)];
    self.segment.delegate = self;
    self.segment.btnSelectedColor = MAINCOLOR;
    self.segment.btnNormalColor = [UIColor blackColor];
    self.segment.topScrollView.backgroundColor=WEAKPINK;
    self.segment.viewControllers = viewControllers;
    self.segment.adjustBtnSize2Screen = self.adjustScreen;
    [self.view addSubview:self.segment];
}
#pragma mark-------选中某个分类
-(void)slideSwitchDidselectTab:(NSUInteger)index
{
    ArticleListViewController * vc = self.segment.viewControllers[index];
    [vc viewWillAppear:YES];
}

-(void) setUpNavigationBar
{
    self.navigationItem.title=@"心理健康专栏";

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
