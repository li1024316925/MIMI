//
//  ViewController.m
//  ASasas
//
//  Created by BEVER on 16/7/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SetingViewController.h"
#import "UIBarButtonItem+WNXBarButtonItem.h"
#define WNXScaleanimateWithDuration 0.3
@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航条上的按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithNormalImage:@"search_icon_white_6P@2x" target:self action:@selector(leftSearchClick)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"artcleList_btn_info_6P" target:self action:@selector(rightClick)];
    
    self.view.backgroundColor = WNXColor(239, 239, 244);

}
- (void)rightClick
{
    //添加遮盖,拦截用户操作
    _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _coverBtn.frame = self.navigationController.view.bounds;
    [_coverBtn addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_coverBtn];

    
}
//推出search控制器
- (void)leftSearchClick
{
    
}
//cover点击
- (void)coverClick
{
    [UIView animateWithDuration:WNXScaleanimateWithDuration animations:^{
        self.navigationController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.coverBtn removeFromSuperview];
        self.coverBtn = nil;
        self.isScale = NO;
        //当遮盖按钮被销毁时调用
        if (_coverDidRomove) {
            _coverDidRomove();
        }
    }];
}

@end
