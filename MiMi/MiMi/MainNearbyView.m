//
//  MainNearbyView.m
//  MiMi
//
//  Created by LLQ on 16/7/18.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "MainNearbyView.h"

@implementation MainNearbyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageNamed:@"wnxBG"];
        
        [self addSubview:imageView];
        
    }
    return self;
}

@end
