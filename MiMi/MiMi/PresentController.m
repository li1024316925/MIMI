//
//  PresentController.m
//  MiMi
//
//  Created by 张崇超 on 16/7/16.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "PresentController.h"

static NSString *identifier = @"cell";

@interface PresentController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PresentController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self createTableView];
}

- (void)createTableView
{
    UITableView *tabelView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    tabelView.delegate = self;
    
    tabelView.dataSource = self;
    
    [tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
    [self.view addSubview:tabelView];
}

#pragma -mark UITableViewDataSource

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 18;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
