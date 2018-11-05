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
#import "ConsultDateModel.h"
#import "AgreementVC.h"

#import <MapKit/MapKit.h>
#import "FSCalendar.h"
#import "LRTextField.h"
#import "ZYKeyboardUtil.h"
#import "Colours.h"
#import "SnailPopupController.h"

#import "OrderPageVC.h"
#import "OrderViewController.h"
#import "PayPageVC.h"
#import "MJExtension.h"

@interface ConfirmPageVC ()<UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) OrderModel             *orderModel;
@property (nonatomic, strong) ConsultDateModel       *getInfoModel;
@property (nonatomic, strong) UITableView            *mainTableView;

@property (nonatomic, strong) UIButton               *mapBtn;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;//!< 要导航的坐标

@property (nonatomic, weak  ) FSCalendar             *calendar;
@property (nonatomic, strong) NSDateFormatter        *dateFormatter;
@property (nonatomic, strong) NSCalendar             *gregorianCalendar;
@property (nonatomic, assign) BOOL                   isToday;

@property (nonatomic, strong) UIView                 *timeChoicesView;
@property (nonatomic, strong) UILabel                *dateDisplayLab;
@property (nonatomic, strong) UILabel                *consultSetLab;

@property (nonatomic, strong) UIView                 *pickBackView;
@property (nonatomic, strong) UIDatePicker           *timePicker;
@property (nonatomic, strong) UIPickerView           *chooseHoursView;
@property (nonatomic, strong) UILabel                *hoursPriceLab;

@property (nonatomic, strong) NSMutableArray         *hoursData;
@property (nonatomic, strong) NSString               *hourStr;
@property (nonatomic, strong) NSString               *customTimeStartStr;
@property (nonatomic, strong) NSString               *customTimeEndStr;

@property (nonatomic, strong) UIButton               *startBtn;
@property (nonatomic, strong) UIButton               *endBtn;

@property (nonatomic, strong) LRTextField            *nameTextField;
@property (nonatomic, strong) LRTextField            *sexTextField;
@property (nonatomic, strong) LRTextField            *ageTextField;
@property (nonatomic, strong) LRTextField            *phoneTextField;
@property (nonatomic, strong) LRTextField            *emailTextField;
@property (nonatomic, strong) UISwitch               *doSwitch;

@property (nonatomic, strong) UITextView             *detailTextView;
@property (nonatomic, strong) UILabel                *placeholderLabel;

@property (nonatomic, strong) ZYKeyboardUtil         *keyboardUtil;
@property (nonatomic, strong) UIButton               *confirmBtn;

@property (nonatomic, strong) UITabBar               *tabBar;
@property (nonatomic        ) float                  totalPrice;
@property (nonatomic, strong) UILabel                *priceLab;

@end

@implementation ConfirmPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.coordinate                           = CLLocationCoordinate2DMake(31.187489, 121.436822);
    self.keyboardUtil                         = [[ZYKeyboardUtil alloc] init];
    _orderModel                               = [[OrderModel alloc]init];
    _isToday                                  = YES;
    _hoursData = [NSMutableArray new];
    
    [self customNavigation];
    [self customMainTableView];
    
    [self configKeyBoardRespond];
    [self creatBottomBar];
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    self.navigationItem.title = self.counselModel.UserName;
    _orderModel.conserlorName = self.navigationItem.title;
    [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
    self.navigationController.navigationBar.clipsToBounds = YES;
    
    
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
    
    ConfirmPageCell *cell = [ConfirmPageCell cellWithTableView:tableView atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;                        //设置cell不可以点
    
    NSArray *lableTagArr = @[@"咨询方式及时间",@"个人信息"];
    cell.labelTag.text = lableTagArr[indexPath.row];
    cell.detialLab.hidden = YES;
    [self customCell:cell withBgView:cell.backView forRowAtIndexPath:indexPath];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

#pragma mark - 咨询方式及时间cell
- (void)customCell:(UITableViewCell *)cell withBgView:(UIView *)view forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        
        NSArray *btnTitle                        = @[@"面对面咨询",@"文字语音视频",@"电话咨询"];
        for (int i                               = 0; i < 3; i++) {
            UIButton *btn                            = [GQControls createButtonWithFrame:CGRectMake(10+SCREEN_W/3*i, 10, SCREEN_W/3-20, 30) andTitle:btnTitle[i] andTitleColor:MAINCOLOR andFontSize:15 andTag:i*10+1 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
            btn.backgroundColor                      = [UIColor whiteColor];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(clickChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
        }
        
        if (!_orderModel.consultType) {
            _orderModel.consultType = 11;
        }
        UIButton *defBtn                         = [view viewWithTag:_orderModel.consultType];
        _mapBtn                                  = [[UIButton alloc]init];
        _mapBtn.frame                            = CGRectMake(10, defBtn.bottom+10, SCREEN_W-20, 50);
        _mapBtn.titleLabel.font                  = [UIFont systemFontOfSize:15];
        _mapBtn.titleLabel.numberOfLines         = 0;
//        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:@"预约成功后可直接在订单页面与咨询师取得联系，详情请咨询乐天客服"];
//        [_mapBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
        _mapBtn.userInteractionEnabled = NO;
        [view addSubview:_mapBtn];
        
        [self clickChoiceBtn:defBtn];
        
        [self setupCalendarWithBGView:view];
        [self creatTimeChoicesViewWithBGView:view];
        
    } else {
        
        [self inputInfoWithBackView:view];
        if (_orderModel.orderInfoName) {
            _nameTextField.enableAnimation = NO;
            _nameTextField.text = _orderModel.orderInfoName;
        }
        if (_orderModel.orderInfoSex) {
            _sexTextField.enableAnimation = NO;
            _sexTextField.text = _orderModel.orderInfoSex;
        }
        if (_orderModel.orderInfoAge) {
            _ageTextField.enableAnimation = NO;
            _ageTextField.text = [NSString stringWithFormat:@"%ld",(long)_orderModel.orderInfoAge];
        }
        if (_orderModel.orderInfoPhone) {
            _phoneTextField.enableAnimation = NO;
            _phoneTextField.text = _orderModel.orderInfoPhone;
        }
        if (_orderModel.orderInfoEmail) {
            _emailTextField.enableAnimation = NO;
            _emailTextField.text = _orderModel.orderInfoEmail;
        }
        if (_orderModel.orderInfoDetail) {
            _detailTextView.text = _orderModel.orderInfoDetail;
            _placeholderLabel.hidden = YES;
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        CGFloat height = _timeChoicesView.bottom + 30;
        return height;
    } else {
        return _detailTextView.bottom + 140;
    }
}

#pragma mark 点击咨询方式选择按钮
- (void)clickChoiceBtn:(UIButton *)btn {
    
    [self animationbegin:btn];
    for (int i              = 0; i < 3; i++) {
        UIButton *btnn          = [self.view viewWithTag:i*10+1];
        btnn.selected           = NO;
        btnn.backgroundColor    = [UIColor whiteColor];
        btnn.userInteractionEnabled = YES;

    }
    
    btn.selected            = YES;
    btn.backgroundColor     = MAINCOLOR;
    _orderModel.consultType = btn.tag;
    
    if (btn.tag == 1) {
        
        _mapBtn.userInteractionEnabled = YES;
        //EAP通道
        if (self.counselModel.UserID == 313) {
            NSString *str = @"面对面咨询地点：上海市浦东新区祖冲之路555号1号楼1楼郁金香厅";
            [_mapBtn setTitle:str forState:UIControlStateNormal];
            [_mapBtn addTarget:self action:@selector(clickMapBtn:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            NSString *str = @"面对面咨询地点：上海市徐汇区中山西路2240号鼎力创意园B401室";
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
            [attrStr addAttribute:NSForegroundColorAttributeName value:MAINCOLOR range:NSMakeRange(8, 25)];
            [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 25)];
            [_mapBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
            [_mapBtn addTarget:self action:@selector(clickMapBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    } else if (btn.tag == 11) {
        
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:@"预约成功后可直接在订单页面与咨询师取得联系，详情请咨询乐天客服"];
        [_mapBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
//        [_mapBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        _mapBtn.userInteractionEnabled = NO;
        
//        if (!NULLString(_priceLab.text)) {
//            _orderModel.orderPrice = _totalPrice;
//            [_priceLab setText:[NSString stringWithFormat:@"%.2f 元",_orderModel.orderPrice]];
//        }

    } else {
        
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:@"电话咨询请致电乐天客服：021-37702979"];
        [_mapBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
        _mapBtn.userInteractionEnabled = NO;

//        if (!NULLString(_priceLab.text)) {
//            _orderModel.orderPrice = _totalPrice;
//            [_priceLab setText:[NSString stringWithFormat:@"%.2f 元",_orderModel.orderPrice]];
//        }

    }
//    NSLog(@"咨询方式：%ld",(long)_orderModel.consultType);
    btn.userInteractionEnabled = NO;
    [self reflashInfo];
}

#pragma mark 点击地图按钮
- (void)clickMapBtn:(UIButton *)btn {
    
    [self animationbegin:btn];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf   = self;
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"复制地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        __strong typeof(self) strongself = weakSelf;
        [UIPasteboard generalPasteboard].string = @"上海市徐汇区中山西路2240号鼎力创意园B401室";
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
        
        if (!_orderModel.orderDate) {
            [self compareDate:date];
        } else {
            calendar.appearance.todayColor = [UIColor whiteColor];
            calendar.appearance.titleTodayColor = MAINCOLOR;
            [calendar selectDate:_orderModel.selDate];
            [self compareDate:_orderModel.selDate];
        }
        return @"今";
    }
    return nil;
}

#pragma mark 点击日历方法
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    //改变图标
    calendar.appearance.todayColor      = [UIColor whiteColor];
    calendar.appearance.titleTodayColor = MAINCOLOR;

    [self compareDate:date];
    
    [_startBtn setTitle:@"预约开始时间" forState:UIControlStateNormal];
    _orderModel.orderDateTimeStart      = nil;
    [_endBtn setTitle:@"预约结束时间" forState:UIControlStateNormal];
    _orderModel.orderDateTimeEnd        = nil;
    [self reflashInfo];
    
}

#pragma mark 比较时间
- (void)compareDate:(NSDate *)date {
    
    NSString *todayStr                  = [self.dateFormatter stringFromDate:[NSDate new]];
    NSString *selDateStr                = [self.dateFormatter stringFromDate:date];
    NSDate *todayDate                   = [self.dateFormatter dateFromString:todayStr];
    NSDate *selDate                     = [self.dateFormatter dateFromString:selDateStr];

    _orderModel.selDate                 = date;
    _orderModel.orderDate               = selDateStr;
    
    NSComparisonResult result           = [selDate compare:todayDate];
    if (result == NSOrderedAscending) {
        _isToday = NO;
        [_timeChoicesView removeAllSubviews];
        [_timeChoicesView addSubview:_dateDisplayLab];
        _dateDisplayLab.text = @"不可以穿越到过去预约哦";
        _orderModel.orderDate = nil;
        
    } else if (result == NSOrderedSame) {
        _isToday = YES;
        [self getCounsultSetForDay:selDateStr];
        
    } else {
        _isToday = NO;
        [self getCounsultSetForDay:selDateStr];
    }
}

#pragma mark 预约时间View
- (void)creatTimeChoicesViewWithBGView:(UIView *)view {
    
    _timeChoicesView = [[UIView alloc]initWithFrame:CGRectMake(30, _calendar.bottom+10, SCREEN_W-60, 120)];
    [view addSubview:_timeChoicesView];
    
    _dateDisplayLab                 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _timeChoicesView.width, _timeChoicesView.height)];
    _dateDisplayLab.textColor       = MAINCOLOR;
    _dateDisplayLab.textAlignment   = 1;
    _dateDisplayLab.font            = [UIFont systemFontOfSize:20];
    _dateDisplayLab.backgroundColor = [UIColor whiteColor];

    _consultSetLab = [[UILabel alloc]initWithFrame:CGRectMake(_timeChoicesView.width*0.1, 5, _timeChoicesView.width*0.8, 30)];
    [_timeChoicesView addSubview:_consultSetLab];
    _consultSetLab.textColor = MAINCOLOR;
    _consultSetLab.font = [UIFont systemFontOfSize:15];
    _consultSetLab.textAlignment = NSTextAlignmentCenter;
    
    _startBtn = [GQControls createButtonWithFrame:CGRectMake(_timeChoicesView.width*0.1, 45, _timeChoicesView.width*0.8, 30) andTitle:@"预约开始时间" andTitleColor:MAINCOLOR andFontSize:15 andTag:102 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
    _startBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _startBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (_orderModel.orderDateTimeStart) {
        [_startBtn setTitle:[NSString stringWithFormat:@"%@ %@",_orderModel.orderDate,_orderModel.orderDateTimeStart] forState:UIControlStateNormal];
    }
    
    _endBtn = [GQControls createButtonWithFrame:CGRectMake(_timeChoicesView.width*0.1, 85, _timeChoicesView.width*0.8, 30) andTitle:@"预约结束时间" andTitleColor:MAINCOLOR andFontSize:15 andTag:103 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
    _endBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _endBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (_orderModel.orderDateTimeEnd) {
//        [_endBtn setTitle:[NSString stringWithFormat:@"%@ 小时",_hourStr] forState:UIControlStateNormal];
        [_endBtn setTitle:[NSString stringWithFormat:@"%@ %@",_orderModel.orderDate,_orderModel.orderDateTimeEnd] forState:UIControlStateNormal];

    }
    
    [_startBtn addTarget:self action:@selector(clickTimeChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_endBtn addTarget:self action:@selector(clickTimeChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_timeChoicesView addSubview:_startBtn];
    [_timeChoicesView addSubview:_endBtn];
    
}

#pragma mark 选择时间方法
- (void)clickTimeChoiceBtn:(UIButton *)btn {
    
    [self animationbegin:btn];
    self.sl_popupController                          = [SnailPopupController new];
    self.sl_popupController.layoutType               = PopupLayoutTypeCenter;
    self.sl_popupController.maskType                 = PopupMaskTypeWhiteBlur;
    self.sl_popupController.transitStyle             = PopupTransitStyleSlightScale;
    self.sl_popupController.dismissOnMaskTouched = NO;
    if (btn == _startBtn) {
        
        _startBtn.selected = YES;
        _endBtn.selected = NO;
        [_endBtn setTitle:@"预约结束时间" forState:0];
        _orderModel.orderDateTimeEnd = nil;
        UIView *view = [self setupDatePiker];
        [self.sl_popupController presentContentView:view];
        [self ios11Bug:view];
    } else if (btn == _endBtn) {
        
        _startBtn.selected = NO;
        _endBtn.selected = YES;
        if ([_startBtn.titleLabel.text isEqual: @"预约开始时间"]) {
            [MBHudSet showText:@"请确认预约时间" andOnView:self.view];
        } else {
            UIView *view = [self setupDatePiker];
            [self.sl_popupController presentContentView:view];
            [self ios11Bug:view];
        }
    }
    [self reflashInfo];
}

- (void)ios11Bug:(UIView *)view {
    
    UIView *tooView = view.superview.superview;
    [tooView layoutIfNeeded];
    NSArray *subViewArray = tooView.subviews;
    for (id sView in subViewArray) {
        if ([sView isKindOfClass:(NSClassFromString(@"_UIToolbarContentView"))]) {
            UIView *testView = sView;
            testView.userInteractionEnabled = NO;
        }
    }
}

#pragma mark 选择时间pick
- (UIView *)setupDatePiker {
    
    UIView *backView           = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    _timePicker                = [[UIDatePicker alloc]init];
    [backView addSubview:_timePicker];
    _timePicker.center = self.view.center;
    _timePicker.datePickerMode = UIDatePickerModeTime;
    _timePicker.minuteInterval = 15;

    UIButton *btn = [GQControls createButtonWithFrame:CGRectMake(SCREEN_W/4, _timePicker.bottom+5, SCREEN_W/2, 30) andTitle:@"确定" andTitleColor:MAINCOLOR andFontSize:15 andTag:233 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
    [backView addSubview:btn];
    [btn addTarget:self action:@selector(clickAffirmTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableString *selDateStartStr  = [NSMutableString new];
    if (_endBtn.selected) {
        selDateStartStr  = [NSMutableString stringWithFormat:@"%@ %@", _orderModel.orderDate,_orderModel.orderDateTimeStart];
        NSLog(@"点结束");
    } else {
        selDateStartStr  = [NSMutableString stringWithFormat:@"%@ %@", _orderModel.orderDate,_customTimeStartStr];
    }
    
//    NSMutableString *selDateStartStr  = [NSMutableString stringWithFormat:@"%@ %@", _orderModel.orderDate,_customTimeStartStr];
    NSMutableString *selDateEndStr    = [NSMutableString stringWithFormat:@"%@ %@", _orderModel.orderDate,_customTimeEndStr];
    NSDateFormatter *selDateFormatter = [[NSDateFormatter alloc]init];
    [selDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //真机运行需要设置Local
    NSLocale *locale                  = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [selDateFormatter setLocale:locale];
    NSDate *selDateStart              = [selDateFormatter dateFromString:selDateStartStr];
    NSDate *selDateEnd                = [selDateFormatter dateFromString:selDateEndStr];
    NSDate *endDate = [NSDate dateWithTimeInterval:- 60 * 60 sinceDate:selDateEnd];

    UILabel *dateLab      = [[UILabel alloc]init];
    [backView addSubview:dateLab];
    dateLab.x             = 0;
    dateLab.bottom        = _timePicker.top - 40;
    dateLab.width         = SCREEN_W;
    dateLab.height        = _startBtn.height;
    dateLab.text          = _orderModel.orderDate;
    dateLab.textAlignment = NSTextAlignmentCenter;
    dateLab.font          = [UIFont systemFontOfSize:30];

    if (_isToday == YES && _startBtn.selected) {
        [_timePicker setMinimumDate:[NSDate new]];
        [_timePicker setMaximumDate:endDate];
    } else {
        [_timePicker setMinimumDate:selDateStart];
        [_timePicker setMaximumDate:endDate];
    }
    
    return backView;
}

- (void)clickAffirmTimeBtn:(UIButton *)btn {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *selTimeStr = [dateFormatter stringFromDate:_timePicker.date];
    
    [self animationbegin:btn];
    if ([selTimeStr containsString:@":00"] || [selTimeStr containsString:@":30"] || [selTimeStr containsString:@":15"] || [selTimeStr containsString:@":45"]) {
        if (_startBtn.selected) {
            _orderModel.orderDateTimeStart = selTimeStr;
            [_startBtn setTitle:[NSString stringWithFormat:@"%@ %@",_orderModel.orderDate,_orderModel.orderDateTimeStart] forState:UIControlStateNormal];
            [self.sl_popupController dismiss];

        } else if (selTimeStr != _orderModel.orderDateTimeStart) {
            
            
            _orderModel.orderDateTimeEnd = selTimeStr;
            [_endBtn setTitle:[NSString stringWithFormat:@"%@ %@",_orderModel.orderDate,_orderModel.orderDateTimeEnd] forState:UIControlStateNormal];

            NSTimeInterval timeInterval = [[dateFormatter dateFromString:_orderModel.orderDateTimeEnd] timeIntervalSinceDate:[dateFormatter dateFromString:_orderModel.orderDateTimeStart]];
//            NSLog(@"起始:%@,结束:%@,min:%f",_orderModel.orderDateTimeStart,[dateFormatter dateFromString:_orderModel.orderDateTimeEnd],timeInterval/60/60);

            if (timeInterval/3600 > self.counselModel.ConsultPreferDateLength) {

                _orderModel.orderPrice = timeInterval/3600 * self.counselModel.ConsultFee * self.counselModel.ConsultDisCount;
            } else {
                _orderModel.orderPrice = timeInterval/3600 * self.counselModel.ConsultFee;
            }
            [_priceLab setText:[NSString stringWithFormat:@"%.2f 元",_orderModel.orderPrice]];
            
            [self reflashInfo];
            [self.sl_popupController dismiss];

        } else {
            [MBHudSet showText:@"请选择正确的时间" andOnView:btn.superview];
        }
    } else {
        [MBHudSet showText:@"请选择正确的时间" andOnView:btn.superview];
        
    }
}

#pragma mark 选择小时pick
//- (UIView *)setupChooseHoursView {
//
//    NSRange rag = {0,2};
//    int startHour = [[_orderModel.orderDateTimeStart substringWithRange:rag] intValue];
//    int endHour = [[self.customTimeEndStr substringWithRange:rag] intValue];
//
//    [_hoursData removeAllObjects];
//    for (int i = 0; i < (endHour - startHour); i++) {
//        [_hoursData addObject:[NSString stringWithFormat:@"%d",i+1]];
//    }
//    _hourStr = _hoursData[0];
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H/4, SCREEN_W, SCREEN_H*0.4)];
//    _chooseHoursView = [[UIPickerView alloc]initWithFrame:CGRectMake(SCREEN_W*0.3, 0, SCREEN_W*0.4, backView.height*0.7)];
//    [backView addSubview:_chooseHoursView];
//    _chooseHoursView.dataSource = self;
//    _chooseHoursView.delegate = self;
//
//    UIButton *btn = [GQControls createButtonWithFrame:CGRectMake(SCREEN_W/4, _chooseHoursView.bottom+10, SCREEN_W/2, 30) andTitle:@"确定" andTitleColor:MAINCOLOR andFontSize:15 andTag:234 andMaskToBounds:YES andRadius:5 andBorderWidth:0.5 andBorderColor:(MAINCOLOR.CGColor)];
//    [backView addSubview:btn];
//    [btn addTarget:self action:@selector(clickAffirmHoursBtn:) forControlEvents:UIControlEventTouchUpInside];
//
//    _hoursPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/4, btn.bottom+10, SCREEN_W/2, 30)];
//    [backView addSubview:_hoursPriceLab];
//    _hoursPriceLab.adjustsFontSizeToFitWidth = YES;
//    _hoursPriceLab.textColor = MAINCOLOR;
//    _hoursPriceLab.text = [NSString stringWithFormat:@"%ld元／小时",self.counselModel.ConsultFee];
//    _hoursPriceLab.textAlignment = NSTextAlignmentCenter;
//    _hoursPriceLab.font = [UIFont boldSystemFontOfSize:15];
//
//    return backView;
//}
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 2;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if (component == 0) {
//        return _hoursData.count;
//    }
//    return 1;
//}
//
//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (component == 0) {
//        return _hoursData[row];
//    }
//    return @"小时";
//}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//
//    _hourStr = _hoursData[row];
//    if ([_hourStr intValue] > self.counselModel.ConsultPreferDateLength) {
//
//        _orderModel.orderPrice = [_hourStr integerValue] * self.counselModel.ConsultFee * self.counselModel.ConsultDisCount;
//    } else {
//        _orderModel.orderPrice = [_hourStr integerValue] * self.counselModel.ConsultFee;
//    }
//    [_hoursPriceLab setText:[NSString stringWithFormat:@"%.2f 元",_orderModel.orderPrice]];
//}

//- (void)clickAffirmHoursBtn:(UIButton *)btn {
//
//    [self animationbegin:btn];
//
//    [_endBtn setTitle:[NSString stringWithFormat:@"%@ 小时",_hourStr] forState:UIControlStateNormal];
//    if ([_hourStr intValue] > self.counselModel.ConsultPreferDateLength) {
//
//        _orderModel.orderPrice = [_hourStr integerValue] * self.counselModel.ConsultFee * self.counselModel.ConsultDisCount;
//    } else {
//        _orderModel.orderPrice = [_hourStr integerValue] * self.counselModel.ConsultFee;
//    }
//    [_priceLab setText:[NSString stringWithFormat:@"%.2f 元",_orderModel.orderPrice]];
//
//    NSRange rag = {0,2};
//    NSInteger startTime = [[_orderModel.orderDateTimeStart substringWithRange:rag] integerValue];
//    NSInteger endTime = startTime + [_hourStr integerValue];
//    NSString *endStr = [_orderModel.orderDateTimeStart stringByReplacingCharactersInRange:rag withString:[NSString stringWithFormat:@"%ld",(long)endTime]];
//    _orderModel.orderDateTimeEnd = endStr;
//
//    [self reflashInfo];
//    [self.sl_popupController dismiss];
//}

#pragma mark - 获取咨询师设置
- (void)getCounsultSetForDay:(NSString *)dayStr {
    
    __weak typeof(self) weakSelf = self;
    [MBHudSet showStatusOnView:self.view];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_DOCTORSET];
    [requestString appendFormat:@"%@",API_NAME_GETCONSULTSETFORDAY];
    
    NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
    parames[@"date"] = dayStr;
    parames[@"userID"] = @(self.counselModel.UserID);
//    NSLog(@"咨询师ID：%ld",(long)self.counselModel.UserID)
    
    [PPNetworkHelper setValue:kFetchToken forHTTPHeaderField:@"token"];
//    NSLog(@"token:%@",kFetchToken);
    [PPNetworkHelper GET:requestString parameters:parames success:^(id responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        [MBHudSet dismiss:strongSelf.view];
        
//        NSLog(@"获取咨询时间返回的数据%@",responseObject);
        
        if([responseObject[@"Code"] integerValue] == 200) {
            
            strongSelf.getInfoModel = [ConsultDateModel mj_objectWithKeyValues:responseObject[@"Result"][@"Source"]];
            if ([strongSelf.getInfoModel.IsEnableConsult isEqualToString:@"1"]) {
                
                [strongSelf.timeChoicesView removeAllSubviews];
                [strongSelf.timeChoicesView addSubview:strongSelf.consultSetLab];
                [strongSelf.timeChoicesView addSubview:strongSelf.startBtn];
                [strongSelf.timeChoicesView addSubview:strongSelf.endBtn];
                
                if (strongSelf.getInfoModel.ConsultTimeList != nil && ![strongSelf.getInfoModel.ConsultTimeList isKindOfClass:[NSNull class]] && strongSelf.getInfoModel.ConsultTimeList.count != 0) {
                    
//                    NSLog(@"%@",strongSelf.getInfoModel.ConsultTimeList[0]);
                    NSDictionary *set = (NSDictionary *)strongSelf.getInfoModel.ConsultTimeList[0];
//                    NSLog(@"%@",set[@"StartTime"]);
                    
                    NSRange rag = {5,3};
                    strongSelf.customTimeStartStr = [set[@"StartTime"] stringByReplacingCharactersInRange:rag withString:@""];
                    strongSelf.customTimeEndStr = [set[@"EndTime"] stringByReplacingCharactersInRange:rag withString:@""];
                    
                    NSMutableString *setStr = [[NSMutableString alloc]initWithString:@"当日可预约时间："];
                    [setStr appendFormat:@" %@ ",strongSelf.customTimeStartStr];
                    [setStr appendFormat:@"- %@",strongSelf.customTimeEndStr];
                    strongSelf.consultSetLab.text = setStr;
                    [strongSelf.consultSetLab sizeToFit];
                    strongSelf.consultSetLab.centerX = strongSelf.startBtn.centerX;

                } else {
                    
//                    NSLog(@"空空空");
                    

                }

            } else {
                
                [strongSelf.timeChoicesView removeAllSubviews];
                [strongSelf.timeChoicesView addSubview:_dateDisplayLab];
                strongSelf.dateDisplayLab.text = @"今天不可以预约哦";
//                NSLog(@"%@",strongSelf.dateDisplayLab.text);
            }
        }
        
    } failure:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        
        [MBHudSet dismiss:strongSelf.view];
        [MBHudSet showText:[NSString stringWithFormat:@"获取咨询师订单列表错误，错误代码：%ld",(long)error.code]andOnView:strongSelf.view];
    }];
    
    
}


#pragma mark - 输入个人信息cell
- (void)inputInfoWithBackView:(UIView *)bgView {
    
    //点击空白收键盘
    UITapGestureRecognizer *tap           = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [bgView addGestureRecognizer:tap];
    tap.delegate                          = self;
    
    _nameTextField = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, 30, SCREEN_W*0.7, 30) labelHeight:15];
    [bgView addSubview:_nameTextField];
    _nameTextField.delegate                = self;
    _nameTextField.placeholder             = @"姓名";
    _nameTextField.placeholderActiveColor  = MAINCOLOR;
    _nameTextField.clearButtonMode         = UITextFieldViewModeWhileEditing;
    
    _sexTextField = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, _nameTextField.y + 60, SCREEN_W*0.7, 30) labelHeight:15];
    [bgView addSubview:_sexTextField];
    _sexTextField.placeholder = @"性别";
    _sexTextField.userInteractionEnabled = NO;
    UIButton *sexBtn = [UIButton new];
//    sexBtn.backgroundColor = MAINCOLOR;
    sexBtn.frame = _sexTextField.frame;
    [bgView addSubview:sexBtn];
    [sexBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    _ageTextField             = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, _sexTextField.y + 60, SCREEN_W*0.7, 30) labelHeight:15];
    [bgView addSubview:_ageTextField];
    _ageTextField.clearButtonMode          = UITextFieldViewModeWhileEditing;
    _ageTextField.delegate                 = self;
    _ageTextField.placeholder              = @"年龄";
    _ageTextField.placeholderActiveColor   = MAINCOLOR;
    _ageTextField.keyboardType             = UIKeyboardTypeNumberPad;
    
    _phoneTextField           = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, _ageTextField.y + 60, SCREEN_W*0.7, 30) labelHeight:15 style:LRTextFieldStylePhone];
    [bgView addSubview:_phoneTextField];
    _phoneTextField.clearButtonMode        = UITextFieldViewModeWhileEditing;
    _phoneTextField.delegate               = self;
    _phoneTextField.placeholder            = @"电话";
    _phoneTextField.placeholderActiveColor = MAINCOLOR;
    
    _emailTextField           = [[LRTextField alloc] initWithFrame:CGRectMake(SCREEN_W*0.15, _phoneTextField.y + 60, SCREEN_W*0.7, 30) labelHeight:15 style:LRTextFieldStyleEmail];
    [bgView addSubview:_emailTextField];
    _emailTextField.clearButtonMode        = UITextFieldViewModeWhileEditing;
    _emailTextField.delegate               = self;
    _emailTextField.placeholder            = @"邮箱*";
    _emailTextField.placeholderActiveColor = MAINCOLOR;
    _emailTextField.hintText               = @"*选填";
    _emailTextField.hintTextColor          = [UIColor blackColor];

    _detailTextView                        = [[UITextView alloc]initWithFrame:CGRectMake(SCREEN_W*0.15, _emailTextField.y + 60 , SCREEN_W*0.7, 80)];
    _detailTextView.delegate               = self;
    _detailTextView.font                   = [UIFont systemFontOfSize:17];
    _placeholderLabel                      = [GQControls createLabelWithFrame:CGRectMake(5, 10, 200, 20) andText:@"请简述您的咨询内容*" andTextColor:[UIColor lightGrayColor] andFontSize:17];
    //EAP通道
    if (self.counselModel.UserID == 313) {
        _placeholderLabel.text = @"请输入身份证后四位数";
    }
    [_detailTextView addSubview:_placeholderLabel];
    _detailTextView.layer.masksToBounds    = YES;
    _detailTextView.layer.cornerRadius     = 5;
    _detailTextView.layer.borderWidth      = 0.7;
    _detailTextView.layer.borderColor      = [[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] CGColor];
    [bgView addSubview:_detailTextView];
    
    _doSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_W*0.15, _detailTextView.y + 95, 15, 15)];
//    _doBtn.layer.borderColor                     = [UIColor lightGrayColor].CGColor;
//    _doBtn.layer.borderWidth                     = 1;
//    _doBtn.layer.cornerRadius                    = 7;
    [bgView addSubview:_doSwitch];
    _doSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    _doSwitch.onTintColor = MAINCOLOR;

//    [_doBtn setImage:[UIImage imageNamed:@"do"] forState:UIControlStateSelected];
    [_doSwitch addTarget:self action:@selector(clickDoSwitch:) forControlEvents:UIControlEventValueChanged];
    
    UIButton *agreementBtn = [[UIButton alloc]initWithFrame:CGRectMake(_doSwitch.right+8, _detailTextView.y + 95, _detailTextView.width, 15)];
    [bgView addSubview:agreementBtn];
//    agreementBtn.backgroundColor = [UIColor snowColor];
    NSString *str = @"同意《心理咨询知情同意书》";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:MAINCOLOR range:NSMakeRange(2, 11)];
    [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(2, 11)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0,13)];
    [agreementBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [agreementBtn sizeToFit];
    
    [agreementBtn addTarget:self action:@selector(clickAgBtn:) forControlEvents:UIControlEventTouchUpInside];
    

    
}

- (void)sexBtnClick:(UIButton *)btn {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"性别" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _sexTextField.text = @"男";
        _orderModel.orderInfoSex = @"男";
        _sexTextField.enableAnimation = NO;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _sexTextField.text = @"女";
        _orderModel.orderInfoSex = @"女";
        _sexTextField.enableAnimation = NO;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _placeholderLabel.hidden = NO;
    } else {
        _placeholderLabel.hidden = YES;
    }
    return YES;
}

#pragma mark 结束编辑
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    _nameTextField.enableAnimation = YES;
    _ageTextField.enableAnimation = YES;
    _phoneTextField.enableAnimation = YES;
    _emailTextField.enableAnimation = YES;
//    _sexTextField.enableAnimation = YES;
    
    _orderModel.orderInfoName  = _nameTextField.text;
    _orderModel.orderInfoAge   = [_ageTextField.text integerValue];
    _orderModel.orderInfoPhone = [_phoneTextField.text removeAllSpace];
    _orderModel.orderInfoEmail = _emailTextField.text;
    
//    NSLog(@"电话：%@ 长度:%d",_orderModel.orderInfoPhone,_orderModel.orderInfoPhone.length);

    [self reflashInfo];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    _orderModel.orderInfoDetail = _detailTextView.text;
    [self reflashInfo];
    return YES;
}

#pragma mark textField限制长度
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

#pragma mark textView限制长度
- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text length] > 60) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 60)];
        [textView.undoManager removeAllActions];
        [textView becomeFirstResponder];
        return;
    } else if ([textView.text isEqualToString:@""]) {
        _placeholderLabel.hidden = NO;
    }

}

#pragma mark 键盘处理
- (void)configKeyBoardRespond {
    __weak ConfirmPageVC *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.mainTableView, nil];
    }];
}

- (void)hideKeyboard {
//    [self.view endEditing:YES];
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)clickDoSwitch:(UISwitch *)doSwitch {
    
    [self reflashInfo];
}

- (void)clickAgBtn:(UIButton *)btn {
    
    AgreementVC *aVC = [[AgreementVC alloc]init];
    [self.navigationController pushViewController:aVC animated:YES];
    
}

#pragma mark - 底部TabBar
- (void)creatBottomBar {
    
    _tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, SCREEN_H - TAB_BAR_HEIGHT, SCREEN_W, tabBar_H)];
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
        make.height.equalTo(_confirmBtn.mas_height);
    }];
    _priceLab.textColor = MAINCOLOR;
    _priceLab.text = [NSString stringWithFormat:@"%ld元／小时",self.counselModel.ConsultFee];
    _priceLab.textAlignment = NSTextAlignmentRight;
    _priceLab.font = [UIFont boldSystemFontOfSize:15];
    //优惠lable
    UILabel *couponLab                 = [[UILabel alloc]init];
    [_tabBar addSubview:couponLab];
    [couponLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_priceLab.mas_right);
        make.bottom.equalTo(_priceLab.mas_bottom);
        make.width.equalTo(_priceLab.mas_width);
        make.height.equalTo(_priceLab.mas_height).multipliedBy(0.5);
    }];
    couponLab.text                     = [NSString stringWithFormat:@"%@",self.counselModel.ConsultTag];
    couponLab.textColor                = [UIColor orangeColor];
    couponLab.textAlignment            = NSTextAlignmentRight;
    couponLab.font                     = [UIFont boldSystemFontOfSize:10];
    //EAP通道
    if (self.counselModel.ConsultDisCount == 1) {
        couponLab.hidden = YES;
    }
    
}

#pragma mark 刷新信息
- (void)reflashInfo {
    
    if (NULLString(_orderModel.orderDateTimeStart) ||  NULLString(_orderModel.orderDateTimeEnd) || NULLString(_nameTextField.text) ||  NULLString(_sexTextField.text) ||  NULLString(_ageTextField.text) || NULLString(_phoneTextField.text) || !_doSwitch.isOn) {
        self.confirmBtn.backgroundColor = [UIColor lightGrayColor];
        
    } else if (self.counselModel.UserID == 313 && NULLString(_detailTextView.text)) {
        self.confirmBtn.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.confirmBtn.backgroundColor = MAINCOLOR;
    }
    
    if (NULLString(_orderModel.orderDateTimeStart) || NULLString(_orderModel.orderDateTimeEnd)) {
        _priceLab.text = [NSString stringWithFormat:@"%ld元／小时",self.counselModel.ConsultFee];
//        _orderModel.orderPrice = _totalPrice;
    }
    
}

- (void)clickConfirmBtn {
//    NSLog(@"确认预约");
    
    if (_confirmBtn.backgroundColor == [UIColor lightGrayColor]) {

        [MBHudSet showText:@"请完善预约信息" andOnView:self.view];
        _mainTableView.contentOffset = CGPointMake(0, SCREEN_H/2);
    } else {
    
        [MBHudSet showStatusOnView:self.view];

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
        params[@"TotalFee"]            = @(_orderModel.orderPrice);
        params[@"ConSultName"]         = _orderModel.orderInfoName;
        if ([_orderModel.orderInfoSex isEqualToString:@"男"]) {
            params[@"EnumSexType"] = @(0);
        } else if ([_orderModel.orderInfoSex isEqualToString:@"女"]) {
            params[@"EnumSexType"] = @(1);
        }
        params[@"ConsultAge"] = @(_orderModel.orderInfoAge);
        params[@"ConsultPhone"] = _orderModel.orderInfoPhone;
//        NSLog(@"电话：%@ 长度:@d",_orderModel.orderInfoPhone,_orderModel.orderInfoPhone.length);
        if (_emailTextField.text) {
            params[@"ConsultEmail"] = _orderModel.orderInfoEmail;
        }
        if (_detailTextView.text) {
            params[@"ConsultDescription"] = self.detailTextView.text;
        }
        [PPNetworkHelper setValue:kFetchToken forHTTPHeaderField:@"token"];
        [PPNetworkHelper POST:requestString parameters:params success:^(id responseObject) {
            
            __strong typeof(self) strongSelf = weakSelf;
            [MBHudSet dismiss:strongSelf.view];
            
            if([responseObject[@"Code"] integerValue] == 200) {
                
                [MBHudSet showText:@"下单成功" andOnView:strongSelf.view];
                PayPageVC *payPage = [[PayPageVC alloc]init];
                payPage.orderID = [responseObject[@"Result"][@"Source"][@"OrderID"] integerValue];
                payPage.orderNo = responseObject[@"Result"][@"Source"][@"OrderNo"];
                payPage.orderTypeString = responseObject[@"Result"][@"Source"][@"ConsultTypeIDString"];
                payPage.consultorName = strongSelf.orderModel.conserlorName;
                payPage.totalFee = [responseObject[@"Result"][@"Source"][@"TotalFee"] floatValue];
                //EAP通道
                if (self.counselModel.UserID == 313) {
                    OrderViewController *orderVc = [[OrderViewController alloc] init];
                    orderVc.orderState = 1;
                    [strongSelf.navigationController pushViewController:orderVc animated:YES];
                    return;
                } else {
                    [strongSelf.navigationController pushViewController:payPage animated:YES];
                }
            }else{
                [MBHudSet showText:responseObject[@"Msg"] andOnView:strongSelf.view];
            }
        } failure:^(NSError *error) {
            
            __strong typeof(self) strongSelf = weakSelf;
            [MBHudSet dismiss:strongSelf.view];
            if (error.code == NSURLErrorCancelled) return;
            if (error.code == NSURLErrorTimedOut) {
                [MBHudSet showText:@"请求超时" andOnView:strongSelf.view];
            } else{
                [MBHudSet showText:@"请求失败" andOnView:strongSelf.view];
            }
        }];
    }
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
