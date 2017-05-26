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

#import "ServiceModel.h"

#import "UIImageView+WebCache.h"
#import "Colours.h"


@interface ChatListViewController ()

@property (nonatomic, strong) ServiceModel *serviceInfo;
@property (nonatomic, strong) UIImageView  *headView;
@property (nonatomic, strong) UILabel *titleLab;

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

//- (void)viewWillAppear:(BOOL)animated {
//
//    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:@"12" isTop:YES];
//    
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavigation];
    [self getServiceInfo];
    [self emptyConversationBackView];
    
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:@"12" isTop:YES];
    self.topCellBackgroundColor = [UIColor snowColor];

    
//    self.conversationListTableView.delegate = self;
//    self.conversationListTableView.dataSource = self;
    
//    RCConversationModel *mod = [[RCConversationModel alloc]init];
//    mod.targetId = @"6";
//    [self refreshConversationTableViewWithConversationModel:mod];
    
    
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    self.navigationItem.title = @"咨询列表";
    
}

#pragma mark 获取客服资料
- (void)getServiceInfo {
    
    self.serviceInfo = [[ServiceModel alloc]init];
    
    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_GETUSERINFO];
    
    NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
    parames[@"userID"] = @(12);
    
    [PPNetworkHelper setValue:kFetchToken forHTTPHeaderField:@"token"];
    __weak typeof(self) weakSelf = self;
    
    [PPNetworkHelper GET:requestString parameters:parames success:^(id responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;
        NSLog(@"&&&&&&&&&*获取用户信息%@",responseObject);
        if([responseObject[@"Code"] integerValue] == 200) {
            
            strongSelf.serviceInfo.userId      = [NSString stringWithFormat:@"%@",responseObject[@"Result"][@"Source"][@"UserID"]];
            strongSelf.serviceInfo.name        = responseObject[@"Result"][@"Source"][@"NickName"];
            strongSelf.serviceInfo.portraitUri = responseObject[@"Result"][@"Source"][@"HeadImg"];

//            [strongSelf emptyConversationBackView];

        } else {
            
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

#pragma mark 列表为空时显示Cell
- (void)emptyConversationBackView {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = CGRectMake(0, statusBar_H + navigationBar_H, SCREEN_W, SCREEN_H);
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, statusBar_H + navigationBar_H)];
    [bgView addSubview:btn];
//    btn.backgroundColor = MAINCOLOR;
    [btn addTarget:self action:@selector(clickEmptyCell:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.headView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, btn.height - 20, btn.height - 20)];
    [btn addSubview:self.headView];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:self.serviceInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"乐天logo"]];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(self.headView.right + 10, self.headView.y, 200, self.headView.height)];
    [btn addSubview:self.titleLab];
    self.titleLab.text = @"有什么想和小乐说的吗";
    self.titleLab.textColor = MAINCOLOR;

    self.emptyConversationView = bgView;
    
}

- (void)clickEmptyCell:(UIButton *)btn {
    
    ChatViewController *chatVc      = [[ChatViewController alloc]init];
    chatVc.hidesBottomBarWhenPushed = YES;
    chatVc.conversationType         = ConversationType_PRIVATE;
    chatVc.targetId                 = self.serviceInfo.userId;
    chatVc.title                    = self.serviceInfo.name;
    [self.navigationController pushViewController:chatVc animated:YES];
    
    
}

#pragma mark 定制cell
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf   = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int badge = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        NSLog(@"总：%d",badge);
        UITabBarItem *item = [weakSelf.tabBarController.tabBar.items objectAtIndex:2];
        if (badge > 0) {
            
            NSString *badgeStr = [NSString stringWithFormat:@"%d",badge];
            item.badgeValue = badgeStr;
        } else {
            item.badgeValue = nil;
        }
    });

    
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:@"12" isTop:YES];
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
//    model.topCellBackgroundColor = [UIColor snowColor];

    
//    RCConversationModel *cellModel = cell.model;
//    if (model.isTop == YES) {
//        NSLog(@"顶部：%@",model.conversationTitle);
//        model.topCellBackgroundColor = [UIColor blackColor];
//    }
    
    
    RCConversationCell *conversationCell = (RCConversationCell *)cell;
    conversationCell.topCellBackgroundColor = [UIColor snowColor];
//    if ([conversationCell.conversationTitle.text isEqual: @"测试药师2"]) {
//        
//        NSLog(@"hhhhhhh");
//        model.isTop = YES;
//    }
    NSInteger unreadCount = conversationCell.model.unreadMessageCount;
    NSLog(@"未读：%ld",(long)model.unreadMessageCount);
    if (unreadCount > 0){
        conversationCell.bubbleTipView.bubbleTipText = (unreadCount > 99) ? @"99+" : [NSString stringWithFormat:@"%ld",(long)unreadCount];
    }else{
        conversationCell.bubbleTipView.bubbleTipText = nil;
    }
    
    
//        conversationCell.messageCreatedTimeLabel.text = @"1000";
//        conversationCell.messageContentLabel.text = @"aaaaa";
//    }
//    cell.bubbleTipView.bubbleTipBackgroundColor = MAINCOLOR;
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
    
        ChatViewController *chatVc      = [[ChatViewController alloc]init];
        chatVc.hidesBottomBarWhenPushed = YES;
        chatVc.conversationType         = model.conversationType;
        chatVc.targetId                 = model.targetId;
        chatVc.title                    = model.conversationTitle;
        
//        [chatVc.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1101];
//        [chatVc.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];

        model.unreadMessageCount        = 0;
        [self.navigationController pushViewController:chatVc animated:YES];
        
//        [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
//        [self.conversationListTableView reloadData];

    }
    
//    if (indexPath.row == 0) {
    
//    }
//    } else if (conversationModelType == ConversationType_CUSTOMERSERVICE) {
//        
//        RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
//        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
//        chatService.targetId = @"KEFU149145862082595";
//        chatService.title = @"客服";
////        chatService.csInfo = csInfo; //用户的详细信息，此数据用于上传用户信息到客服后台，数据的nickName和portraitUrl必须填写。(目前该字段暂时没用到，客服后台显示的用户信息是你获取token时传的参数，之后会用到）
//        [self.navigationController pushViewController :chatService animated:YES];
//    }
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
