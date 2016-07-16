//
//  ViewController.m
//  ASasas
//
//  Created by BEVER on 16/7/16.
//  Copyright © 2016年 mac. All rights reserved.
//

//  消息页面点击按钮底部弹出的删除全部消息按钮

#import "WNXMessageDeleteButton.h"

@implementation WNXMessageDeleteButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:WNXGolbalGreen];
        [self setTitle:@"清除全部消息" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.hidden = YES;
    }
    
    return self;
}

- (void)showDeleteBtn
{
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -self.bounds.size.height);
    }];
}

- (void)hideDeleteBtn
{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


@end
