//
//  AppDelegate.h
//  MiMi
//
//  Created by LLQ on 16/7/15.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//存储控制器的数组
@property(nonatomic, strong)NSMutableArray *viewControllers;
//存储抽屉控制器
@property(nonatomic, strong)MMDrawerController *drawerVC;


@end

