//
//  ConfirmPageVC.m
//  letian
//
//  Created by J on 2017/3/9.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ConfirmPageVC.h"
#import "ConfirmPageCell.h"
#import "OrderModel.h"

#import "FSCalendar.h"
#import "HZQDatePickerView.h"
#import "MBProgressHUD.h"
#import "LRTextField.h"
#import "ZYKeyboardUtil.h"

#import "OrderPageVC.h"

@interface ConfirmPageVC ()<UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, HZQDatePickerViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) OrderModel *orderModel;
//@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UITabBar *tabBar;
@property (nonatomic, weak) FSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSCalendar *gregorianCalendar;
@property (nonatomic, assign) BOOL isToday;

@property (nonatomic, strong) UIView *timeChoicesView;
@property (nonatomic, strong) UILabel *dateDisplayLab;

@property (nonatomic, strong) HZQDatePickerView *pikerView;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *endBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) NSDate *startDate;

//@property (nonatomic, strong) UIAlertController *dateAlCtl;
//@property (nonatomic, strong) UIPickerView *datePick;
@property (nonatomic, strong) ZYKeyboardUtil *keyboardUtil;

@property (nonatomic, assign) NSInteger firstCellHeight;

@property (nonatomic, strong) UIButton *ConfirmBtn;


@end

@implementation ConfirmPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.keyboardUtil = [[ZYKeyboardUtil alloc] init];
    _isToday = YES;
    _orderModel = [[OrderModel alloc]init];
//    self.view.backgroundColor = [UIColor yellowColor];
    [self customNavigation];
    [self customMainTableView];
    
    [self configKeyBoardRespond];
    [self creatBottomBar];
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
//    self.navigationController.navigationBar.barTintColor = MAINCOLOR;
    self.navigationItem.title = @"孙晓平";
    _orderModel.conserlorName = self.navigationItem.title;
//    NSLog(@"%@",_orderModel.conserlorName);
    
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

- (void)customHUDWithText:(NSString *)str {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];;
    HUD.mode = MBProgressHUDModeText;
    HUD.label.text = str;
    [HUD hideAnimated:YES afterDelay:2.f];

    
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
    _mainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    

    
    
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

#pragma mark 主界面cell
- (void)customCell:(UITableViewCell *)cell withBgView:(UIView *)view forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
//        view.backgroundColor = [UIColor yellowColor];
        
        NSArray *btnTitle = @[@"面对面咨询",@"文字语音",@"电话咨询"];
        
        for (int i = 0; i < 3; i++) {
            
            UIButton *btn = [GQControls createButtonWithFrame:CGRectMake(10+SCREEN_W/3*i, 10, SCREEN_W/3-20, 30) andTitle:btnTitle[i] andTitleColor:MAINCOLOR andFontSize:15 andTag:i+1 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(clickChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
        }
        
        UIButton *defBtn = [view viewWithTag:1];
        defBtn.selected = YES;
        defBtn.backgroundColor = MAINCOLOR;
        _orderModel.orderChoice = defBtn.titleLabel.text;

        [self setupCalendarWithBGView:view];
        [self creatTimeChoicesViewWithBGView:view];
        
        
    } else {
        [self inputInfoWithBackView:view];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        CGFloat height = _timeChoicesView.y + 75;
        return height;
    } else {
        return 420;
    }
    
}

- (void)clickChoiceBtn:(UIButton *)btn {

    [self animationbegin:btn];
    for (int i = 0; i < 3; i++) {
        UIButton *btnn = [self.view viewWithTag:i+1];
        btnn.selected = NO;
        btnn.backgroundColor = [UIColor whiteColor];
//        btnn.enabled = YES;
    }
    
    btn.selected = YES;
    btn.backgroundColor = MAINCOLOR;
    _orderModel.orderChoice = btn.titleLabel.text;
    NSLog(@"%@",_orderModel.orderChoice);
//    btn.enabled = NO;
    
}

#pragma mark 日历
- (void)setupCalendarWithBGView:(UIView *)view {
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(10, 60, SCREEN_W-20, SCREEN_H*0.45)];
    [view addSubview:calendar];

    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.headerTitleColor = MAINCOLOR;
    calendar.appearance.weekdayTextColor = MAINCOLOR;
    calendar.appearance.todayColor = MAINCOLOR;
    calendar.appearance.selectionColor = MAINCOLOR;
    
    self.calendar = calendar;
    
    self.gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    self.dateFormatter.dateFormat = @"yyyy年MM月dd日";              //时间格式用来判断日期
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date {
    if ([self.gregorianCalendar isDateInToday:date]) {
        
        NSString *todayStr = [self.dateFormatter stringFromDate:date];
        _orderModel.orderDateStr = todayStr;
//        NSLog(@"%@",_orderModel.orderDateStr);

        return @"今";
    }
    return nil;
}

#pragma mark 时间选择View
- (void)creatTimeChoicesViewWithBGView:(UIView *)view {
    
    _timeChoicesView = [[UIView alloc]initWithFrame:CGRectMake(30, _calendar.height+70, SCREEN_W-60, 40)];
    _dateDisplayLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _timeChoicesView.width, 40)];
    [view addSubview:_timeChoicesView];
    
    NSString *todayStr = [self.dateFormatter stringFromDate:[NSDate new]];
    _dateDisplayLab.text = todayStr;
    _dateDisplayLab.textColor = MAINCOLOR;
    _dateDisplayLab.textAlignment = 1;
    _dateDisplayLab.font = [UIFont systemFontOfSize:20];
    
//    UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(_timeChoicesView.width/2, 5, _timeChoicesView.width/5, 30)];
    
    _startBtn = [GQControls createButtonWithFrame:CGRectMake(_timeChoicesView.width*0.1, 5, _timeChoicesView.width*0.3, 30) andTitle:@"起始时间" andTitleColor:MAINCOLOR andFontSize:15 andTag:102 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
    _startBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _startBtn.titleLabel.textAlignment = NSTextAlignmentCenter;

    _endBtn = [GQControls createButtonWithFrame:CGRectMake(_timeChoicesView.width*0.6, 5, _timeChoicesView.width*0.3, 30) andTitle:@"结束时间" andTitleColor:MAINCOLOR andFontSize:15 andTag:103 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
    _endBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _endBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_startBtn addTarget:self action:@selector(clickTimeChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_endBtn addTarget:self action:@selector(clickTimeChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];

    _lineView = [[UIView alloc]initWithFrame:CGRectMake(_timeChoicesView.width*0.4+20, _timeChoicesView.height*0.5-1, _timeChoicesView.width*0.2-40, 2)];
    _lineView.backgroundColor = MAINCOLOR;
    
    [_timeChoicesView addSubview:_startBtn];
    [_timeChoicesView addSubview:_endBtn];
    [_timeChoicesView addSubview:_lineView];
    
}

#pragma mark 点击日历方法
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    //改变图标
    calendar.appearance.todayColor = [UIColor whiteColor];
    calendar.appearance.titleTodayColor = MAINCOLOR;
    //判断日期
    NSString *todayStr = [self.dateFormatter stringFromDate:[NSDate new]];
    NSString *selDateStr = [self.dateFormatter stringFromDate:date];
    NSDate *todayDate = [self.dateFormatter dateFromString:todayStr];
    NSDate *selDate = [self.dateFormatter dateFromString:selDateStr];
    NSComparisonResult result = [selDate compare:todayDate];
    if (result == NSOrderedAscending) {
        NSLog(@"不可以穿越到过去预约哦");
        _isToday = NO;
        _dateDisplayLab.text = @"不可以穿越到过去预约哦";
        _dateDisplayLab.font = [UIFont systemFontOfSize:20];
        [_startBtn removeFromSuperview];
        [_endBtn removeFromSuperview];
        [_lineView removeFromSuperview];
        [_timeChoicesView addSubview:_dateDisplayLab];
        
        _orderModel.orderDateStr = nil;
//        NSLog(@"%@",_orderModel.orderDateStr);
//        _ConfirmBtn.enabled = NO;
//        _ConfirmBtn.backgroundColor = [UIColor lightGrayColor];
        
    } else if (result == NSOrderedSame) {
        
        _isToday = YES;
        [_dateDisplayLab removeFromSuperview];
        [_timeChoicesView addSubview:_startBtn];
        [_timeChoicesView addSubview:_endBtn];
        [_timeChoicesView addSubview:_lineView];
        
        _orderModel.orderDateStr = selDateStr;
//        NSLog(@"%@",_orderModel.orderDateStr);
//        _ConfirmBtn.enabled = YES;
//        _ConfirmBtn.backgroundColor = MAINCOLOR;
        
    } else {
        
        _isToday = NO;
        [_dateDisplayLab removeFromSuperview];
        [_timeChoicesView addSubview:_startBtn];
        [_timeChoicesView addSubview:_endBtn];
        [_timeChoicesView addSubview:_lineView];
        _orderModel.orderDateStr = selDateStr;
//        NSLog(@"%@",_orderModel.orderDateStr);
//        _ConfirmBtn.enabled = YES;
//        _ConfirmBtn.backgroundColor = MAINCOLOR;
    }
    
//    NSLog(@"是否今天bool值：%@",_isToday?@"YES":@"NO");
//    _orderModel.orderDateStr = selDateStr;
//    NSLog(@"%@",_orderModel.orderDateStr);
    [_startBtn setTitle:@"起始时间" forState:UIControlStateNormal];
    [_endBtn setTitle:@"结束时间" forState:UIControlStateNormal];
    
//    NSLog(@"did select date %@",_startDate);
    
}

- (void)clickTimeChoiceBtn:(UIButton *)btn {
    
    if (btn == _startBtn) {
        [self animationbegin:btn];
        [self setupDateView:DateTypeOfStart];
        
    } else if (btn == _endBtn) {
        
        [self animationbegin:btn];
        [self setupDateView:DateTypeOfEnd];
    }
}

#pragma mark 选择时间界面
- (void)setupDateView:(DateType)type {
    
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    _pikerView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    _pikerView.datePickerView.minuteInterval = 30;
    
    switch (type) {
        case DateTypeOfStart:
            
            // 今天开始往后的日期
            
            if (_isToday == YES) {
                [_pikerView.datePickerView setMinimumDate:[NSDate new]];
            } else {

                
            }
            
            [self.view addSubview:_pikerView];
            
            break;
            
        case DateTypeOfEnd:
            
            if ([_startBtn.titleLabel.text isEqual: @"起始时间"]) {
                NSLog(@"请先选择起始时间");
                [self customHUDWithText:@"请先选择起始时间"];

            } else {
                
                NSDate *anHourDate = [_startDate dateByAddingTimeInterval:60*60];
                NSLog(@"%@",anHourDate);
                
                _pikerView.coverView.hidden = NO;
                [_pikerView.datePickerView setMinimumDate:anHourDate];
                [self.view addSubview:_pikerView];
            }
            
            break;
            
        default:
            break;
    }
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    
    switch (type) {
        case DateTypeOfStart:
            
            if ([date containsString:@":00"] || [date containsString:@":30"]) {
                _startDate = [_pikerView.datePickerView date];
                NSLog(@"%@",_startDate);
                [_startBtn setTitle:[NSString stringWithFormat:@"%@", date] forState:UIControlStateNormal];
                [_endBtn setTitle:@"结束时间" forState:UIControlStateNormal];
            } else {
                NSLog(@"请选择整点时间");
                [self customHUDWithText:@"请选择正确的时间"];
                
            }
            break;
            
        case DateTypeOfEnd:
            [_endBtn setTitle:[NSString stringWithFormat:@"%@", date] forState:UIControlStateNormal];
            
            break;
            
        default:
            break;
    }
}

#pragma mark 输入个人信息cell
- (void)inputInfoWithBackView:(UIView *)bgView {
    
    //点击空白收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [bgView addGestureRecognizer:tap];
    tap.delegate = self;
    
    
    
    LRTextField *nameTextField = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, 30, SCREEN_W*0.7, 30) labelHeight:15];
    [bgView addSubview:nameTextField];
    nameTextField.delegate = self;
    nameTextField.placeholder = @"姓名";
    nameTextField.placeholderActiveColor = MAINCOLOR;
    
    LRTextField *sexTextField = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, 90, SCREEN_W*0.7, 30) labelHeight:15];
    [bgView addSubview:sexTextField];
    sexTextField.delegate = self;
    sexTextField.placeholder = @"性别";
    sexTextField.placeholderActiveColor = MAINCOLOR;
    sexTextField.hintText = @"请输入 \"男\" \"女\" \"其他\"";
    [sexTextField setValidationBlock:^NSDictionary *(LRTextField *textField, NSString *text) {
        [NSThread sleepForTimeInterval:1.0];
        if ([text isEqualToString:@"男"] || [text isEqualToString:@"女"] || [text isEqualToString:@"其他"]) {
            return @{ VALIDATION_INDICATOR_COLOR : @"MAINCOLOR" };
        }
        return @{ VALIDATION_INDICATOR_NO : @"请输入 \"男\" \"女\" \"其他\"" };
    }];
    
    LRTextField *ageTextField = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, 150, SCREEN_W*0.7, 30) labelHeight:15];
    [bgView addSubview:ageTextField];
    ageTextField.placeholder = @"年龄";
    ageTextField.placeholderActiveColor = MAINCOLOR;
    ageTextField.keyboardType = UIKeyboardTypeNumberPad;

    LRTextField *phoneTextField = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, 210, SCREEN_W*0.7, 30) labelHeight:15 style:LRTextFieldStylePhone];
    [bgView addSubview:phoneTextField];
    phoneTextField.placeholder = @"电话";
    phoneTextField.placeholderActiveColor = MAINCOLOR;
    
    LRTextField *emailTextField = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, 270, SCREEN_W*0.7, 30) labelHeight:15 style:LRTextFieldStyleEmail];
    [bgView addSubview:emailTextField];
    emailTextField.placeholder = @"邮箱*";
    emailTextField.placeholderActiveColor = MAINCOLOR;
    emailTextField.hintText = @"*选填";
    emailTextField.hintTextColor = [UIColor blackColor];


    
    
    
}


//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)configKeyBoardRespond {
    __weak ConfirmPageVC *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.mainTableView, nil];
    }];
}


#pragma mark 定制底部TabBar
- (void)creatBottomBar {
    
    _tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_H-tabBar_H, SCREEN_W, tabBar_H)];
    _ConfirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*2/3, 0, SCREEN_W/3, tabBar_H)];
    _ConfirmBtn.backgroundColor = [UIColor lightGrayColor];
    _ConfirmBtn.enabled = NO;
    [_ConfirmBtn setTitle:@"确定预约" forState:UIControlStateNormal];
    [_ConfirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:_ConfirmBtn];
    
    
    [self.view addSubview:_tabBar];
    
}

- (void)clickConfirmBtn {
    NSLog(@"确认预约");
    
    OrderPageVC *vcc = [[OrderPageVC alloc]init];
    [self.navigationController pushViewController:vcc animated:YES];
    
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
