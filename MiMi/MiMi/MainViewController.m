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

@interface MainViewController ()
{
    UIView *_bgView;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航条
    [self loadNavigationItem];
    
    //附近视图
    [self loadNearbyView];
    
    //加载数据
    [self loadData];
    
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
    
}

//添加附近视图
- (void)loadNearbyView{
    
    MainNearbyView *nearbyView = [[MainNearbyView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:nearbyView];
    
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
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segment;
    
    
}

//导航栏标题按钮组点击方法
- (void)segmentAction:(UISegmentedControl *)segment{
    
    //左右滑动以达到切换页面效果
    if (segment.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }else if (segment.selectedSegmentIndex == 1){
        [UIView animateWithDuration:0.3 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
        }];
    }
    
}



@end
