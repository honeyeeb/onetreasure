//
//  AppDelegate.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/23.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "AppDelegate.h"
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>
#import <UserNotifications/UserNotifications.h>
#import <Bugly/Bugly.h>
//#import <Firebase/Firebase.h>


#import <UMMobClick/MobClick.h>
#import "UMessage.h"
#import "OTPayManager.h"


NSString *const k12306                     = @"5959e38e7666136c25001e8c";//@"58a567c1ae1bf810ed000a9c";


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (void)launchVendorFrameworks:(NSDictionary *)launchOptions {
    // Crash
//    [Fabric with:@[[Crashlytics class]]];
//    [[Fabric sharedSDK] setDebug: YES];
    // firapp
//    [FIRApp configure];
    
    // UMeng
    UMConfigInstance.appKey = k12306;
    UMConfigInstance.channelId = OT_CHANNEL;
    [MobClick setCrashReportEnabled:NO];
    [MobClick startWithConfigure:UMConfigInstance];
    //配置以上参数后调用此方法初始化SDK！
    // Push
    [UMessage startWithAppkey:k12306 launchOptions:launchOptions];
    
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
#ifdef DEBUG
    [UMessage setLogEnabled:YES];
#endif
    
    // Bugly
    [Bugly startWithAppId:@"9bcb4f6f7c"];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge| UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
            
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
            
        }
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self launchVendorFrameworks:launchOptions];
    application.statusBarHidden = NO;
    
    // 支付
    [OTPayManager setupJSPayApplication:application launthOptions:launchOptions];
    
//    [self setup3DActions];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:    (id)annotation {
    
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString* des = deviceToken.description;
    NSString *dt = [des stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *dn = [dt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimToken = [dn stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (trimToken) {
        [[NSUserDefaults standardUserDefaults] setObject:trimToken forKey:OT_DEEVICE_TOKEN];
    }
#ifdef DEBUG
    OTLog(@"token:%@", trimToken);
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)setup3DActions {
    UIApplicationShortcutIcon *shareIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    UIApplicationShortcutItem *shareItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.mobile.queyue.share" localizedTitle:@"分享" localizedSubtitle:nil icon:shareIcon userInfo:nil];
    
//    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
//    UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"com.mobile.queyue.icon" localizedTitle:@"你猜猜" localizedSubtitle:nil icon:icon userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[shareItem];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if ([shortcutItem.type isEqualToString:@"com.mobile.queyue.share"]) {
        // 分享
        UIActivityViewController *shareVC = [[UIActivityViewController alloc] initWithActivityItems:@[] applicationActivities:nil];
        [self.window.rootViewController presentViewController:shareVC animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

@end
