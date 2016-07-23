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

//页面即将消失
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //恢复导航栏
    [_rootNaviController setNavigationBarHidden:NO animated:YES];
}

//页面即将显示
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏
    _rootNaviController.navigationBarHidden = YES;
}

//初始化方法
- (instancetype)initWithRootNavigationController:(UINavigationController *)navigationController{
    self = [super init];
    if (self) {
        _rootNaviController = navigationController;
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
    _bgView.backgroundColor = [UIColor colorWithRed:56/255.0 green:191/255.0 blue:168/255.0 alpha:1];
    _bgView.alpha = 0;
    [_navigationView addSubview:_bgView];
    
    //左按钮
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 64-35, 130, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"推荐&附近" forState:UIControlStateNormal];
    leftBtn.titleLabel.textColor = [UIColor whiteColor];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 1);
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 69);
    [_navigationView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _navigationView.alpha = 1;
    
    //右按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(_navigationView.bounds.size.width-5-35, 64-35, 30, 25)];
    [rightBtn setImage:[UIImage imageNamed:@"btn_share_normal_6P"] forState:UIControlStateNormal];
    [_navigationView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_navigationView];
    
}

//左按钮点击方法
- (void)leftBtnAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//右按钮点击方法
- (void)rightBtnAction:(UIButton *)button{
    
}


#pragma mark ------ UIScrollViewDelegate

//滑动中调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取滑动距离
    float tableHeaderViewHeight = _headerView.bounds.size.height;
    float scrollSpace = scrollView.contentOffset.y+20;
    if (scrollView == _subTableView) {
        scrollSpace = scrollView.contentOffset.y;
    }
    float length = tableHeaderViewHeight - _btnsHeight - 128;
    float navigationViewHeight = _navigationView.bounds.size.height;
    
    if (scrollSpace >= length && scrollSpace < (tableHeaderViewHeight - navigationViewHeight - _btnsHeight)) {
        //剩余滑动距离
        float residue = tableHeaderViewHeight - navigationViewHeight - length;
        //比例
        float scale = (scrollSpace-length)/residue;
        if (scale<0.1) {
            scale = 0;
        }
        //透明度
        _bgView.alpha = scale;
    }
    
    //重新计算透明度
    [self reloadAlpha:scrollView];
    
    //假头视图跟随表视图滑动
    _headerView.transform = CGAffineTransformMakeTranslation(0, -scrollSpace);
    
    //按钮组滑动到导航栏时卡住
    if (scrollSpace >= tableHeaderViewHeight - _btnsHeight - navigationViewHeight) {
        _btnsView.frame = CGRectMake(0, navigationViewHeight, _btnsView.bounds.size.width, _btnsHeight);
        [self.view addSubview:_btnsView];
    }else{
        _btnsView.frame = CGRectMake(0, tableHeaderViewHeight - _btnsHeight, _btnsView.bounds.size.width, _btnsHeight);
        [_headerView addSubview:_btnsView];
    }
    
    //缩放头视图
    CGFloat fy = -scrollView.contentOffset.y;
    CGFloat hight = _headerView.frame.size.height;
    UIView *headerView = [_headerView viewWithTag:101];
    //当向下滑动时 对头视图进行缩放
    if (scrollView.contentOffset.y<0) {
        headerView.layer.anchorPoint = CGPointMake(0.5, 1);
        headerView.layer.position = CGPointMake(_headerView.center.x, 220);
        headerView.transform = CGAffineTransformMakeScale((fy+hight)/hight, (fy+hight)/hight);
    }

}

//已经结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //重新计算透明度
    [self reloadAlpha:scrollView];
}

//重新计算透明度方法
- (void)reloadAlpha:(UIScrollView *)scrollView{
    
    float length = _headerView.bounds.size.height - _btnsHeight - 128;
    float scrollSpace = scrollView.contentOffset.y + 20;
    if (scrollView == _subTableView) {
        scrollSpace = scrollView.contentOffset.y;
    }
    //重新计算透明度
    if (scrollSpace<=length) {
        _bgView.alpha = 0;
    }
    if (scrollSpace>_headerView.frame.size.height - _navigationView.bounds.size.height - _btnsHeight) {
        _bgView.alpha = 1;
    }

}


@end
