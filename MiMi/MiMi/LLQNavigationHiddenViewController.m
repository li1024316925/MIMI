//
//  LLQNavigationHiddenViewController.m
//  MiMi
//
//  Created by LLQ on 16/7/20.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "LLQNavigationHiddenViewController.h"

@interface LLQNavigationHiddenViewController ()<UIScrollViewDelegate>
{
    UIView *_bgView;
}
@end

@implementation LLQNavigationHiddenViewController

//初始化方法
- (instancetype)initWithRootNavigationController:(UINavigationController *)navigationController{
    self = [super init];
    if (self) {
        _rootNaviController = navigationController;
        //隐藏导航栏
        _rootNaviController.navigationBarHidden = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNavigationView];
}

//加载假的导航视图
- (void)loadNavigationView{
    
    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navigationView.backgroundColor = [UIColor clearColor];
    
    //添加一个视图作为背景
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _navigationView.bounds.size.width, _navigationView.bounds.size.height)];
    _bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"recomend_btn_gone"]];
    _bgView.alpha = 0;
    [_navigationView addSubview:_bgView];
    
    //按钮
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 64-35, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_navigationView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _navigationView.alpha = 1;
    
    [self.view addSubview:_navigationView];
    
}

//左按钮点击方法
- (void)leftBtnAction:(UIButton *)button{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark ------ UIScrollViewDelegate

//滑动中调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取滑动距离
    float scrollSpace = scrollView.contentOffset.y+20;
    float length = _backTableView.tableHeaderView.bounds.size.height - 128;
    if (scrollSpace >= length && scrollSpace < (_backTableView.tableHeaderView.frame.size.height - _navigationView.bounds.size.height)) {
        //剩余滑动距离
        float residue = _backTableView.tableHeaderView.frame.size.height - _navigationView.bounds.size.height - length;
        //比例
        float scale = (scrollSpace-length)/residue;
        if (scale<0.1) {
            scale = 0;
        }
        //透明度
        [UIView animateWithDuration:0.2 animations:^{
            _bgView.alpha = scale;
        }];
    }
    //取到组头视图
//    UIView *view = [_backTableView headerViewForSection:0];
//    if (scrollSpace > _backTableView.tableHeaderView.bounds.size.height - 64) {
//        view.frame = CGRectMake(0, 64, view.bounds.size.width, view.bounds.size.height);
//        [self.view addSubview:view];
//    }
    
}
//将要结束拖动
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self reloadAlpha:scrollView];
}

//已经结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self reloadAlpha:scrollView];
}

//已经结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self reloadAlpha:scrollView];
}

//重新计算透明度方法
- (void)reloadAlpha:(UIScrollView *)scrollView{
    
    float length = _backTableView.tableHeaderView.bounds.size.height - 128;
    float scrollSpace = scrollView.contentOffset.y + 20;
    //重新计算透明度
    if (scrollSpace<=length) {
        [UIView animateWithDuration:0.3 animations:^{
            _bgView.alpha = 0;
        }];
    }
    if (scrollSpace>_backTableView.tableHeaderView.frame.size.height - _navigationView.bounds.size.height) {
        [UIView animateWithDuration:0.3 animations:^{
            _bgView.alpha = 1;
        }];
    }

}

//页面即将消失
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //恢复导航栏
    [_rootNaviController setNavigationBarHidden:NO animated:YES];
    
}


@end
