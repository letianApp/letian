//
//  CustomDateViewController.m
//  letian
//
//  Created by J on 2017/4/27.
//  Copyright © 2017年 J. All rights reserved.
//

#import "CustomDateViewController.h"

#import "ConsultSetCell.h"

#import "FSCalendar.h"
#import "Colours.h"
#import "SnailPopupController.h"


@interface CustomDateViewController () <FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView            *mainTableView;
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
    
    [self customMainTableView];
    [self customNavigation];
    [self setupCalendarWithBGView:self.view];
    

    
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    self.navigationItem.title = @"设置可预约日期";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"周" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
    rightBtn.tintColor = MAINCOLOR;
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)rightBtnClick:(UIBarButtonItem *)btn {
    
    [_mainTableView beginUpdates];

    if ([btn.title isEqualToString:@"月"]) {
        [btn setTitle:@"周"];
//        self.calendar.scope = FSCalendarScopeWeek;
        [self.calendar setScope:FSCalendarScopeWeek animated:YES];
        

    } else {
        [btn setTitle:@"月"];
//        self.calendar.scope = FSCalendarScopeMonth;
        [self.calendar setScope:FSCalendarScopeMonth animated:YES];


    }
    
    [_mainTableView setTableHeaderView:_calendar];
    [_mainTableView endUpdates];

}

- (void)customMainTableView {
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, statusBar_H+navigationBar_H, SCREEN_W, SCREEN_H-statusBar_H-navigationBar_H) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTableView];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.backgroundColor = [UIColor snowColor];
    _mainTableView.estimatedRowHeight = 44.0;
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ConsultSetCell *cell = [ConsultSetCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.startTimeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;

    } else {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setCellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }

}

- (void)clickBtn:(UIButton *)btn {
    
    NSLog(@"点击aa");
    [self animationbegin:btn];
    
    self.sl_popupController                          = [[SnailPopupController alloc] init];
    self.sl_popupController.layoutType               = PopupLayoutTypeCenter;
    self.sl_popupController.maskType                 = PopupMaskTypeWhiteBlur;
    self.sl_popupController.transitStyle             = PopupTransitStyleSlightScale;
    self.sl_popupController.dismissOppositeDirection = YES;
    
    [self.sl_popupController presentContentView:btn];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section+1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 20)];
    UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 20)];
    [secHeadView addSubview:tagView];
    tagView.backgroundColor = MAINCOLOR;
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 20)];
    titleLab.text = @"自定义";
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.font = [UIFont systemFontOfSize:12];
    [secHeadView addSubview:titleLab];
    return secHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
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
    
    FSCalendar *calendar                 = [[FSCalendar alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W-20, SCREEN_H*0.45)];
    
    calendar.dataSource                  = self;
    calendar.delegate                    = self;
    calendar.backgroundColor             = [UIColor whiteColor];
    calendar.appearance.headerTitleColor = MAINCOLOR;
    calendar.appearance.weekdayTextColor = MAINCOLOR;
    calendar.appearance.todayColor       = MAINCOLOR;
    calendar.appearance.selectionColor   = MAINCOLOR;
    calendar.scrollDirection             = FSCalendarScrollDirectionHorizontal;
    calendar.scope                       = FSCalendarScopeWeek;
    
    self.calendar                        = calendar;
    _mainTableView.tableHeaderView       = self.calendar;

//    self.calendar.scrollEnabled          = YES;
    

    self.gregorianCalendar               = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter                   = [[NSDateFormatter alloc] init];
    self.dateFormatter.timeZone          = [NSTimeZone systemTimeZone];
    self.dateFormatter.dateFormat        = @"yyyy-MM-dd";//时间格式用来判断日期
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date {
    if ([self.gregorianCalendar isDateInToday:date]) {
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

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    NSLog(@"%f",self.calendar.bottom);

}

#pragma mark 根据日期获得咨询师设置
- (void)getCounsultSetForDay:(NSString *)dayStr {
    
    __weak typeof(self) weakSelf   = self;
    
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_DOCTORSET];
    [requestString appendFormat:@"%@",API_NAME_GETCONSULTSETFORDAY];
    
    NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
    parames[@"date"] = dayStr;
    
    [PPNetworkHelper setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOjEwLCJsb2dpbm5hbWUiOiIxMTEiLCJyZWFsbmFtZSI6Iueci-eci-eciyIsImV4cGlyZXRpbWUiOjE0OTQzODI1OTJ9.mPyutAzQnOBQABC9jXya1UNvHYrVeYvX6qq-5TSzNl4" forHTTPHeaderField:@"token"];
    
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
    NSArray *arr = @[@{@"StartTime":@"05:00:00",@"EndTime":@"13:00:00"}];
    NSMutableArray *consultTimeArr = [[NSMutableArray alloc]init];
    [consultTimeArr addObject:consultTimeDic];
    
    
    
    parames[@"CousultDate"] = dayStr;
    parames[@"IsEnableConsult"] = @"false";
    parames[@"ConsultTimeList"] = arr;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parames options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    
    NSLog(@"parames:%@",parames);
    
    [PPNetworkHelper setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOjQsImxvZ2lubmFtZSI6IjE4OTc3MzQzODQzIiwicmVhbG5hbWUiOm51bGwsImV4cGlyZXRpbWUiOjE0OTI3NDE0ODV9.GczqZEMSZTDEXHK2AHhhkDeUGm5f0o2rmVu9h79JsfE" forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:requestString parameters:parames success:^(id responseObject) {
        
//        __strong typeof(self) strongself = weakSelf;
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
