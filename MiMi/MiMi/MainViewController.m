//
//  MainViewController.m
//  MiMi
//
//  Created by LLQ on 16/7/16.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "MainViewController.h"
#import "MainNearbyView.h"
#import "MainRecommendCellModel.h"
#import "MainRecommendGroupModel.h"
#import "MainRecommendCell.h"
#import "MainRecommendTableHeaderView.h"
#import "SearchViewController.h"
#import "MainCellPushController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_bgView;
    UITableView *_mainTableView;
    UISegmentedControl *_segment;
    MainNearbyView *_nearbyView;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:52/255.0 blue:53/255.0 alpha:1];
    
    //导航条
    [self loadNavigationItem];
    
    //附近视图
    [self loadNearbyView];
    
    //加载数据
    [self loadData];
    
    //加载表视图
    [self loadTableView];
    
}

//数据数组懒加载
- (NSMutableArray *)dataList{
    
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
    }
    
    return _dataList;
    
}

//加载数据
- (void)loadData{
    
    //解析plist文件
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HomeDatas" ofType:@"plist"]];
    
    //组数据
    for (NSDictionary *dic in array) {
        
        //行数据
        NSArray *bodyArray = [dic objectForKey:@"body"];
        NSMutableArray *bodyMutableArray = [[NSMutableArray alloc] init];
        for (NSDictionary *bodyDic in bodyArray) {
            //行数据解析为model
            MainRecommendCellModel *bodyModel = [[MainRecommendCellModel alloc] initWithDataDic:bodyDic];
            [bodyMutableArray addObject:bodyModel];
        }
        
        NSMutableDictionary *groupDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [groupDic setValue:bodyMutableArray forKey:@"body"];
        //组数据解析为model
        MainRecommendGroupModel *groupModel = [[MainRecommendGroupModel alloc] initWithDataDic:groupDic];
        [self.dataList addObject:groupModel];
        
    }
    
    [self loadWebData];
    
}

//加载网络数据库数据
- (NSArray *)loadWebData{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"MainGroup"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        for (BmobObject *obj in array) {
            NSDictionary *dic = [NSDictionary dictionary];
            [dic setValue:[obj objectForKey:@"tag_name"] forKey:@"tag_name"];
            [dic setValue:[obj objectForKey:@"section_count"] forKey:@"section_count"];
            [dic setValue:[obj objectForKey:@"color"] forKey:@"color"];
            [dic setValue:[obj objectForKey:@"body"] forKey:@"body"];
            [dataArray addObject:dic];
        }
        
    }];
    
    return dataArray;
}

//添加附近视图
- (void)loadNearbyView{
    
    //创建附近视图并将它添加到tableView的下一层
    _nearbyView = [[MainNearbyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_nearbyView];
    
}

//设置导航条
- (void)loadNavigationItem{
    
    //创建按钮组
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"推荐",@"附近"]];
    _segment.tintColor = [UIColor colorWithRed:26/255.0 green:163/255.0 blue:146/255.0 alpha:1];
    _segment.frame = CGRectMake(0, 0, self.view.bounds.size.width/2, 30);
    //使用富文本属性修改文字
    NSMutableDictionary *attdic = [[NSMutableDictionary alloc] init];
    [attdic setObject:[UIFont boldSystemFontOfSize:16] forKey:NSFontAttributeName];
    [attdic setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [_segment setTitleTextAttributes:attdic forState:UIControlStateNormal];
    [_segment setTitleTextAttributes:attdic forState:UIControlStateSelected];
    //添加事件
    [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    _segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segment;
    
    //右边搜索按钮
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [searchButton setImage:[UIImage imageNamed:@"search_icon_white_6P@2x"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

//导航栏标题按钮组点击方法
- (void)segmentAction:(UISegmentedControl *)segment{
    
    [self rootViewSlideWithIndex:segment.selectedSegmentIndex withAnimation:YES];
    
}

//根视图滑动方法
- (void)rootViewSlideWithIndex:(NSInteger)index withAnimation:(BOOL)animation{
    
    //切换页面
    if (index == 0) {
        
        if (animation == YES) {
            
            //设置左下角为锚点，并定位在根视图的左下角
            _nearbyView.layer.anchorPoint = CGPointMake(0, 1);
            _nearbyView.layer.position = CGPointMake(0, kScreenHeight);
            [UIView animateWithDuration:0.5 animations:^{
                _nearbyView.transform = CGAffineTransformRotate(_nearbyView.transform, -M_PI/4);
                _nearbyView.alpha = 0;
            } completion:^(BOOL finished) {
                //还原所有改变，把表视图拿到最上层
                _nearbyView.alpha = 1;
                _nearbyView.transform = CGAffineTransformIdentity;
                [self.view bringSubviewToFront:_mainTableView];
            }];
            
        }else{
            
            [self.view bringSubviewToFront:_mainTableView];
            
        }
        
    }else if (index == 1){
        
        if (animation == YES) {
            
            //设置右下角为锚点，并将定位点设置在根视图右下角
            _mainTableView.layer.anchorPoint = CGPointMake(1, 1);
            _mainTableView.layer.position = CGPointMake(kScreenWidth, kScreenHeight-64);
            [UIView animateWithDuration:0.5 animations:^{
                _mainTableView.transform = CGAffineTransformRotate(_mainTableView.transform, M_PI/4);
                _mainTableView.alpha = 0;
            } completion:^(BOOL finished) {
                //还原所有改变，把附近视图拿到最上层
                _mainTableView.alpha = 1;
                _mainTableView.transform = CGAffineTransformIdentity;
                [self.view bringSubviewToFront:_nearbyView];
            }];
            
        }else{
            
            [self.view bringSubviewToFront:_nearbyView];
            
        }
    }
}

//搜索按钮方法
- (void)searchBtnAction:(UIButton *)button{
    
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

//加载表视图
- (void)loadTableView{
    
    //创建表视图
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.rowHeight = 220;
    _mainTableView.sectionHeaderHeight = 60;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = [UIColor colorWithRed:51/255.0 green:52/255.0 blue:53/255.0 alpha:1];
    //添加到附近视图的上面
    [self.view bringSubviewToFront:_mainTableView];
    
    [self.view addSubview:_mainTableView];
    
}


#pragma mark ------ UITableViewDataSource和UITableViewDelegate

//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataList.count;
    
}

//返回组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //创建组头视图
    MainRecommendTableHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MainRecommendTableHeaderView" owner:nil options:nil] lastObject];
    headerView.model = _dataList[section];
    
    return headerView;
}

//每组单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    MainRecommendGroupModel *groupModel = _dataList[section];
    
    return groupModel.body.count;
    
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //单元格复用
    MainRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MainRecommendCell" owner:nil options:nil] lastObject];
    }
    
    //数据
    MainRecommendGroupModel *groupModel = _dataList[indexPath.section];
    cell.model = groupModel.body[indexPath.row];
    
    return cell;
    
}

//单元格点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainCellPushController *pushController = [[MainCellPushController alloc] initWithRootNavigationController:self.navigationController];
    //数据
    MainRecommendGroupModel *groupModel = _dataList[indexPath.section];
    pushController.model = groupModel.body[indexPath.row];
    
    pushController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:pushController animated:YES];
}

@end
