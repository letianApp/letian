//
//  CustomDateViewController.m
//  letian
//
//  Created by J on 2017/4/27.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CustomDateViewController.h"

#import "FSCalendar.h"


@interface CustomDateViewController () <FSCalendarDelegate, FSCalendarDataSource>

@property (nonatomic, weak  ) FSCalendar             *calendar;
@property (nonatomic, strong) NSDateFormatter        *dateFormatter;
@property (nonatomic, strong) NSCalendar             *gregorianCalendar;
@property (nonatomic, assign) BOOL                   isToday;


@end

@implementation CustomDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    [self customNavigation];
    [self setupCalendarWithBGView:self.view];
    
    
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

#pragma mark 日历
- (void)setupCalendarWithBGView:(UIView *)view {
    
    FSCalendar *calendar                 = [[FSCalendar alloc] initWithFrame:CGRectMake(10, statusBar_H+navigationBar_H+ 10, SCREEN_W-20, SCREEN_H*0.45)];
    [view addSubview:calendar];
    
    calendar.dataSource                  = self;
    calendar.delegate                    = self;
    calendar.backgroundColor             = [UIColor whiteColor];
    calendar.appearance.headerTitleColor = MAINCOLOR;
    calendar.appearance.weekdayTextColor = MAINCOLOR;
    calendar.appearance.todayColor       = MAINCOLOR;
    calendar.appearance.selectionColor   = MAINCOLOR;
    
    self.calendar                        = calendar;
    
    self.gregorianCalendar               = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter                   = [[NSDateFormatter alloc] init];
    self.dateFormatter.timeZone          = [NSTimeZone systemTimeZone];
    self.dateFormatter.dateFormat        = @"yyyy-MM-dd";//时间格式用来判断日期
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date {
    if ([self.gregorianCalendar isDateInToday:date]) {
        
//        NSString *todayStr = [self.dateFormatter stringFromDate:date];
        //        NSLog(@"%@",_orderModel.orderDate);
        return @"今";
    }
    return nil;
}

#pragma mark 点击日历方法
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    //改变图标
    calendar.appearance.todayColor      = [UIColor whiteColor];
    calendar.appearance.titleTodayColor = MAINCOLOR;

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
