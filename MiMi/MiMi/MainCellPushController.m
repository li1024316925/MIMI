//
//  MainCellPushController.m
//  MiMi
//
//  Created by LLQ on 16/7/20.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "MainCellPushController.h"
#import "SegmentView.h"

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
    [self createTableHeaderView];
    
    //将表视图添加在假导航视图之下
    [self.view insertSubview:self.backTableView belowSubview:self.navigationView];
}

//创建表头视图
- (void)createTableHeaderView{
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
    //按钮组
    self.btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 220, kScreenWidth, 60)];
    self.btnsHeight = 60;
    self.btnsView.backgroundColor = [UIColor whiteColor];
    [tableHeaderView addSubview:self.btnsView];
    SegmentView *segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth-100, 60) WithImageArray:@[[UIImage imageNamed:@"groom"],[UIImage imageNamed:@"info"]] titleArray:@[@"推荐",@"信息"]];
    segmentView.selectImageName = @"discoverList_selectButton";
    [self.btnsView addSubview:segmentView];
    //图片视图
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableHeaderView.bounds.size.width, 220)];
    headerImageView.tag = 101;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageURL]];
    [tableHeaderView addSubview:headerImageView];
    
    self.backTableView.tableHeaderView = tableHeaderView;
    
}


#pragma mark ------ UITableViewDataSource 和 UITableViewDelegate

//返回每组单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 25;
    
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
