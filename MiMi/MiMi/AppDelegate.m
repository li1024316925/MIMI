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
#import <BmobSDK/Bmob.h>
#import "FoundController.h"
#import "WNXMessageViewController.h"
#import "WNXSetingViewController.h"

#define kApplication @"1c7018c7e597db7c7da31b2d7d400793"

@interface AppDelegate ()

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
