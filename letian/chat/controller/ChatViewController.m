//
//  ChatViewController.m
//  letian
//
//  Created by J on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ChatViewController.h"
#import "ConsultViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//        if ([self.targetId isEqualToString:@"12"]) {
//            
//            [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
//            [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
//        }
//    }
//    return self;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self customNavigation];
    
    if ([self.targetId isEqualToString:@"12"]) {
        
        [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
        [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
    }
    
    
}



#pragma mark 定制导航栏
- (void)customNavigation {
    
//    self.navigationItem.title = @"小乐";
    self.navigationController.navigationBar.tintColor = MAINCOLOR;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.backBarButtonItem = backBtn;

//    UIButton *btn                          = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [btn setImage:[UIImage imageNamed:@"pinkback"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem              = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"pinkback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickNcBtn:)];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

//    backItem.tag                           = 10;
//    self.navigationItem.leftBarButtonItem  = backItem;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"预约" style:UIBarButtonItemStylePlain target:self action:@selector(clickNcRightBtn)];

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


- (void)clickBackBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickNcRightBtn {
    
    ConsultViewController *vc = [[ConsultViewController alloc]init];
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
                   atIndexPath:(NSIndexPath *)indexPath {
    
    if (cell.model.messageDirection == MessageDirection_SEND ) {

        if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        
//            RCTextMessageCell *textCell = (RCTextMessageCell *)cell;
//            textCell.textLabel.backgroundColor = MAINCOLOR;
        
        }
        
        
    }
    
}

- (void)onBeginRecordEvent {
    
}


//- (RCMessage *)sendMessage:(RCConversationType)conversationType
//                  targetId:(NSString *)targetId
//                   content:(RCMessageContent *)content
//               pushContent:(NSString *)pushContent
//                  pushData:(NSString *)pushData
//                   success:(void (^)(long messageId))successBlock
//                     error:(void (^)(RCErrorCode nErrorCode, long messageId))errorBlock {
//    
//    
//    
//}

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
