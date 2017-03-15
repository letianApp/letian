//
//  ConfirmPageVC.m
//  letian
//
//  Created by J on 2017/3/9.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ConfirmPageVC.h"
#import "ConfirmPageCell.h"
#import "FSCalendar.h"





@interface ConfirmPageVC ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDataSource, FSCalendarDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UITabBar *tabBar;
@property (nonatomic, weak) FSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSCalendar *gregorianCalendar;



@end

@implementation ConfirmPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.view.backgroundColor = [UIColor yellowColor];
    
    [self customMainTableView];
    
    
    [self creatBottomBar];
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    self.navigationController.navigationBar.barTintColor = MAINCOLOR;
    
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

#pragma mark 主界面tableview
- (void)customMainTableView {
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navigationBar_H+statusBar_H, SCREEN_W, SCREEN_H-navigationBar_H-statusBar_H) style:UITableViewStylePlain];
    [self.view addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    //自动计算高度 iOS8
//    _mainTableView.estimatedRowHeight = 44.0;
//    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _mainTableView.rowHeight = 500;
    
    
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConfirmPageCell *cell = [ConfirmPageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;                        //设置cell不可以点
    
    NSArray *lableTagArr = @[@"咨询方式及时间",@"个人信息"];
    cell.labelTag.text = lableTagArr[indexPath.row];
    cell.detialLab.hidden = YES;
//    cell.backView.backgroundColor = [UIColor yellowColor];
    
    
    
    
    [self customCell:cell withBgView:cell.backView forRowAtIndexPath:indexPath];
    
    return cell;
    
}

- (void)customCell:(UITableViewCell *)cell withBgView:(UIView *)view forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
//        view.backgroundColor = [UIColor yellowColor];
        
        NSArray *btnTitle = @[@"面对面咨询",@"文字语音",@"视频咨询"];
        
        for (int i = 0; i < 3; i++) {
            
            UIButton *btn = [GQControls createButtonWithFrame:CGRectMake(10+SCREEN_W/3*i, 10, SCREEN_W/3-20, 30) andTitle:btnTitle[i] andTitleColor:MAINCOLOR andFontSize:15 andTag:i+1 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(clickChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
        }
        
        UIButton *defBtn = [view viewWithTag:1];
        defBtn.selected = YES;
        defBtn.backgroundColor = MAINCOLOR;
        
        [self setupCalendarWithView:view];
        
        
        
    }
    
}

- (void)clickChoiceBtn:(UIButton *)btn {
    
    for (int i = 0; i < 3; i++) {
        UIButton *btnn = [self.view viewWithTag:i+1];
        btnn.selected = NO;
        btnn.backgroundColor = [UIColor whiteColor];
    }
    
    btn.selected = YES;
    btn.backgroundColor = MAINCOLOR;
    
}

- (void)setupCalendarWithView:(UIView *)view {
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(10, 64, SCREEN_W-20, SCREEN_H*0.45)];
    calendar.dataSource = self;
    calendar.delegate = self;
    
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.headerTitleColor = MAINCOLOR;
    calendar.appearance.weekdayTextColor = MAINCOLOR;
//    calendar.appearance.titleTodayColor = MAINCOLOR;
    calendar.appearance.todayColor = MAINCOLOR;
    calendar.appearance.selectionColor = MAINCOLOR;
    
    [view addSubview:calendar];
    self.calendar = calendar;
    
    self.gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorianCalendar isDateInToday:date]) {
        return @"今";
    }
    return nil;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    calendar.appearance.todayColor = [UIColor whiteColor];
    calendar.appearance.titleTodayColor = MAINCOLOR;
    
    NSDate *todayDate = [NSDate new];
//    NSDate *selDate = [self.dateFormatter stringFromDate:date];
    
    
    
    if ([date earlierDate:todayDate]) {
//        NSLog(@"早");
    }
    
    
    

    
    NSLog(@"当前时间：%@",todayDate);
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    
}

//- (NSDate *)laterDate:(NSDate *)anotherDate {
//    
//}


//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


#pragma mark 定制底部TabBar
- (void)creatBottomBar {
    
    _tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_H-tabBar_H, SCREEN_W, tabBar_H)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*2/3, 0, SCREEN_W/3, tabBar_H)];
    btn.backgroundColor = MAINCOLOR;
    [btn setTitle:@"确定预约" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:btn];
    
    
    [self.view addSubview:_tabBar];
    
}

- (void)clickConfirmBtn {
    NSLog(@"确认预约");
    
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
