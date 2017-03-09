//
//  CounselorInfoMainVC.m
//  letian
//
//  Created by J on 2017/3/8.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CounselorInfoMainVC.h"
#import "OrderPageTbC.h"
#import "ConfirmPageTbC.h"

#import "Masonry.h"

@interface CounselorInfoMainVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIScrollView *backScroview;
@property (nonatomic, strong) UIScrollView *mainScroview;

@property (nonatomic, strong) UITabBar *tabBar;


@end

@implementation CounselorInfoMainVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.view.backgroundColor = MAINCOLOR;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _backScroview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    _backScroview.backgroundColor = MAINCOLOR;
    _backScroview.delegate = self;
    [self.view addSubview:_backScroview];
    
    [self customNavigation];
    [self creatBottomBar];
    [self customHeadView];
    [self customMainScroview];
    
    
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"whiteback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (void)clickShareBtn {
    NSLog(@"分享");
}

#pragma mark 头部视图
- (void)customHeadView {
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H/3-10)];
    _headView.backgroundColor = MAINCOLOR;
    [_backScroview addSubview:_headView];
    //咨询师头像
    UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W*2/5, statusBar_H+navigationBar_H, SCREEN_W/5, SCREEN_W/5)];
    [picView setImage:[UIImage imageNamed:@"wowomen"]];
    picView.layer.cornerRadius = SCREEN_W/10;
    picView.layer.borderWidth = 1;
    picView.layer.borderColor = ([UIColor whiteColor].CGColor);
    picView.layer.masksToBounds = YES;
    [_headView addSubview:picView];
    //咨询师名字
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W*2/5, (statusBar_H+navigationBar_H+SCREEN_W/5+10), SCREEN_W/5, 20)];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = @"孙晓平";
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont boldSystemFontOfSize:15];
    [_headView addSubview:nameLab];

}

#pragma mark 定制嵌套滚动视图
- (void)customMainScroview {
    
    _mainScroview = [[UIScrollView alloc]init];
    [_backScroview addSubview:_mainScroview];
    _mainScroview.backgroundColor = [UIColor whiteColor];
    [_mainScroview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom).offset(0);//使顶部与self.view的间距为0
        make.left.equalTo(self.view.mas_left).offset(0);//使左边等于self.view的左边，间距为0
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(_tabBar.mas_top).offset(0);
    }];
    [self.view insertSubview:_tabBar aboveSubview:_mainScroview];
    _mainScroview.pagingEnabled = YES;
    _mainScroview.bounces = NO;
    _mainScroview.delegate = self;
    
//    NSLog(@"可动高%f",_mainScroview.contentSize.height + _headView.frame.size.height);

    NSArray *viewArr = _mainScroview.subviews;
    for (UIView *view in viewArr) {
        [view removeFromSuperview];
    }
    
    NSArray *vcArr = self.childViewControllers;
    for (UIViewController *vc in vcArr) {
        [vc removeFromParentViewController];
    }
    
    _mainScroview.contentSize = CGSizeMake(SCREEN_W*2, 0);
    
    UIView *orderPageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, _mainScroview.frame.size.height)];
    OrderPageTbC *orderPage = [[OrderPageTbC alloc]init];
    [self addChildViewController:orderPage];
    [orderPageView addSubview:orderPage.view];
    [_mainScroview addSubview:orderPageView];
    
    UIView *confirmPageView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_W, 0, SCREEN_W, _mainScroview.frame.size.height)];
    ConfirmPageTbC *confirmPage = [[ConfirmPageTbC alloc]init];
    [self addChildViewController:confirmPage];
    [confirmPageView addSubview:confirmPage.view];
    [_mainScroview addSubview:confirmPageView];

    
    CGSize bgScoViewSize = CGSizeMake(0, _mainScroview.contentSize.height + _headView.frame.size.height);
    _backScroview.contentSize = bgScoViewSize;




    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _mainScroview) {
        
        if (scrollView.contentOffset.y > 0) {
            CGFloat offsetY = scrollView.contentOffset.y + _backScroview.contentOffset.y;
            [_backScroview setContentOffset:CGPointMake(0, offsetY)];
            [scrollView setContentOffset:CGPointZero];


        }
        
//        NSLog(@"下面的%f",scrollView.contentOffset.y);
//        NSLog(@"上面的%f",_backScroview.contentOffset.y);
//        
//        CGFloat offsetY = scrollView.contentOffset.y + _backScroview.contentOffset.y;
//        NSLog(@"总共的%f",offsetY);
//
//        [_backScroview setContentOffset:CGPointMake(0, offsetY)];
//        [scrollView setContentOffset:CGPointZero];

    }
    else if (scrollView == _backScroview) {
        
        NSLog(@"下面的%f",_mainScroview.contentOffset.y);
        NSLog(@"%f",scrollView.contentOffset.y);

        
    }
    
    
    
    
}


#pragma mark 定制底部TabBar
- (void)creatBottomBar {
    
    _tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_H-tabBar_H, SCREEN_W, tabBar_H)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - 100, 0, 100, tabBar_H)];
    btn.backgroundColor = MAINCOLOR;
    [btn setTitle:@"预约" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAppointmentBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:btn];
    
    [self.view addSubview:_tabBar];

    
}

- (void)clickAppointmentBtn {
    NSLog(@"点击预约按钮");
    
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
