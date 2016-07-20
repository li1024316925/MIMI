//
//  PresentController.m
//  MiMi
//
//  Created by 张崇超 on 16/7/16.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "PresentController.h"
#import "PushFoundCell.h"
#import "MainRecommendCell.h"
#import "PushFoundModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>

static NSString *identifier = @"RecommendCell";

@interface PresentController ()<UITableViewDataSource,UITableViewDelegate>

/** 数据源数组 */
@property(nonatomic,strong)NSMutableArray *dataList;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)MJRefreshGifHeader *header;

@end

@implementation PresentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"美食";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(naviLeftBtnAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self createTableView];
    
    [self getRefresh];
}

//导航栏左按钮点击方法
- (void)naviLeftBtnAction{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//刷新
- (void)getRefresh
{
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 50; i < 96; i ++) {
        
        NSString *imgaeName = [NSString stringWithFormat:@"loading_0%02d",i];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgaeName]];
        
        [images addObject:image];
    }
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    
    [header setImages:images duration:3 forState:MJRefreshStateRefreshing];
    
    self.header = header;
    
    [self.tableView addSubview:header];
    
    [header beginRefreshing];
}

//获取数据
- (void)getData
{
    //刷新表视图
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.header endRefreshing];
    });
}

//加载数据
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        
        _dataList = [NSMutableArray array];
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"CellDatas" ofType:@"plist"];

        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        _dataList  = [PushFoundModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _dataList;
}

//添加一个分页控制器
- (void)addSegemnetView
{
    
    
    
}

//创建表视图
- (void)createTableView
{
    UITableView *tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    
    tabelView.backgroundColor = [UIColor clearColor];
    
    tabelView.delegate = self;
    
    tabelView.dataSource = self;
    
    [tabelView registerClass:[MainRecommendCell class] forCellReuseIdentifier:identifier];
    
    self.tableView = tabelView;
    
    [self.view addSubview:tabelView];
}

#pragma -mark UITableViewDelegate

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

#pragma -mark UITableViewDataSource

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainRecommendCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"MainRecommendCell" owner:nil options:nil] firstObject];
    
    cell.model = self.dataList[indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
