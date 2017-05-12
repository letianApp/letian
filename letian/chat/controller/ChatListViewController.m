//
//  ChatListViewController.m
//  letian
//
//  Created by J on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
//#import <RongIMKit/RongIMKit.h>


@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置在列表中需要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                              @(ConversationType_CUSTOMERSERVICE),
                                              @(ConversationType_SYSTEM)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_SYSTEM)]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavigation];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    btn.backgroundColor = MAINCOLOR;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.emptyConversationView = btn;
    
}

- (void)clickBtn:(UIButton *)btn {
    
    ChatViewController *chatVc = [[ChatViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId:@"002"];
    chatVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVc animated:YES];

}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    self.navigationItem.title = @"消息列表";
    
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

#pragma mark 定制cell
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    if (model.conversationType == ConversationType_PRIVATE) {
        RCConversationCell *conversationCell = (RCConversationCell *)cell;
//        conversationCell.conversationTitle.textColor = MAINCOLOR;
        conversationCell.bubbleTipView.bubbleTipBackgroundColor = MAINCOLOR;
    }
}

#pragma mark 点击cell方法
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        
        ChatListViewController *systemChatVc = [[ChatListViewController alloc]init];
        NSArray *arr = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [systemChatVc setDisplayConversationTypeArray:arr];
        [systemChatVc setCollectionConversationType:nil];
        systemChatVc.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:systemChatVc animated:YES];
        
    } else if (conversationModelType == ConversationType_PRIVATE) {
    
        ChatViewController *chatVc = [[ChatViewController alloc]init];
        chatVc.hidesBottomBarWhenPushed = YES;
        chatVc.conversationType = model.conversationType;
        chatVc.targetId = model.targetId;
        chatVc.title = @"002";
    
        [self.navigationController pushViewController:chatVc animated:YES];
    
    }
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
