//
//  ViewController.m
//  ASasas
//
//  Created by BEVER on 16/7/16.
//  Copyright © 2016年 mac. All rights reserved.
//
//  点击消息push出的控制器

#import "WNXMessagePushViewController.h"

@interface WNXMessagePushViewController ()

@end

@implementation WNXMessagePushViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = WNXBackgroundGrayColor;
    
    [self.tableView removeFromSuperview];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EXP_getNilData_6P"]];
    CGPoint center = self.view.center;
    center.y = center.y - 150;
    imageV.center = center;
    [self.view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = @"没有找到相关推荐";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    
    CGFloat W = 300;
    CGFloat H = 100;
    CGFloat X = (WNXAppWidth - W) / 2;
    CGFloat y = center.y + 50;
    label.frame = CGRectMake(X, y, W, H);
    [self.view addSubview:label];
    
    //由于是present的所以先添加一个button来dismiss这个控制器
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    [bt setTitle:@"退出" forState:UIControlStateNormal];
    
    [bt addTarget:self action:@selector(btAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}
- (void)btAction
{

    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
