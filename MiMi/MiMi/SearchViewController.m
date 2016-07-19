//
//  SearchViewController.m
//  MiMi
//
//  Created by LLQ on 16/7/18.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UITextFieldDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    //加载导航栏控件
    [self loadNaviItem];
    
    ///fghj
}

//修改导航栏
- (void)loadNaviItem{
    
    //右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} forState:UIControlStateNormal];
    
    //左侧搜索条
    //背景视图
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 5;
    searchView.clipsToBounds = YES;
    //搜索小图标
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    searchIcon.image = [UIImage imageNamed:@"search_icon_6P"];
    [searchView addSubview:searchIcon];
    //输入框
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(27, 5, 300-22, 20)];
    searchTextField.borderStyle = UITextBorderStyleNone;
    searchTextField.placeholder = @"搜索";
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;   //不进行自动矫正
    searchTextField.enablesReturnKeyAutomatically = YES;   //输入为空时return不得点击
    searchTextField.delegate = self;
    [searchView addSubview:searchTextField];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:searchView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

//右侧按钮点击方法
- (void)rightBarButtonItemAction{
    
    //返回根视图控制器
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
