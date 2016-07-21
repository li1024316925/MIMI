//
//  MXSegementView.m
//  MiMi
//
//  Created by imac on 16/7/20.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "MXSegementView.h"
#import <MJExtension.h>
#import "FoundModel.h"
#import "MXSegementCellCollectionViewCell.h"

@interface MXSegementView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

//存放集合视图数据源
@property (nonatomic,strong)NSMutableArray *datalist;

@end

@implementation MXSegementView


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        //cell的大小
        layout.itemSize = CGSizeMake(90, 110);
        //水平方向
        layout.minimumInteritemSpacing = (kScreenWidth-90*3-40)/4;
        //垂直方向
        layout.minimumLineSpacing = (kScreenWidth-90*3-40)/4;
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
       
        UICollectionView *collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, self.bounds.size.height-44-64) collectionViewLayout:layout];
        
        //签订代理
        collectionview.delegate = self;
        collectionview.dataSource = self;
        
        //Xib->注册
        [collectionview registerNib:[UINib nibWithNibName:@"SegementCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Segement_Cell"];
                
        //添加集合视图
        [self addSubview:collectionview];
        
        //添加取消按钮视图
        [self addCancleView];
    }

    return self;
}

//添加取消按钮视图
-(void)addCancleView{
    
    UIView *cancleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-44, kScreenWidth, 44)];
    cancleView.backgroundColor = [UIColor blackColor];
    
    //添加 button
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2-22, 0, 44, 44)];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [cancleView addSubview:cancleBtn];
    
    //添加点击事件
    [cancleBtn addTarget:self action:@selector(cancleAct:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancleView];

}

//取消当前页面显示
-(void)cancleAct:(UIButton *)btn{
   
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 0;
    }];
}

//懒加载数据源数组 + 解析数据
-(NSMutableArray *)datalist{

    if (!_datalist) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"foundData" ofType:@"plist"];

        NSArray *array = [NSArray arrayWithContentsOfFile:path];

        _datalist = [self analysisArr:array];
        
    }
    return _datalist;
}
//解析
-(NSMutableArray *)analysisArr:(NSArray *)arr{

    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    [array addObjectsFromArray:[FoundModel mj_objectArrayWithKeyValuesArray:arr[0]]];
    [array addObjectsFromArray:[FoundModel mj_objectArrayWithKeyValuesArray:arr[1]]];

    return array;
}


#pragma mark - datasource
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.datalist.count;
}

//item的对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MXSegementCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Segement_Cell" forIndexPath:indexPath];

    cell.model = self.datalist[indexPath.row];
    
    return cell;
}

//设置单元格与控件边缘的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

//点击cell调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
#pragma mark --- 界面消失?
    
    
}





@end
