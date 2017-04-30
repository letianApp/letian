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

@property (nonatomic, strong) NSMutableDictionary      *requestParams;


@end

@implementation CustomDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _requestParams = [NSMutableDictionary new];
    
    [self customNavigation];
    [self setupCalendarWithBGView:self.view];
    

    
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    self.navigationItem.title = @"设置可预约日期";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"月" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
    rightBtn.tintColor = MAINCOLOR;
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)rightBtnClick:(UIBarButtonItem *)btn {
    
    if ([btn.title isEqualToString:@"月"]) {
        [btn setTitle:@"周"];
        self.calendar.scope = FSCalendarScopeWeek;

    } else {
        [btn setTitle:@"月"];
        self.calendar.scope = FSCalendarScopeMonth;

    }
    NSLog(@"%f",self.calendar.bottom);
    
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
    
    FSCalendar *calendar                 = [[FSCalendar alloc] initWithFrame:CGRectMake(10, statusBar_H+navigationBar_H, SCREEN_W-20, SCREEN_H*0.45)];
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
    
    NSString *selDateStr                = [self.dateFormatter stringFromDate:date];

    NSLog(@"%@",selDateStr);

    [self setCounsultSetForDay:[NSString stringWithFormat:@"%@ 00:00:00",selDateStr]];
    [self getCounsultSetForDay:selDateStr];

}

#pragma mark 根据日期获得咨询师设置
- (void)getCounsultSetForDay:(NSString *)dayStr {
    
    __weak typeof(self) weakSelf   = self;
    
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_DOCTORSET];
    [requestString appendFormat:@"%@",API_NAME_GETCONSULTSETFORDAY];
    
    NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
    parames[@"date"] = dayStr;
    
    [PPNetworkHelper setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOjQsImxvZ2lubmFtZSI6IjE4OTc3MzQzODQzIiwicmVhbG5hbWUiOm51bGwsImV4cGlyZXRpbWUiOjE0OTI3NDE0ODV9.GczqZEMSZTDEXHK2AHhhkDeUGm5f0o2rmVu9h79JsfE" forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper GET:requestString parameters:parames success:^(id responseObject) {
        __strong typeof(self) strongself = weakSelf;
        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        __strong typeof(self) strongself = weakSelf;
        
        [MBHudSet showText:[NSString stringWithFormat:@"获取咨询师订单列表错误，错误代码：%ld",error.code]andOnView:strongself.view];
    }];
    
    
}

- (void)setCounsultSetForDay:(NSString *)dayStr {
    
    __weak typeof(self) weakSelf   = self;
    
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_DOCTORSET];
    [requestString appendFormat:@"%@",API_NAME_DOSETCONSULTSET];
    
    NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
    
    NSDictionary *consultTimeDic = @{@"StartTime":@"05:00:00",@"EndTime":@"13:00:00"};
//    consultTimeDic[@"StartTime"] = @"05:00:00";
//    consultTimeDic[@"EndTime"] = @"13:00:00";
    NSMutableArray *consultTimeArr = [[NSMutableArray alloc]init];
    [consultTimeArr addObject:consultTimeDic];
    
    
    parames[@"CousultDate"] = dayStr;
    parames[@"IsEnableConsult"] = @"false";
    parames[@"ConsultTimeList"] = consultTimeArr;
    
    NSLog(@"parames:%@",parames);
    
    [PPNetworkHelper setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOjQsImxvZ2lubmFtZSI6IjE4OTc3MzQzODQzIiwicmVhbG5hbWUiOm51bGwsImV4cGlyZXRpbWUiOjE0OTI3NDE0ODV9.GczqZEMSZTDEXHK2AHhhkDeUGm5f0o2rmVu9h79JsfE" forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:requestString parameters:parames success:^(id responseObject) {
        
        __strong typeof(self) strongself = weakSelf;
        NSLog(@"%@",responseObject);

    } failure:^(NSError *error) {
        __strong typeof(self) strongself = weakSelf;
        [MBHudSet showText:[NSString stringWithFormat:@"上传咨询师订单列表错误，错误代码：%ld",error.code]andOnView:strongself.view];

    }];


    
}


- (void)getCounsultOrderListSourceForMonth {
    
    __weak typeof(self) weakSelf   = self;
    
    NSMutableString *requestConsultOrderListString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestConsultOrderListString appendFormat:@"%@/",API_MODULE_DOCTORSET];
    [requestConsultOrderListString appendFormat:@"%@",API_NAME_GETCONSULTSETFORMONTH];
    
    NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
    parames[@"year"] = @(2017);
    parames[@"month"] = @(5);
    
    [PPNetworkHelper setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOjQsImxvZ2lubmFtZSI6IjE4OTc3MzQzODQzIiwicmVhbG5hbWUiOm51bGwsImV4cGlyZXRpbWUiOjE0OTI3NDE0ODV9.GczqZEMSZTDEXHK2AHhhkDeUGm5f0o2rmVu9h79JsfE" forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper GET:requestConsultOrderListString parameters:parames success:^(id responseObject) {
        __strong typeof(self) strongself = weakSelf;
        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        __strong typeof(self) strongself = weakSelf;
        
        [MBHudSet showText:[NSString stringWithFormat:@"获取咨询师订单列表错误，错误代码：%ld",error.code]andOnView:strongself.view];
    }];
    
    
}

#pragma mark 按钮动画
- (void)animationbegin:(UIView *)view {
    /* 放大缩小 */
    
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
    
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
