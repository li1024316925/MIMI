//
//  LLQNavigationController.m
//  MiMi
//
//  Created by LLQ on 16/7/16.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "LLQNavigationController.h"
#import "MainViewController.h"

@interface LLQNavigationController ()

@end

@implementation LLQNavigationController

//复写init方法，在此方法中取到rootViewController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {
        //设置按钮
        UIBarButtonItem *leftItem = [self createLeftButton];
        rootViewController.navigationItem.leftBarButtonItem = leftItem;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //关闭半透明
    self.navigationBar.translucent = NO;
    
    //导航栏颜色
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"recomend_btn_gone"] forBarMetrics:UIBarMetricsDefault];
    
}

//自定义导航栏左按钮
- (UIBarButtonItem *)createLeftButton{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"artcleList_btn_info_6P"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(naviLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return leftItem;
    
}

//导航栏左侧按钮点击事件
- (void)naviLeftBtnAction:(UIButton *)btn{
    //发送通知关闭抽屉
    [[NSNotificationCenter defaultCenter] postNotificationName:kOpenOrCloseDrawer object:self];
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
