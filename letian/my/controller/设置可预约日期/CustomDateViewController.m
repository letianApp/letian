//
//  CustomDateViewController.m
//  letian
//
//  Created by J on 2017/4/27.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CustomDateViewController.h"

#import "FSCalendar.h"


@interface CustomDateViewController ()

@property (nonatomic, weak  ) FSCalendar             *calendar;
@property (nonatomic, strong) NSDateFormatter        *dateFormatter;
@property (nonatomic, strong) NSCalendar             *gregorianCalendar;
@property (nonatomic, assign) BOOL                   isToday;


@end

@implementation CustomDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavigation];
    
    
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    self.navigationItem.title = @"设置可预约日期";
    
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
