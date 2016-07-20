//
//  CCSegementView.m
//  MiMi
//
//  Created by zcc on 16/7/20.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "CCSegementView.h"

@interface CCSegementView ()

/** 分类 */
@property (weak, nonatomic) IBOutlet UIButton *cateory;

/** 地区 */
@property (weak, nonatomic) IBOutlet UIButton *area;

/** 排序 */
@property (weak, nonatomic) IBOutlet UIButton *sort;

/** 地图 */
@property (weak, nonatomic) IBOutlet UIButton *map;

@end

@implementation CCSegementView

- (void)awakeFromNib
{
}

//分类点击事件
- (IBAction)gateoryAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    NSLog(@"1");
}

//地区点击事件
- (IBAction)areaAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;

    NSLog(@"2");

}

//排序点击事件
- (IBAction)sortAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;

    NSLog(@"3");

}

//地图点击事件
- (IBAction)mapAction:(UIButton *)sender {

    sender.selected = !sender.selected;

    NSLog(@"4");

}



@end
