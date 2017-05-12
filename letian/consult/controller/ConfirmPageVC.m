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

#import <MapKit/MapKit.h>
#import "FSCalendar.h"
#import "LRTextField.h"
#import "ZYKeyboardUtil.h"
#import "Colours.h"
#import "SnailPopupController.h"

#import "OrderPageVC.h"
#import "PayPageVC.h"
#import "MJExtension.h"

@interface ConfirmPageVC ()<UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) OrderModel             *orderModel;
@property (nonatomic, strong) UITableView            *mainTableView;

@property (nonatomic, strong) UIButton               *mapBtn;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;//!< 要导航的坐标

@property (nonatomic, weak  ) FSCalendar             *calendar;
@property (nonatomic, strong) NSDateFormatter        *dateFormatter;
@property (nonatomic, strong) NSCalendar             *gregorianCalendar;
@property (nonatomic, assign) BOOL                   isToday;

@property (nonatomic, strong) UIView                 *timeChoicesView;
@property (nonatomic, strong) UILabel                *dateDisplayLab;

@property (nonatomic, strong) UIDatePicker           *timePicker;
@property (nonatomic, strong) UIPickerView           *chooseHoursView;
@property (nonatomic, strong) NSArray                *hoursData;
@property (nonatomic, strong) NSString               *hourStr;

@property (nonatomic, strong) UIButton               *startBtn;
@property (nonatomic, strong) UIButton               *endBtn;

@property (nonatomic, strong) LRTextField            *nameTextField;
@property (nonatomic, strong) LRTextField            *sexTextField;
@property (nonatomic, strong) LRTextField            *ageTextField;
@property (nonatomic, strong) LRTextField            *phoneTextField;
@property (nonatomic, strong) LRTextField            *emailTextField;

@property (nonatomic, strong) UITextView              *detailTextView;
@property (nonatomic, strong) UILabel                 *placeholderLabel;

@property (nonatomic, strong) ZYKeyboardUtil         *keyboardUtil;
@property (nonatomic, strong) UIButton               *confirmBtn;

@property (nonatomic, strong) UITabBar               *tabBar;
@property (nonatomic, strong) UILabel                *priceLab;

@end

@implementation ConfirmPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.coordinate                           = CLLocationCoordinate2DMake(31.1843580000, 121.4398670000);
    self.keyboardUtil                         = [[ZYKeyboardUtil alloc] init];
    _orderModel                               = [[OrderModel alloc]init];
    _isToday                                  = YES;
    //    _isSexRight                               = NO;
    
    [self customNavigation];
    [self customMainTableView];
    
    [self configKeyBoardRespond];
    [self creatBottomBar];
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    self.navigationItem.title = self.counselModel.UserName;
    _orderModel.conserlorName = self.navigationItem.title;
    
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

#pragma mark 主界面tableview
- (void)customMainTableView {
    
    _mainTableView                     = [[UITableView alloc]initWithFrame:CGRectMake(0, navigationBar_H+statusBar_H, SCREEN_W, SCREEN_H-navigationBar_H-statusBar_H) style:UITableViewStylePlain];
    [self.view addSubview:_mainTableView];
    _mainTableView.delegate            = self;
    _mainTableView.dataSource          = self;
    _mainTableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
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
        
        NSArray *btnTitle                        = @[@"面对面咨询",@"文字语音视频",@"电话咨询"];
        for (int i                               = 0; i < 3; i++) {
            UIButton *btn                            = [GQControls createButtonWithFrame:CGRectMake(10+SCREEN_W/3*i, 10, SCREEN_W/3-20, 30) andTitle:btnTitle[i] andTitleColor:MAINCOLOR andFontSize:15 andTag:i*10+1 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
            btn.backgroundColor                      = [UIColor whiteColor];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(clickChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
        }
        
        UIButton *defBtn                         = [view viewWithTag:1];
        defBtn.selected                          = YES;
        defBtn.backgroundColor                   = MAINCOLOR;
        _orderModel.consultType                  = 1;
        
        _mapBtn                                  = [[UIButton alloc]init];
        _mapBtn.frame                            = CGRectMake(10, defBtn.bottom+10, SCREEN_W-20, 50);
        NSString *str                            = @"面对面咨询地点：上海市徐汇区零陵路791弄上影广场3号楼20层2002室";
        NSMutableAttributedString *attrStr       = [[NSMutableAttributedString alloc]initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:MAINCOLOR range:NSMakeRange(8, 28)];
        [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 28)];
        [_mapBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
        _mapBtn.titleLabel.font                  = [UIFont systemFontOfSize:15];
        _mapBtn.titleLabel.numberOfLines         = 0;
        [_mapBtn addTarget:self action:@selector(clickMapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_mapBtn];
        
        [self setupCalendarWithBGView:view];
        [self creatTimeChoicesViewWithBGView:view];
        
    } else {
        [self inputInfoWithBackView:view];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        CGFloat height = _timeChoicesView.y + 115;
        return height;
    } else {
        return 520;
    }
}

- (void)clickChoiceBtn:(UIButton *)btn {
    
    [self animationbegin:btn];
    for (int i              = 0; i < 3; i++) {
        UIButton *btnn          = [self.view viewWithTag:i*10+1];
        btnn.selected           = NO;
        btnn.backgroundColor    = [UIColor whiteColor];
    }
    
    btn.selected            = YES;
    btn.backgroundColor     = MAINCOLOR;
    _orderModel.consultType = btn.tag;
    NSLog(@"咨询方式：%ld",(long)_orderModel.consultType);
    [self reflashInfo];
}

#pragma mark 点击地图按钮
- (void)clickMapBtn:(UIButton *)btn {
    
    [self animationbegin:btn];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf   = self;
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"复制地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        __strong typeof(self) strongself = weakSelf;
        [UIPasteboard generalPasteboard].string = @"上海市徐汇区零陵路791弄上影广场3号楼20层2002室";
        [MBHudSet showText:@"地址已经复制到剪贴板" andOnView:strongself.view];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        __strong typeof(self) strongself = weakSelf;
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:strongself.coordinate addressDictionary:nil]];
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
    }]];
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            __strong typeof(self) strongself = weakSelf;
            NSString *urlsting = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",strongself.coordinate.latitude,strongself.coordinate.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlsting]];
        }]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            __strong typeof(self) strongself = weakSelf;
            NSString *urlsting = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",strongself.coordinate.latitude,strongself.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark 日历
- (void)setupCalendarWithBGView:(UIView *)view {
    
    FSCalendar *calendar                 = [[FSCalendar alloc] initWithFrame:CGRectMake(10, _mapBtn.bottom+10, SCREEN_W-20, SCREEN_H*0.45)];
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
        
        NSString *todayStr = [self.dateFormatter stringFromDate:date];
        _orderModel.orderDate = todayStr;
        //        NSLog(@"%@",_orderModel.orderDate);
        return @"今";
    }
    return nil;
}

#pragma mark 时间选择View
- (void)creatTimeChoicesViewWithBGView:(UIView *)view {
    
    _timeChoicesView                               = [[UIView alloc]initWithFrame:CGRectMake(30, _calendar.bottom+10, SCREEN_W-60, 80)];
    //    _timeChoicesView.backgroundColor = WEAKPINK;
    _dateDisplayLab                                = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _timeChoicesView.width, _timeChoicesView.height)];
    [view addSubview:_timeChoicesView];
    
    _startBtn                                      = [GQControls createButtonWithFrame:CGRectMake(_timeChoicesView.width*0.1, 5, _timeChoicesView.width*0.8, 30) andTitle:@"预约时间" andTitleColor:MAINCOLOR andFontSize:15 andTag:102 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
    _startBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _startBtn.titleLabel.textAlignment             = NSTextAlignmentCenter;
    
    _endBtn                                        = [GQControls createButtonWithFrame:CGRectMake(_timeChoicesView.width*0.1, 45, _timeChoicesView.width*0.8, 30) andTitle:@"预约时长" andTitleColor:MAINCOLOR andFontSize:15 andTag:103 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
    _endBtn.titleLabel.adjustsFontSizeToFitWidth   = YES;
    _endBtn.titleLabel.textAlignment               = NSTextAlignmentCenter;
    
    [_startBtn addTarget:self action:@selector(clickTimeChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_endBtn addTarget:self action:@selector(clickTimeChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_timeChoicesView addSubview:_startBtn];
    [_timeChoicesView addSubview:_endBtn];
    
}

#pragma mark 点击日历方法
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    //改变图标
    calendar.appearance.todayColor      = [UIColor whiteColor];
    calendar.appearance.titleTodayColor = MAINCOLOR;
    //判断日期
    NSString *todayStr                  = [self.dateFormatter stringFromDate:[NSDate new]];
    NSString *selDateStr                = [self.dateFormatter stringFromDate:date];
    NSDate *todayDate                   = [self.dateFormatter dateFromString:todayStr];
    NSDate *selDate                     = [self.dateFormatter dateFromString:selDateStr];
    _orderModel.orderDate               = selDateStr;
    
    NSComparisonResult result           = [selDate compare:todayDate];
    if (result == NSOrderedAscending) {
        _isToday                               = NO;
        _dateDisplayLab.textColor              = MAINCOLOR;
        _dateDisplayLab.textAlignment          = 1;
        _dateDisplayLab.text                   = @"不可以穿越到过去预约哦";
        _dateDisplayLab.font                   = [UIFont systemFontOfSize:20];
        _dateDisplayLab.backgroundColor        = [UIColor whiteColor];
        _dateDisplayLab.userInteractionEnabled = YES;
        [_timeChoicesView addSubview:_dateDisplayLab];
        _orderModel.orderDate                  = nil;
        
    } else if (result == NSOrderedSame) {
        _isToday                               = YES;
        [_dateDisplayLab removeFromSuperview];
        
    } else {
        _isToday                               = NO;
        [_dateDisplayLab removeFromSuperview];
    }
    NSLog(@"点击日历：%@",_orderModel.orderDate);
    
    [_startBtn setTitle:@"预约时间" forState:UIControlStateNormal];
    _orderModel.orderDateTimeStart      = nil;
    [_endBtn setTitle:@"预约时长" forState:UIControlStateNormal];
    _orderModel.orderDateTimeEnd        = nil;
    [self reflashInfo];
    
}

#pragma mark 选择时间方法
- (void)clickTimeChoiceBtn:(UIButton *)btn {
    
    [self animationbegin:btn];
    
    self.sl_popupController                          = [[SnailPopupController alloc] init];
    self.sl_popupController.layoutType               = PopupLayoutTypeCenter;
    self.sl_popupController.maskType                 = PopupMaskTypeWhiteBlur;
    self.sl_popupController.transitStyle             = PopupTransitStyleSlightScale;
    self.sl_popupController.dismissOppositeDirection = YES;
    
    if (btn == _startBtn) {
        [self setupDatePiker];
        [self.sl_popupController presentContentView:[self setupDatePiker]];
        
    } else if (btn == _endBtn) {
        
        if ([_startBtn.titleLabel.text isEqual: @"预约时间"]) {
            [MBHudSet showText:@"请确认预约时间" andOnView:self.view];
        } else {
            [self.sl_popupController presentContentView:[self setupChooseHoursView]];

        }
        
    }
    [self reflashInfo];
}

- (UIView *)setupDatePiker {
    
    UIView *backView                                 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H/4, SCREEN_W, SCREEN_H*0.4)];
    _timePicker                                      = [[UIDatePicker alloc]init];
    [backView addSubview:_timePicker];
    _timePicker.centerX                              = backView.centerX;
    _timePicker.datePickerMode                       = UIDatePickerModeTime;
    _timePicker.minuteInterval                       = 30;
    
    UIButton *btn                                    = [GQControls createButtonWithFrame:CGRectMake(SCREEN_W/4, _timePicker.bottom+5, SCREEN_W/2, 30) andTitle:@"确定" andTitleColor:MAINCOLOR andFontSize:15 andTag:233 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
    [backView addSubview:btn];
    [btn addTarget:self action:@selector(clickAffirmTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *customTimeStartStr                     = @"9:00";
    NSString *customTimeEndStr                       = @"21:00";
    NSMutableString *selDateStartStr                 = [NSMutableString stringWithFormat:@"%@ %@", _orderModel.orderDate,customTimeStartStr];
    NSMutableString *selDateEndStr                   = [NSMutableString stringWithFormat:@"%@ %@", _orderModel.orderDate,customTimeEndStr];
    NSDateFormatter *selDateFormatter                = [[NSDateFormatter alloc]init];
    [selDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //真机运行需要设置Local
    NSLocale *locale                                 = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [selDateFormatter setLocale:locale];
    NSDate *selDateStart                             = [selDateFormatter dateFromString:selDateStartStr];
    NSDate *selDateEnd                               = [selDateFormatter dateFromString:selDateEndStr];
    
    if (_isToday == YES) {
        [_timePicker setMinimumDate:[NSDate new]];
    } else {
        [_timePicker setMinimumDate:selDateStart];
        [_timePicker setMaximumDate:selDateEnd];
    }
    
    return backView;
}

- (void)clickAffirmTimeBtn:(UIButton *)btn {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *selTimeStr           = [dateFormatter stringFromDate:_timePicker.date];
    
    [self animationbegin:btn];
    if ([selTimeStr containsString:@":00"] || [selTimeStr containsString:@":30"]) {
        [self.sl_popupController dismiss];
        [_startBtn setTitle:[NSString stringWithFormat:@"%@ %@",_orderModel.orderDate,selTimeStr] forState:UIControlStateNormal];
        _orderModel.orderDateTimeStart = selTimeStr;
        
    } else {
        [MBHudSet showText:@"请选择正确的时间" andOnView:btn.superview];
        
    }
}

- (UIView *)setupChooseHoursView {
    
    _hoursData                  = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    _hourStr                    = _hoursData[0];
    UIView *backView            = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H/4, SCREEN_W, SCREEN_H*0.4)];

    _chooseHoursView            = [[UIPickerView alloc]initWithFrame:CGRectMake(SCREEN_W*0.3, 0, SCREEN_W*0.4, backView.height*0.7)];
    [backView addSubview:_chooseHoursView];
    _chooseHoursView.dataSource = self;
    _chooseHoursView.delegate   = self;

    UIButton *btn               = [GQControls createButtonWithFrame:CGRectMake(SCREEN_W/4, _chooseHoursView.bottom+10, SCREEN_W/2, 30) andTitle:@"确定" andTitleColor:MAINCOLOR andFontSize:15 andTag:234 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
    [backView addSubview:btn];
    [btn addTarget:self action:@selector(clickAffirmHoursBtn:) forControlEvents:UIControlEventTouchUpInside];

    return backView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _hoursData.count;
    }
    return 1;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return _hoursData[row];
    }
    return @"小时";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _hourStr = _hoursData[row];
}

- (void)clickAffirmHoursBtn:(UIButton *)btn {
    
    [self animationbegin:btn];
    [_endBtn setTitle:[NSString stringWithFormat:@"%@ 小时",_hourStr] forState:UIControlStateNormal];
    [_priceLab setText:[NSString stringWithFormat:@"%ld 元",[_hourStr integerValue] * self.counselModel.ConsultFee]];
    
    NSRange rag = {0,2};
    NSInteger startTime = [[_orderModel.orderDateTimeStart substringWithRange:rag] integerValue];
    NSInteger endTime = startTime + [_hourStr integerValue];
    NSString *endStr = [_orderModel.orderDateTimeStart stringByReplacingCharactersInRange:rag withString:[NSString stringWithFormat:@"%li",endTime]];
    _orderModel.orderDateTimeEnd = endStr;
    NSLog(@"结束时间%@",endStr);

    [self reflashInfo];
    [self.sl_popupController dismiss];
}

#pragma mark 输入个人信息cell
- (void)inputInfoWithBackView:(UIView *)bgView {
    
    //点击空白收键盘
    UITapGestureRecognizer *tap           = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [bgView addGestureRecognizer:tap];
    tap.delegate                          = self;
    
    _nameTextField            = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, 30, SCREEN_W*0.7, 30) labelHeight:15];
    [bgView addSubview:_nameTextField];
    _nameTextField.delegate                = self;
    _nameTextField.placeholder             = @"姓名";
    _nameTextField.placeholderActiveColor  = MAINCOLOR;
    _nameTextField.clearButtonMode         = UITextFieldViewModeWhileEditing;
    
    _sexTextField             = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, 90, SCREEN_W*0.7, 30) labelHeight:15];
    [bgView addSubview:_sexTextField];
    _sexTextField.clearButtonMode          = UITextFieldViewModeWhileEditing;
    _sexTextField.delegate                 = self;
    _sexTextField.placeholder              = @"性别";
    _sexTextField.placeholderActiveColor   = MAINCOLOR;
    _sexTextField.hintText                 = @"请输入 \"男\" \"女\" 或\"其他\"";
    [_sexTextField setValidationBlock:^NSDictionary *(LRTextField *textField, NSString *text) {
        [NSThread sleepForTimeInterval:1.0];
        
        if ([text isEqualToString:@"男"] || [textField.text isEqualToString:@"女"] || [textField.text isEqualToString:@"其他"]) {
            return @{ VALIDATION_INDICATOR_COLOR : MAINCOLOR };
        }
        return @{ VALIDATION_INDICATOR_NO : @"请输入 \"男\" \"女\" 或\"其他\"" };
    }];
    
    _ageTextField             = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, 150, SCREEN_W*0.7, 30) labelHeight:15];
    [bgView addSubview:_ageTextField];
    _ageTextField.clearButtonMode          = UITextFieldViewModeWhileEditing;
    _ageTextField.delegate                 = self;
    _ageTextField.placeholder              = @"年龄";
    _ageTextField.placeholderActiveColor   = MAINCOLOR;
    _ageTextField.keyboardType             = UIKeyboardTypeNumberPad;
    
    _phoneTextField           = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, 210, SCREEN_W*0.7, 30) labelHeight:15 style:LRTextFieldStylePhone];
    [bgView addSubview:_phoneTextField];
    _phoneTextField.clearButtonMode        = UITextFieldViewModeWhileEditing;
    _phoneTextField.delegate               = self;
    _phoneTextField.placeholder            = @"电话";
    _phoneTextField.placeholderActiveColor = MAINCOLOR;
    
    _emailTextField           = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, 270, SCREEN_W*0.7, 30) labelHeight:15 style:LRTextFieldStyleEmail];
    [bgView addSubview:_emailTextField];
    _emailTextField.clearButtonMode        = UITextFieldViewModeWhileEditing;
    _emailTextField.delegate               = self;
    _emailTextField.placeholder            = @"邮箱*";
    _emailTextField.placeholderActiveColor = MAINCOLOR;
    _emailTextField.hintText               = @"*选填";
    _emailTextField.hintTextColor          = [UIColor blackColor];
    
    _detailTextView                     = [[UITextView alloc]initWithFrame:CGRectMake(SCREEN_W*0.15, 330 , SCREEN_W*0.7, 80)];
    _detailTextView.delegate            = self;
    _detailTextView.font                = [UIFont systemFontOfSize:17];
    _placeholderLabel                   = [GQControls createLabelWithFrame:CGRectMake(5, 10, 200, 20) andText:@"请简述您的咨询内容*" andTextColor:[UIColor lightGrayColor] andFontSize:17];
    [_detailTextView addSubview:_placeholderLabel];
    _detailTextView.layer.masksToBounds = YES;
    _detailTextView.layer.cornerRadius  = 5;
    _detailTextView.layer.borderWidth   = 0.7;
    _detailTextView.layer.borderColor   = [[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] CGColor];
    [bgView addSubview:_detailTextView];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]) {
        _placeholderLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _placeholderLabel.hidden = NO;
    }
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    _orderModel.orderInfoName  = _nameTextField.text;
    _orderModel.orderInfoAge   = [_ageTextField.text integerValue];
    _orderModel.orderInfoPhone = _phoneTextField.text;
    _orderModel.orderInfoEmail = _emailTextField.text;
    if ([_sexTextField.text isEqualToString:@"男"]) {
        _orderModel.orderInfoSex = Male;
    } else if ([_sexTextField.text isEqualToString:@"女"]) {
        _orderModel.orderInfoSex = Female;
    } else if ([_sexTextField.text isEqualToString:@"其他"]) {
        _orderModel.orderInfoSex = Other;
    } else {
        _orderModel.orderInfoSex = Error;
    }
    
    [self reflashInfo];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _ageTextField) {
        if(range.length + range.location > textField.text.length) {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 3;
    }
    return YES;
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
    [self.view addSubview:_tabBar];
    
    _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*2/3, 0, SCREEN_W/3, tabBar_H)];
    _confirmBtn.backgroundColor = [UIColor lightGrayColor];
    [_confirmBtn setTitle:@"确定预约" forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:_confirmBtn];
    
    _priceLab = [[UILabel alloc]init];
    [_tabBar addSubview:_priceLab];
    _priceLab.adjustsFontSizeToFitWidth = YES;
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_confirmBtn.mas_left).offset(-SCREEN_W/80);
        make.top.equalTo(_tabBar.mas_top);
        make.width.equalTo(_tabBar.mas_width).multipliedBy(0.3);
        make.height.equalTo(_tabBar.mas_height);
    }];
    _priceLab.textColor = MAINCOLOR;
//    _priceLab.text = @"1000元";
    _priceLab.textAlignment = NSTextAlignmentRight;
    _priceLab.font = [UIFont boldSystemFontOfSize:15];
    
    
}

- (void)reflashInfo {
    
    if (NULLString(_orderModel.orderDateTimeStart) ||  NULLString(_orderModel.orderDateTimeEnd) || NULLString(_nameTextField.text) ||  NULLString(_sexTextField.text) || (_orderModel.orderInfoSex == Error)  ||  NULLString(_ageTextField.text) || NULLString(_phoneTextField.text)) {
        self.confirmBtn.backgroundColor = [UIColor lightGrayColor];
        
    } else {
        self.confirmBtn.backgroundColor = MAINCOLOR;
        
    }
    
}

- (void)clickConfirmBtn {
    NSLog(@"确认预约");
    
    
    [MBHudSet showStatusOnView:self.view];
    
    //    if (_confirmBtn.backgroundColor == [UIColor lightGrayColor]) {
    //        [self customHUDWithText:@"请完善预约信息"];
    //
    //    } else {
    
    
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendFormat:@"%@",API_NAME_POSTORDER];
    __weak typeof(self) weakSelf   = self;
    
    NSMutableDictionary *params    = [[NSMutableDictionary alloc]init];
    params[@"ConsultUserID"]       = @(self.counselModel.UserID);
    params[@"AppointmentDate"]     = _orderModel.orderDate;
    params[@"StartTime"]           = _orderModel.orderDateTimeStart;
    params[@"EndTime"]             = _orderModel.orderDateTimeEnd;
    params[@"EnumConsultType"]     = @(_orderModel.consultType);
    NSString *priceStr = _priceLab.text;
    [priceStr stringByReplacingOccurrencesOfString:@" 元" withString:@""];
    params[@"TotalFee"]            = @([priceStr integerValue]);
    params[@"ConSultName"]         = _orderModel.orderInfoName;
    params[@"EnumSexType"]         = @(_orderModel.orderInfoSex);
    params[@"ConsultAge"]          = @(_orderModel.orderInfoAge);
    params[@"ConsultPhone"]        = _orderModel.orderInfoPhone;
    if (_emailTextField.text) {
        params[@"ConsultEmail"]    = _orderModel.orderInfoEmail;
    }
    if (_detailTextView.text) {
        params[@"ConsultDescription"]  = self.detailTextView.text;
    }
    [PPNetworkHelper setValue:kFetchToken forHTTPHeaderField:@"token"];
    NSLog(@"Params=%@",params);
    
    [PPNetworkHelper POST:requestString parameters:params success:^(id responseObject) {
        
        __strong typeof(self) strongself = weakSelf;
        NSLog(@"%@",responseObject);
        [MBHudSet dismiss:strongself.view];
        
        if([responseObject[@"Code"] integerValue] == 200) {
            
            [MBHudSet showText:@"下单成功" andOnView:strongself.view];
            NSLog(@"%@",responseObject[@"Result"][@"Source"][@"OrderID"]);
            PayPageVC *payPage = [[PayPageVC alloc]init];
            payPage.orderID = [responseObject[@"Result"][@"Source"][@"OrderID"] integerValue];
            payPage.orderNo = responseObject[@"Result"][@"Source"][@"OrderNo"];
            payPage.orderTypeString=responseObject[@"Result"][@"Source"][@"ConsultTypeIDString"];
            payPage.consultorName=strongself.orderModel.conserlorName;
            [strongself.navigationController pushViewController:payPage animated:YES];
            
        }else{
            
            [MBHudSet showText:responseObject[@"Msg"] andOnView:strongself.view];
        }
        
    } failure:^(NSError *error) {
        
        __strong typeof(self) strongself = weakSelf;
        
        NSLog(@"错误代码：%ld",error.code);
        
        NSLog(@"错误%@",error);
        [MBHudSet dismiss:strongself.view];
        [MBHudSet showText:[NSString stringWithFormat:@"创建订单失败，错误代码：%ld",error.code]andOnView:strongself.view];
        
    }];
   
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
