//
//  MainCellPushController.m
//  MiMi
//
//  Created by LLQ on 16/7/20.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "MainCellPushController.h"

@interface MainCellPushController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_navigationView;
}
@end

@implementation MainCellPushController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //最底层tableView
    [self loadBackTableView];
    
}

- (void)loadBackTableView{
    
    //创建表视图
    self.backTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight+20) style:UITableViewStylePlain];
    self.backTableView.dataSource = self;
    self.backTableView.delegate = self;
    self.backTableView.sectionHeaderHeight = 50;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    tableHeaderView.backgroundColor = [UIColor greenColor];
    self.backTableView.tableHeaderView = tableHeaderView;
    
    //将表视图添加在假导航视图之下
    [self.view insertSubview:self.backTableView belowSubview:self.navigationView];
}


#pragma mark ------ UITableViewDataSource 和 UITableViewDelegate

//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

//返回每组单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 25;
    
}

//返回组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.textLabel.text = @"这是组头视图";
    
    return headerView;
    
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"backCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"backCell"];
    }
    
    return cell;
    
}


@end
