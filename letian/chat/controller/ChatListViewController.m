//
//  ChatListViewController.m
//  letian
//
//  Created by J on 2017/4/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "RCDCustomerServiceViewController.h"


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

//    self.conversationListTableView.delegate = self;
//    self.conversationListTableView.dataSource = self;
    
//    RCConversationModel *mod = [[RCConversationModel alloc]init];
//    mod.targetId = @"6";
//    [self refreshConversationTableViewWithConversationModel:mod];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = MAINCOLOR;
    self.emptyConversationView = btn;
    
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    self.navigationItem.title = @"消息列表";
    
}

#pragma mark 定制cell

//插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    
    RCConversation *con = [[RCConversation alloc] init];
    con.targetId = @"6";
    con.isTop = YES;
//    con.conversationTitle = @"客服";
    con.senderUserId = @"6";
    con.lastestMessage = [RCTextMessage messageWithContent:@"aaaaa"];
    con.lastestMessageDirection = MessageDirection_RECEIVE;
    con.conversationType = ConversationType_PRIVATE;
    con.sentTime = 1494837417;
    con.receivedTime = 1494837417;
    RCConversationModel *model = [[RCConversationModel alloc]initWithConversation:con extend:nil];
    [dataSource insertObject:model atIndex:0];
    return dataSource;
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    if (model.conversationType == ConversationType_PRIVATE) {
        RCConversationCell *conversationCell = (RCConversationCell *)cell;
//        conversationCell.conversationTitle.textColor = MAINCOLOR;
        conversationCell.bubbleTipView.bubbleTipBackgroundColor = MAINCOLOR;
    }
}

- (void)refreshConversationTableViewWithConversationModel:(RCConversationModel *)conversationModel {
    
    NSLog(@"ddd");
    
    
}

//- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    RCConversationModel *mod = [[RCConversationModel alloc]init];
//    mod.conversationType = ConversationType_PRIVATE;
//    mod.targetId = @"6";
//    mod.conversationTitle = @"77";
//    
//    RCConversationBaseCell *cell = [[RCConversationBaseCell alloc]init];
//    cell.model = mod;
//    
//    
//    return cell;
//}

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
        chatVc.title = model.conversationTitle;
        [self.navigationController pushViewController:chatVc animated:YES];
    
    } else if (conversationModelType == ConversationType_CUSTOMERSERVICE) {
        
        RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = @"KEFU149145862082595";
        chatService.title = @"客服";
//        chatService.csInfo = csInfo; //用户的详细信息，此数据用于上传用户信息到客服后台，数据的nickName和portraitUrl必须填写。(目前该字段暂时没用到，客服后台显示的用户信息是你获取token时传的参数，之后会用到）
        [self.navigationController pushViewController :chatService animated:YES];
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
