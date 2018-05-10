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
    
    self.navigationController.navigationBar.tintColor = MAINCOLOR;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
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
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
                   atIndexPath:(NSIndexPath *)indexPath {
    
    if (cell.model.messageDirection == MessageDirection_SEND ) {

        if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        
        
        }
        
        
    }
    
}

- (void)onBeginRecordEvent {
    
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
