//                          _ooOoo_                               //
//                         o8888888o                              //
//                         88" . "88                              //
//                         (| ^_^ |)                              //
//                         O\  =  /O                              //
//                      ____/`---'\____                           //
//                    .'  \\|     |//  `.                         //
//                   /  \\|||  :  |||//  \                        //
//                  /  _||||| -:- |||||-  \                       //
//                  |   | \\\  -  /// |   |                       //
//                  | \_|  ''\---/''  |   |                       //
//                  \  .-\__  `-`  ___/-. /                       //
//                ___`. .'  /--.--\  `. . ___                     //
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
//      ========`-.____`-.___\_____/___.-`____.-'========         //
//                           `=---='                              //
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
//         佛祖保佑            永无BUG              永不修改          //
//  AppDelegate.m
//  letian
//
//  Created by J on 2017/2/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "AppDelegate.h"

#import "GQCoreNewFeatureViewController.h"
#import "TYLaunchFadeScaleAnimation.h"
#import "TAdLaunchImageView.h"
#import "UIView+TYLaunchAnimation.h"
#import "UIImage+TYLaunchImage.h"
#import "CALayer+Transition.h"

#import "CustomCYLTabBar.h"
#import "GQUserManager.h"

//#import "CustomPlusBtn.h"
#import "LoginViewController.h"
#import "FirstViewController.h"
#import "ConsultViewController.h"
#import "MyViewController.h"

#import <RongIMKit/RongIMKit.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>

#import <UMSocialCore/UMSocialCore.h>

#import "UIImageView+WebCache.h"

#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif



@interface AppDelegate ()<WXApiDelegate, JPUSHRegisterDelegate, RCIMUserInfoDataSource, RCIMReceiveMessageDelegate, UITabBarControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //实时调试
    Class Test = NSClassFromString(@"UIDebuggingInformationOverlay");
    [[Test class] performSelector:@selector(prepareDebuggingOverlay)];
    

    
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    [self.window makeKeyAndVisible];
        
    [self setStartAction];

    [self setUpStatusBar];
    
    [self resignWechat];
    
    [self ConfigJPush:launchOptions];
    
    [self setUSharePlatforms];
    
    [self customEMwithApp:application withLaunchOptions:launchOptions];
    
    return YES;
    
}

#pragma mark----------------引导图----------------
-(void)setStartAction{
    
    //是否显示新版本引导
    BOOL canShow = [GQCoreNewFeatureViewController canShowNewFeature];
    if (canShow) {
        self.window.rootViewController = [GQCoreNewFeatureViewController newFeatureVCWithImageNames:@[@"guide1",@"guide2",@"guide3"] enterBlock:^{
            [self createTabbarController];
            [self.window.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:2.0f];
        } configuration:^(UIButton *enterButton) {
            [enterButton setTitle:@"进入乐天心理" forState:UIControlStateNormal];
            [enterButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
            enterButton.bounds = CGRectMake(0, 0, 140, 40);
            enterButton.center = CGPointMake(SCREEN_W * 0.5, SCREEN_H* 0.95);
            enterButton.layer.cornerRadius = 4;
            enterButton.layer.borderWidth = 1;
            enterButton.layer.borderColor = MAINCOLOR.CGColor;
        }];
    }else{
        [self createTabbarController];
    }
    if (!canShow) {
//        [self configADImage];
    }

}

//启动页

-(void) configADImage
{
    TAdLaunchImageView *adLaunchImageView = [[TAdLaunchImageView alloc]initWithImage:[UIImage ty_getLaunchImage]];
    [adLaunchImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493667587779&di=28e7dd5cbcf8ef16b8188b77b5a6369e&imgtype=0&src=http%3A%2F%2Fdata.useit.com.cn%2Fuseitdata%2Fforum%2F201512%2F09%2F144210euq2hw5yrypupacw.jpg"]];
    [adLaunchImageView showInWindowWithAnimation:[TYLaunchFadeScaleAnimation fadeAnimationWithDelay:5.0] completion:^(BOOL finished) {
//        NSLog(@"打开app");
    }];
}

#pragma mark-----------创建tabberController-------------------

-(void)createTabbarController{
    
//    [CustomPlusBtn registerPlusButton];
    CustomCYLTabBar *tabBarControllerConfig = [[CustomCYLTabBar alloc] init];
    tabBarControllerConfig.tabBarController.delegate = self;
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    [self.window makeKeyAndVisible];
    
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController*)viewController {
    
    if ([viewController.tabBarItem.title isEqualToString:@"咨询"]) {
//        NSLog(@"tabbar登录:%d",[GQUserManager isHaveLogin]);
        if (![GQUserManager isHaveLogin]) {
            //未登录
            UIAlertController *alertControl  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
            [self.window.rootViewController presentViewController:alertControl animated:YES completion:nil];
           
            __weak typeof(self) weakSelf = self;

            [alertControl addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                __strong typeof(self) strongSelf = weakSelf;

                LoginViewController *loginVc = [[LoginViewController alloc]init];
                loginVc.hidesBottomBarWhenPushed = YES;
                [strongSelf.window.rootViewController presentViewController:loginVc animated:YES completion:nil];
            }]];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            return NO;

        }
        
    }

    return YES;
}

#pragma mark------------------设置全局的navigationBar样式--------------------

- (void)setUpStatusBar
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MAINCOLOR}];
    [[UINavigationBar appearance] setTintColor:MAINCOLOR];
//    [[UINavigationBar appearance] setBarTintColor:<#(UIColor * _Nullable)#>
//    UIImage *backButtonImage = [[UIImage imageNamed:@"pinkback"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    UIImage *image = [UIImage imageNamed:@"pinkback"];
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [UINavigationBar appearance].backIndicatorImage = image;
    
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = image;

}


#pragma mark------------------注册微信---------------------------

- (void)resignWechat {
    
    [WXApi registerApp:WEIXIN_APPID];
    
}

#pragma mark------------------------友盟分享---------------------------
//设置平台appkey
- (void)setUSharePlatforms
{
    [[UMSocialManager defaultManager] openLog:YES];
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WEIXIN_APPID appSecret:WEIXIN_SECRET redirectURL:@"http://mobile.umeng.com/social"];
   
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:TENCENT_APPID  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:WEIBO_APPKEY  appSecret:WEIBO_SECRET redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}


#pragma mark----------------------融云--------------------------

- (void)customEMwithApp:(UIApplication *)application withLaunchOptions:(NSDictionary *)launchOptions {
    
    __weak typeof(self) weakSelf   = self;
    
    [[RCIM sharedRCIM] initWithAppKey:RONGYUN_APPKEY];

    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Error;

    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [RCIM sharedRCIM].receiveMessageDelegate = self;                            //  设置接收消息代理
    [RCIM sharedRCIM].enableTypingStatus =YES;                                  //  开启输入状态监听
    [RCIM sharedRCIM].disableMessageAlertSound = YES;                       //  声音提示
    [RCIM sharedRCIM].enableSyncReadStatus = YES;

    if ( [GQUserManager isHaveLogin] ) {
        
        [[RCIM sharedRCIM] connectWithToken:kFetchRToken success:^(NSString *userId) {
            
            __strong typeof(self) strongSelf = weakSelf;
//            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CYLTabBarController *tab = (CYLTabBarController *)strongSelf.window.rootViewController;
                UITabBarItem *item = [tab.tabBar.items objectAtIndex:2];
                int badge = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
//                NSLog(@"总：%d",badge);
                if (badge > 0) {
                    
                    NSString *badgeStr = [NSString stringWithFormat:@"%d",badge];
                    item.badgeValue = badgeStr;
                } else {
                    item.badgeValue = nil;
                }
                
//                NSLog(@"显示的：%@",item.badgeValue);
            });

        } error:^(RCConnectErrorCode status) {
//            NSLog(@"登陆的错误码为:%ld", (long)status);
            
            
            
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//            NSLog(@"token错误");
        }];

    }
    
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    // 远程推送的内容
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
//    NSLog(@"远程推送：%@",remoteNotificationUserInfo);
}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}


- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    
    if ([userId isEqualToString:kFetchUserId]) {
        
        RCUserInfo *currentUser = [[RCUserInfo alloc]init];
        currentUser.userId      = userId;
        currentUser.name        = kFetchUserName;
        currentUser.portraitUri = kFetchUserHeadImageUrl;

        return completion(currentUser);
    }

    NSMutableString *requestString = [NSMutableString stringWithString:API_HTTP_PREFIX];
    [requestString appendFormat:@"%@/",API_MODULE_USER];
    [requestString appendString:API_NAME_GETUSERINFO];
    
    NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
    parames[@"userID"] = userId;
    
    [PPNetworkHelper setValue:kFetchToken forHTTPHeaderField:@"token"];
    __weak typeof(self) weakSelf = self;

    [PPNetworkHelper GET:requestString parameters:parames success:^(id responseObject) {
        
        __strong typeof(self) strongSelf = weakSelf;
//        NSLog(@"&&&&&&&&&*获取用户信息%@",responseObject);
        if([responseObject[@"Code"] integerValue] == 200) {

            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId      = userId;
            user.name        = responseObject[@"Result"][@"Source"][@"NickName"];
            user.portraitUri = responseObject[@"Result"][@"Source"][@"HeadImg"];
            return completion(user);
        }else{
            
//            [MBHudSet showText:responseObject[@"Msg"] andOnView:strongSelf.window.rootViewController.view];
            return completion(nil);
        }
    } failure:^(NSError *error) {
        
        __strong typeof(self) strongSelf = weakSelf;
        
        [MBHudSet dismiss:strongSelf.window.rootViewController.view];
        if (error.code == NSURLErrorCancelled) return;
        if (error.code == NSURLErrorTimedOut) {
            [MBHudSet showText:@"请求超时" andOnView:strongSelf.window.rootViewController.view];
        } else{
            [MBHudSet showText:@"请求失败" andOnView:strongSelf.window.rootViewController.view];
        }

    }];
    
    return completion(nil);
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
    
    __weak typeof(self) weakSelf   = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CYLTabBarController *tab = (CYLTabBarController *)weakSelf.window.rootViewController;
        UITabBarItem *item = [tab.tabBar.items objectAtIndex:2];
        int badge = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
//        NSLog(@"总：%d",badge);
        if (badge > 0) {
            
            NSString *badgeStr = [NSString stringWithFormat:@"%d",badge];
            item.badgeValue = badgeStr;
        } else {
            item.badgeValue = nil;
        }
        
//        NSLog(@"显示的：%@",item.badgeValue);
    });
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];


}


#pragma mark---------------------第三方回调------------------------

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"支付宝回调1 = %@",resultDic);
            }];
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"支付宝回调2 = %@",resultDic);
                self.pushToOrderVc([resultDic[@"resultStatus"] integerValue]);//从支付宝返回app指定界面
            }];
        }else if ([url.host isEqualToString:@"platformapi"]){
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"支付宝钱包快登授权返回 = %@",resultDic);
            }];
        }else if([url.host isEqualToString:@"pay"]){
            return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
        return YES;
    }
    return result;
}


#pragma mark----------------------极光推送-----------------------

//注册极光推送
-(void)ConfigJPush:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APPKEY
                          channel:@"APPStore"
                 apsForProduction:false];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    NSString *token = [deviceToken description];
    token = [token stringByReplacingOccurrencesOfString:@"<"
                                             withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">"
                                             withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" "
                                             withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];

}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient]
                                     getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
//        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
//            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
//        NSLog(@"该远程推送不包含来自融云的推送服务");
    }

    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
    
    [JPUSHService resetBadge];
}


#pragma mark-----------------禁止横屏


- (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
//    if (_rotation_Style == 1) {//如果是1就让屏幕强制横屏
//        return UIInterfaceOrientationMaskLandscape;
//    }
//    else
//    {
        return (UIInterfaceOrientationMaskPortrait);
//    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    
//    int bg = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
