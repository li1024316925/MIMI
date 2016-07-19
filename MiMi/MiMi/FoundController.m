//
//  FoundController.m
//  MiMi
//
//  Created by 张崇超 on 16/7/15.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "FoundController.h"
#import "LLQNavigationController.h"
#import "FoundCell.h"
#import "PresentController.h"
#import "FoundModel.h"
#import <MJExtension.h>

@interface FoundController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** 数据源数组 */
@property(nonatomic,strong)NSMutableArray *dataList;

@end

static NSString *identifier = @"cell";

@implementation FoundController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题
    self.title = @"发现";
    //修改标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    [self addCollectionView];
}

/** 懒加载加载数据 + */
- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        
        _dataList = [NSMutableArray array];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"foundData" ofType:@"plist"];
        
        NSArray *tmpArr = [NSMutableArray arrayWithContentsOfFile:path];
        
        _dataList = [self analysisArray:tmpArr];
        
    }
    return _dataList;
}

// + 解析数据
-(NSMutableArray*)analysisArray:(NSArray *)array{

    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [arr addObject:[FoundModel mj_objectArrayWithKeyValuesArray:array[0]]];
    [arr addObject:[FoundModel mj_objectArrayWithKeyValuesArray:array[1]]];
    
    return arr;
}

//添加集合试图
- (void)addCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake(120, 140);
    
    layout.headerReferenceSize =CGSizeMake(0, 64);

    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) collectionViewLayout:layout];
    
    collection.backgroundColor = [UIColor clearColor];
    
    collection.delegate = self;
    
    collection.dataSource = self;
    
    //注册单元格
    [collection registerNib:[UINib nibWithNibName:@"FoundCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    
    //注册头试图
    [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view addSubview:collection];
}

#pragma -mark UICollectionViewDelegateFlowLayout

//四周边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//单元格点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PresentController *presentVC = [[PresentController alloc]init];
    presentVC.view.backgroundColor = [UIColor whiteColor];
    //推出新的控制器
    [self.navigationController pushViewController:presentVC animated:YES];
}

#pragma -mark UICollectionViewDataSource

//组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 6;
    }else if (section == 1){
        
        return 11;
    }
    return 0;
}

//单元格内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FoundCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSArray *arr = self.dataList[indexPath.section];
    cell.model = arr[indexPath.row];
    
    return cell;
}

//头试图样式
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView* headerView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:headerView.bounds];
        
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        if (indexPath.section == 0) {
            
            titleLabel.text = @"分类";
            
        }else if (indexPath.section == 1){
            
            titleLabel.text = @"地区";
        }
        
        [headerView addSubview:titleLabel];
        
        return headerView;
    }
    return nil;
}




@end
