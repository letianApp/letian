//
//  UserInfoViewController.m
//  letian
//
//  Created by 郭茜 on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "UserInfoViewController.h"
#import "BDImagePicker.h"
#import "UIImageView+WebCache.h"
#import "UIImage+YYExtension.h"
#import "MJExtension.h"
#import <RongIMKit/RongIMKit.h>
#import "GQDatePickView.h"


@interface UserInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *sexLabel;
@property (nonatomic,strong)UILabel *birthdayLabel;
@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong)UILabel *companyLabel;
@property (nonatomic,strong)UIButton *getCodeBtn;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,copy)NSString *inputPhoneStr;
@property (nonatomic,strong) NSArray *comListArr;
@property (nonatomic,strong) UIView *comPickBgView;
@property (nonatomic,strong) UIPickerView *pickView;
@property (nonatomic,assign) NSInteger selRow;


@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.time=60;
    
    self.dataArray=@[@"头像",@"昵称",@"性别",@"生日",@"所属单位"];
    self.comListArr = [[NSArray alloc]init];
    
    [self createTableView];
    [self requestData];
    [self setUpNavigationBar];
}


#pragma mark------创建tableview

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled=NO;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark--------TableViewDelegate----------

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 9, SCREEN_W, 1)];
        lineView.backgroundColor=[UIColor lightGrayColor];
        [view addSubview:lineView];
        return view;
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_W, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:lineView];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.dataArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark------cell定制

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    UIView *lineView=[[UIView alloc]init];
    if (indexPath.row==0) {
        lineView.frame=CGRectMake(15, 49, SCREEN_W-15, 1);
    }else if (indexPath.row==1){
        lineView.frame=CGRectMake(0, 49, SCREEN_W, 1);
    }
    lineView.backgroundColor=[UIColor lightGrayColor];
    [cell.contentView addSubview:lineView];
    if (indexPath.section==0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text=self.dataArray[indexPath.row];
        lineView.frame=CGRectMake(15, 49, SCREEN_W-15, 1);
        if (indexPath.row==0) {
            //头像
            UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W-80, 5, 40, 40)];
            [headImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.HeadImg] placeholderImage:[UIImage imageNamed:@"headImage"]];
            headImageView.layer.masksToBounds=YES;
            headImageView.layer.cornerRadius=20;
            [cell.contentView addSubview:headImageView];
            self.headImageView=headImageView;
        }else if (indexPath.row==1){
            //昵称
            self.nameLabel=[GQControls createLabelWithFrame:CGRectMake(SCREEN_W-190, 15, 150, 20) andText:self.userInfoModel.NickName andTextColor:[UIColor darkGrayColor] andFontSize:15];
            self.nameLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:self.nameLabel];
        }else if (indexPath.row==2) {
            //性别
            self.sexLabel=[GQControls createLabelWithFrame:CGRectMake(SCREEN_W-190, 15, 150, 20) andText:self.userInfoModel.SexString andTextColor:[UIColor darkGrayColor] andFontSize:15];
            if ([self.userInfoModel.SexString isEqualToString:@"其他"]) {
                self.sexLabel.text=@"";
            }
            self.sexLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:self.sexLabel];
        }else if (indexPath.row==3){
            //生日
//            lineView.frame=CGRectMake(0, 49, SCREEN_W, 1);
            self.birthdayLabel=[GQControls createLabelWithFrame:CGRectMake(SCREEN_W-190, 15, 150, 20) andText:[self.userInfoModel.Birhtday substringToIndex:11] andTextColor:[UIColor darkGrayColor] andFontSize:15];
            self.birthdayLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:self.birthdayLabel];
        } else if (indexPath.row==4) {
            lineView.frame = CGRectMake(0, 49, SCREEN_W, 1);
            NSLog(@"%@",self.userInfoModel.CompanyString);
            self.companyLabel = [GQControls createLabelWithFrame:CGRectMake(SCREEN_W-190, 15, 150, 20) andText:self.userInfoModel.CompanyString andTextColor:[UIColor darkGrayColor] andFontSize:15];
            self.companyLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:self.companyLabel];

        }
    }else if (indexPath.section==1){
        //手机号
        cell.textLabel.text=[NSString stringWithFormat:@"手机号"];
        lineView.frame=CGRectMake(0, 49, SCREEN_W, 1);
        
        self.getCodeBtn=[GQControls createButtonWithFrame:CGRectMake(SCREEN_W-130, 5, 120, 40) andTitle:self.userInfoModel.MobilePhone andTitleColor:[UIColor darkGrayColor] andFontSize:15 andBackgroundColor:[UIColor whiteColor]];
//        [self.getCodeBtn addTarget:self action:@selector(showInputPhoneAlert) forControlEvents:UIControlEventTouchUpInside];
        [self.getCodeBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [cell.contentView addSubview:self.getCodeBtn];
    }
    return cell;
}


#pragma mark------cell点击

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            //上传头像
            [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
                if (image) {
                    [self uploadPhoto:image];
                }
            }];
        }else if (indexPath.row==1){
            //修改昵称
            [self changeNickName];
        }else if (indexPath.row==2){
            //修改性别
            [self changeSex];
        }else if (indexPath.row==3){
            //修改生日
            [self changeBirthday];
        }else if (indexPath.row==4){
            //修改单位
            [self changeCompany];
        }
    }else{
        //绑定手机
        if (self.getCodeBtn.userInteractionEnabled==NO) {
//            [self inputMsgCode];
        }
    }
}


#pragma mark---------上传头像

 -(void)uploadPhoto:(UIImage *)image
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSString *requestString = @"http://image.rightpsy.com/api/Utils/UploadPhoto?enumUpdatePictureType=1";
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    image = [image scaleFromImage:image toSize:CGSizeMake(200 , 200)];
    [MBHudSet showStatusOnView:self.view];
    [manager POST:requestString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData  = UIImageJPEGRepresentation(image, 0.1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
//        NSLog(@"上传头像result%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            [self requestData];
        }else{
            [MBHudSet showText:responseObject[@"Msg"] andOnView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
//            NSLog(@"%@",error);
        }
    }];
}


#pragma mark------------修改昵称

-(void)changeNickName{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改昵称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor blackColor];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"请输入昵称";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestChangeNickName:alertController.textFields[0].text];;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)requestChangeNickName:(NSString *)nickName{
    
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_CHANGENICKNAME];
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"nickName"] = nickName;
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
//        NSLog(@"&&&&&&&&&*修改昵称%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            self.nameLabel.text=nickName;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}


#pragma mark------------修改性别

-(void)changeSex{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改性别" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor blackColor];
    [alertController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestChangeSex:0];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestChangeSex:1];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];
    
}

-(void)requestChangeSex:(NSInteger )sexNum{
    
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_CHANGESEX];
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"enumSexType"]         = @(sexNum);
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            [self requestData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}

#pragma mark------------弹出生日选择器

-(void)changeBirthday{
    
    GQDatePickView *datePickVC = [[GQDatePickView alloc] initWithFrame:self.view.frame];
    datePickVC.date = [NSDate date];
    //日期回调
    datePickVC.completeBlock = ^(NSString *selectDate) {
//        NSLog(@"时间%@",selectDate);
        [self requestChangeBirthday:selectDate];
    };
    //配置属性
    [datePickVC configuration];
    
    [self.view addSubview:datePickVC];
    
}

#pragma mark------------修改生日
-(void)requestChangeBirthday:(NSString *)birthdayStr{
    
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_CHANGEBIRTHDAY];
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"birthday"]         =birthdayStr;
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
//        NSLog(@"修改生日：%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            self.birthdayLabel.text = birthdayStr;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];

}

#pragma mark------------修改单位
- (void)changeCompany {
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_UTILS];
    [requestString appendString:@"GetCompanyList"];
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            _comListArr = responseObject[@"Result"][@"Source"];
            self.selRow = 0;
            [self creatComListPick];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}

- (void)creatComListPick {
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.227 alpha:0.5];
    [self.view addSubview:bgView];
    
    _comPickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 200, SCREEN_W, 200)];
    _comPickBgView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_comPickBgView];
    
    //确定按钮
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(_comPickBgView.bounds.size.width - 50, 0, 40, 30);
    commitBtn.tag = 1;
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(choiceComp) forControlEvents:UIControlEventTouchUpInside];
    [_comPickBgView addSubview:commitBtn];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0, 40, 30);
    cancelBtn.tag = 1;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelChoiceComp) forControlEvents:UIControlEventTouchUpInside];
    [_comPickBgView addSubview:cancelBtn];

    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _comPickBgView.height - 162, SCREEN_W, 162)];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.showsSelectionIndicator = YES;
    
    [_comPickBgView addSubview:_pickView];
    
}

/** 设置组件中每行的标题row:行 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _comListArr[row][@"FullName"];
    
}
/** 当选择某一个列中的某一行的时候会调用该方法 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selRow = row;
}
// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// 返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _comListArr.count;
}

- (void)choiceComp {
    NSLog(@"%@",_comListArr[_selRow][@"ID"]);
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:@"ModifyUserCompanyID"];
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    params[@"companyID"] = _comListArr[_selRow][@"ID"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            UIView *view = _comPickBgView.superview;
            [view removeFromSuperview];
            self.companyLabel.text = _comListArr[_selRow][@"FullName"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];

}

- (void)cancelChoiceComp {
    
    UIView *view = _comPickBgView.superview;
    [view removeFromSuperview];
    
}

#pragma mark------------发送验证码

-(void)sendBindingPhoneMsgCode{
    
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_UTILS];
    [requestString appendFormat:@"%@",API_NAME_SENDMSG];
    __weak typeof(self) weakSelf   = self;
    NSMutableDictionary *params    = [NSMutableDictionary dictionary];
    params[@"authCode"]            =AUTHCODE;
    params[@"phone"]               = self.userInfoModel.MobilePhone;
    params[@"enumSmsType"]         = @(5);
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [MBHudSet dismiss:self.view];
//        NSLog(@"绑定手机发送验证码%@",responseObject);
//        NSLog(@"Msg%@",responseObject[@"Msg"]);
        if([responseObject[@"Code"] integerValue] == 200){
            [weakSelf inputMsgCode];
        }else{
            [MBHudSet showText:responseObject[@"Msg"] andOnView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}

#pragma mark------------输入验证码

-(void)inputMsgCode{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"短信验证" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor blackColor];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"请输入验证码";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self checkMsgCode:alertController.textFields[0].text];;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark--------------验证验证码
- (void)checkMsgCode:(NSString *)msgCode{
    
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_UTILS];
    [requestString appendFormat:@"%@",API_NAME_CHECKCODE];
    NSMutableDictionary *params    = [NSMutableDictionary dictionary];
    params[@"verifyCode"]            =msgCode;
    params[@"phone"]               = self.userInfoModel.MobilePhone;
    params[@"enumSmsType"]         = @(5);
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [MBHudSet dismiss:self.view];
//        NSLog(@"验证短信验证码%@",responseObject);
        if([responseObject[@"Code"] integerValue] == 200){
            [self bindingMoblePhone:self.inputPhoneStr andMsgCode:msgCode];
        }else{
            [MBHudSet showText:responseObject[@"Msg"] andOnView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
    
}



#pragma mark------------输入新手机号

-(void)showInputPhoneAlert{
    
    self.getCodeBtn.userInteractionEnabled = NO;
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)self.time] forState:UIControlStateNormal];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeText) userInfo:nil repeats:YES];
    [self.getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"绑定新号码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor blackColor];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"请输入需要绑定的手机号";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"发送验证码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.inputPhoneStr=alertController.textFields[0].text;
        [self sendBindingPhoneMsgCode];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark------------绑定新手机

- (void)bindingMoblePhone:(NSString *)phone andMsgCode:(NSString *)msgCode{
    
    GQNetworkManager *manager      = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendFormat:@"%@",API_NAME_BINDINGPHONE];
    NSMutableDictionary *params    = [NSMutableDictionary dictionary];
    params[@"VerifyCode"]            =msgCode;
    params[@"Phone"]               = phone;
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [MBHudSet dismiss:self.view];
//        NSLog(@"修改绑定手机%@",responseObject);
        if([responseObject[@"Code"] integerValue] == 200){
            [self.tableView reloadData];
        }else{
            [MBHudSet showText:responseObject[@"Msg"] andOnView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }    }];
    
}


//发送验证码倒计时文字
-(void) changeText
{
    self.time--;
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        self.getCodeBtn.userInteractionEnabled = YES;
        [self.getCodeBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        return;
    }
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)self.time] forState:UIControlStateNormal];
}

#pragma mark------------获取用户信息

-(void)requestData
{
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_GETUSERINFO];
    __weak typeof(self) weakSelf = self;
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBHudSet dismiss:self.view];
//        NSLog(@"&&&&&&&&&*获取用户信息%@",responseObject);
        if ([responseObject[@"Code"] integerValue] == 200 && [responseObject[@"IsSuccess"] boolValue] == YES) {
            weakSelf.userInfoModel=[UserInfoModel mj_objectWithKeyValues:responseObject[@"Result"][@"Source"]];
            self.nameLabel.text=weakSelf.userInfoModel.NickName;
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.HeadImg] placeholderImage:[UIImage imageNamed:@"headImage"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"NickName"] forKey:kUserName];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Result"][@"Source"][@"HeadImg"] forKey:kUserHeadImageUrl];
            
            RCUserInfo *currentUser = [RCIM sharedRCIM].currentUserInfo;
            currentUser.name = kFetchUserName;
            currentUser.portraitUri = kFetchUserHeadImageUrl;
            [[RCIM sharedRCIM]refreshUserInfoCache:currentUser withUserId:kFetchUserId];

            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBHudSet dismiss:self.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:self.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:self.view];
        }
    }];
}

-(void) setUpNavigationBar
{
    self.navigationItem.title=@"个人资料";
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    backButton.frame=CGRectMake(30, 12, 20, 20);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
-(void) back
{
    [self.navigationController popViewControllerAnimated:YES];
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
