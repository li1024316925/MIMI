//
//  AppDelegate.m
//  MiMi
//
//  Created by LLQ on 16/7/15.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "LLQNavigationController.h"
#import "LeftViewController.h"
#import "MainViewController.h"
#import "FoundController.h"
#import "WNXMessageViewController.h"
#import "WNXSetingViewController.h"
#import <WeiboSDK.h>

#define kApplication @"1c7018c7e597db7c7da31b2d7d400793"

#define kSineAppKey @"2864305413"

#define kSineAppSecret @"6c3d4131394d5338381f3a4b2d1acba8"

//回调网址
#define kRedirectUrl @"http://www.baidu.com"

@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate

//复写get方法，懒加载
- (NSMutableArray *)viewControllers{
    
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    
    return _viewControllers;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建窗口
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    [self.window makeKeyAndVisible];
    
   
    //创建根视图控制器
    MainViewController *mainVC = [[MainViewController alloc] init];
    LLQNavigationController *naviVC = [[LLQNavigationController alloc] initWithRootViewController:mainVC];
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    
    
    _drawerVC = [[MMDrawerController alloc] initWithCenterViewController:naviVC leftDrawerViewController:leftVC];
    _drawerVC.maximumLeftDrawerWidth = 330;
    _drawerVC.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    _drawerVC.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    
    //设置为根视图
    self.window.rootViewController = _drawerVC;
    
    //注册 APP
    [Bmob registerWithAppKey:kApplication];
    
    //创建各页面视图控制器，存入数组
    FoundController *foundVC = [[FoundController alloc] init];
    LLQNavigationController *naviVC2 = [[LLQNavigationController alloc] initWithRootViewController:foundVC];
    
    WNXMessageViewController *messageVC = [[WNXMessageViewController alloc] init];
    LLQNavigationController *naviVC3 = [[LLQNavigationController alloc] initWithRootViewController:messageVC];
    
    WNXSetingViewController *setingVC = [[WNXSetingViewController alloc] init];
    LLQNavigationController *naviVC4 = [[LLQNavigationController alloc] initWithRootViewController:setingVC];
    
    [self.viewControllers addObject:naviVC];
    [self.viewControllers addObject:naviVC2];
    [self.viewControllers addObject:naviVC3];
    [self.viewControllers addObject:naviVC4];
    
    //设置通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeDrawer) name:kOpenOrCloseDrawer object:nil];
    
    //=====Sine
    [WeiboSDK enableDebugMode:YES];
    
    //注册 App
    [WeiboSDK registerApp:kSineAppKey];
    
    return YES;
}

//接收通知后调用的方法
- (void)closeDrawer{
    
    if (self.drawerVC.openSide == MMDrawerSideNone) {
        //打开
        [self.drawerVC openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }else if (self.drawerVC.openSide == MMDrawerSideLeft){
        //关闭
        [self.drawerVC closeDrawerAnimated:YES completion:nil];
    }
}

//注册微博
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma -mark WeiboSDKDelegate

//收到回复调用
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
    
    NSString *uid = [(WBAuthorizeResponse *)response userID];
    
    NSDate *date = [(WBAuthorizeResponse *)response expirationDate];
    
    if (accessToken == nil) {
        return;
    }
    //得到的新浪微博授权信息，请按照例子来生成NSDictionary
    NSDictionary *dic = @{@"access_token":accessToken,@"uid":uid,@"expirationDate":date};
    
    //通过授权信息注册登录
    [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:BmobSNSPlatformSinaWeibo block:^(BmobUser *user, NSError *error) {
        
        if (error) {
            
            [SVProgressHUD showErrorWithStatus:@"微博授权失败,请重试"];
            NSLog(@"000%@",error);
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"微博登陆成功,仅限本次登陆"]];
        
        //发送通知,告诉控制器,请求成功
        [[NSNotificationCenter defaultCenter]postNotificationName:kLoginBySine object:nil userInfo:@{@"userName":user.username}];
    }];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
