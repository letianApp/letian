//
//  UserLetterViewController.m
//  letian
//
//  Created by J on 2018/11/9.
//  Copyright © 2018 J. All rights reserved.
//

#import "UserLetterViewController.h"

@interface UserLetterViewController ()<UITextViewDelegate>

@property (nonatomic, strong) NSString *thankLetter;
@property (nonatomic, strong) UILabel *lb;


@end

@implementation UserLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"写感谢信";
    _thankLetter = [NSString new];
    [self customNav];
    [self customTextView];
}

- (void)customNav {
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"发表" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.backgroundColor = MAINCOLOR;
    btn.layer.borderColor = [UIColor clearColor].CGColor;
    btn.layer.borderWidth=0.8;
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=8;
    [btn setFrame:CGRectMake(0, 0, 50, 25)];
    [btn addTarget:self action:@selector(clickPubBtn) forControlEvents:UIControlEventTouchUpInside];
    
    if (@available(iOS 11.0, *)){
        
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
        UIView *shareVew = [[UIView alloc] initWithFrame:btn.bounds];
        [shareVew addSubview:btn];
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareVew];

        self.navigationItem.rightBarButtonItem = shareItem;
        
    }
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

- (void)customTextView {
    
    UITextView *inputText = [[UITextView alloc]initWithFrame:CGRectMake(10, statusBar_H + navigationBar_H + 10, SCREEN_W - 20, SCREEN_H - statusBar_H - navigationBar_H)];
    [self.view addSubview:inputText];
    [[UITextView appearance] setTintColor:MAINCOLOR];
    inputText.delegate = self;
    inputText.font = [UIFont systemFontOfSize:15];
    self.lb = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, 300, 50)];
    self.lb.text = @"想说点什么";
    self.lb.enabled = NO;
    [inputText addSubview:self.lb];
    
}

- (void)textViewDidChange:(UITextView *)textView {
    _thankLetter = textView.text;
//    NSLog(@"%@",_thankLetter);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    self.lb.alpha = 0;//开始编辑时
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    //将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
        self.lb.alpha = 1;
    }
    return YES;
}

- (void)clickPubBtn {
    
    GQNetworkManager *manager = [GQNetworkManager sharedNetworkToolWithoutBaseUrl];
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_CONSULT];
    [requestString appendString:API_NAME_ADDUSERLETTER];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"OrderID"] = @(self.orderID);
    params[@"LetterContent"] = _thankLetter;
    
    [manager.requestSerializer setValue:kFetchToken forHTTPHeaderField:@"token"];
    [MBHudSet showStatusOnView:self.view];
    [manager POST:requestString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;
        [MBHudSet dismiss:strongSelf.view];
        [MBHudSet showText:@"发送成功" andOnView:strongSelf.view];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:strongSelf selector:@selector(back) userInfo:nil repeats:NO];
        NSLog(@"%@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        __strong typeof(self) strongSelf = weakSelf;
        [MBHudSet dismiss:strongSelf.view];
        [MBHudSet showText:@"发送失败" andOnView:strongSelf.view];
    }];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
