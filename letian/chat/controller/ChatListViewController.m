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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavigation];
//    [self getServiceInfo];
    [self emptyConversationBackView];
    
    self.topCellBackgroundColor = [UIColor snowColor];
    self.conversationListTableView.tableFooterView = [UIView new];
    
}

#pragma mark 定制导航栏
- (void)customNavigation {
    
    self.navigationItem.title = @"咨询列表";
//    self.navigationItem.titleView.tintColor = MAINCOLOR;
    self.navigationController.navigationBar.tintColor = MAINCOLOR;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickServiceBtn)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

- (void)clickServiceBtn {
    
    RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
    chatService.hidesBottomBarWhenPushed = YES;
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = RONGYUN_SERVICE_ID;
    chatService.title = @"乐天心理咨询";
    [self.navigationController pushViewController:chatService animated:YES];
    
}

#pragma mark 列表为空时显示Cell
- (void)emptyConversationBackView {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, statusBar_H + navigationBar_H)];
    [bgView addSubview:btn];
//    btn.backgroundColor = MAINCOLOR;
    [btn addTarget:self action:@selector(clickServiceBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.headView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, btn.height - 20, btn.height - 20)];
    [btn addSubview:self.headView];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:self.serviceInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"乐天logo"]];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(self.headView.right + 10, self.headView.y, 200, self.headView.height)];
    [btn addSubview:self.titleLab];
    self.titleLab.text = @"联系乐天当值咨询师";
    self.titleLab.textColor = MAINCOLOR;

    self.emptyConversationView = bgView;
    
}

- (void)clickEmptyCell:(UIButton *)btn {
    
    RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
    chatService.hidesBottomBarWhenPushed = YES;
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = RONGYUN_SERVICE_ID;
    chatService.title = @"乐天心理咨询";
    [self.navigationController pushViewController:chatService animated:YES];
    
}

#pragma mark 定制cell
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf   = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int badge = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        UITabBarItem *item = [weakSelf.tabBarController.tabBar.items objectAtIndex:2];
        if (badge > 0) {
            NSString *badgeStr = [NSString stringWithFormat:@"%d",badge];
            item.badgeValue = badgeStr;
        } else {
            item.badgeValue = nil;
        }
    });

    RCConversationCell *conversationCell = (RCConversationCell *)cell;
    conversationCell.topCellBackgroundColor = [UIColor snowColor];
    NSInteger unreadCount = conversationCell.model.unreadMessageCount;
    if (unreadCount > 0){
        conversationCell.bubbleTipView.bubbleTipText = (unreadCount > 99) ? @"99+" : [NSString stringWithFormat:@"%ld",(long)unreadCount];
    }else{
        conversationCell.bubbleTipView.bubbleTipText = nil;
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
    
        ChatViewController *chatVc      = [[ChatViewController alloc]init];
        chatVc.hidesBottomBarWhenPushed = YES;
        chatVc.conversationType         = model.conversationType;
        chatVc.targetId                 = model.targetId;
        chatVc.title                    = model.conversationTitle;
        model.unreadMessageCount        = 0;
        [self.navigationController pushViewController:chatVc animated:YES];
        
    } else if (conversationModelType == ConversationType_CUSTOMERSERVICE) {
        
        RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
        chatService.hidesBottomBarWhenPushed = YES;
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = RONGYUN_SERVICE_ID;
        chatService.title = model.conversationTitle;
        [self.navigationController pushViewController:chatService animated:YES];

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
