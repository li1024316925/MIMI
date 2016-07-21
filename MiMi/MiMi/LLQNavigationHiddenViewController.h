//
//  LLQNavigationHiddenViewController.h
//  MiMi
//
//  Created by LLQ on 16/7/20.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLQNavigationHiddenViewController : UIViewController


/**
 用来保存根导航控制器
 */
@property(nonatomic, strong)UINavigationController *rootNaviController;
/**
 表视图
 */
@property(nonatomic, strong)UITableView *backTableView;
/**
 假的导航栏
 */
@property(nonatomic, strong)UIView *navigationView;
/**
 按钮组视图
 */
@property(nonatomic, strong)UIView *btnsView;
/**
 按钮组的高度
 */
@property(nonatomic, assign)float btnsHeight;

//初始化方法
- (instancetype)initWithRootNavigationController:(UINavigationController *)navigationController;

@end
