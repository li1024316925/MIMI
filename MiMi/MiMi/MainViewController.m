//
//  MainViewController.m
//  MiMi
//
//  Created by LLQ on 16/7/16.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航条
    [self loadNavigationItem];
    
 
}

//设置导航条
- (void)loadNavigationItem{
    
    //创建按钮组
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"推荐",@"附近"]];
    segment.tintColor = [UIColor colorWithRed:26/255.0 green:163/255.0 blue:146/255.0 alpha:1];
    segment.frame = CGRectMake(0, 0, self.view.bounds.size.width/2, 30);
    //使用富文本属性修改文字
    NSMutableDictionary *attdic = [[NSMutableDictionary alloc] init];
    [attdic setObject:[UIFont boldSystemFontOfSize:16] forKey:NSFontAttributeName];
    [attdic setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [segment setTitleTextAttributes:attdic forState:UIControlStateNormal];
    [segment setTitleTextAttributes:attdic forState:UIControlStateSelected];
    //添加事件
    [segment addTarget:segment action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segment;
    
    
}

//导航栏标题按钮组点击方法
- (void)segmentAction:(UISegmentedControl *)segment{
    
    
    
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
