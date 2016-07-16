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

#define kApplication @"1c7018c7e597db7c7da31b2d7d400793"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建窗口
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    [self.window makeKeyAndVisible];
    
    
    //创建根视图控制器
    MainViewController *mainVC = [[MainViewController alloc] init];
    mainVC.view.backgroundColor = [UIColor yellowColor];
    LLQNavigationController *naviVC = [[LLQNavigationController alloc] initWithRootViewController:mainVC];
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    
    MMDrawerController *rootVC = [[MMDrawerController alloc] initWithCenterViewController:naviVC leftDrawerViewController:leftVC];
    rootVC.maximumLeftDrawerWidth = 330;
    rootVC.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    rootVC.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    
    //设置为根视图
    self.window.rootViewController = rootVC;
    
    //注册 APP
    [Bmob registerWithAppKey:kApplication];
    
    return YES;
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
