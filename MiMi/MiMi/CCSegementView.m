//
//  CCSegementView.m
//  MiMi
//
//  Created by zcc on 16/7/20.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "CCSegementView.h"
#import "MXSegementView.h"
#import "UIView+ViewController.h"

@interface CCSegementView ()

/** 分类 */
@property (weak, nonatomic) IBOutlet UIButton *cateory;

/** 地区 */
@property (weak, nonatomic) IBOutlet UIButton *area;

/** 排序 */
@property (weak, nonatomic) IBOutlet UIButton *sort;

/** 地图 */
@property (weak, nonatomic) IBOutlet UIButton *map;



@property (nonatomic,strong)UIView *cancleView;

@end

@implementation CCSegementView

- (void)awakeFromNib
{
}

//根据按钮状态显示/隐藏视图
-(void)didshowView:(UIButton *)btn{

    UIView *segementBackView = [self.viewController.view viewWithTag:301];
    UITableView *tabview = [self.viewController.view viewWithTag:310];
    
    //显示/隐藏 segementview
    if (btn.selected) {
        
            [UIView animateWithDuration:0.2 animations:^{
                
                segementBackView.alpha = 0.9;
                self.cancleView.alpha = 0.9;
                tabview.scrollEnabled = NO;
                btn.alpha = 0.95;
                
            }];
        
    }else {//隐藏
    
        [UIView animateWithDuration:0.2 animations:^{
            
            segementBackView.alpha = 0;
            self.cancleView.alpha = 0;
            tabview.scrollEnabled = YES;
            btn.alpha = 0.7;
            
        }];
    
    }
    
}


//分类点击事件
- (IBAction)gateoryAction:(UIButton *)sender {
   
    sender.selected = !sender.selected;
   
    [self didshowView:sender];
    
}

//地区点击事件
- (IBAction)areaAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;

    [self didshowView:sender];

}

//排序点击事件
- (IBAction)sortAction:(UIButton *)sender {

    sender.selected = !sender.selected;

    [self didshowView:sender];

}

//地图点击事件
- (IBAction)mapAction:(UIButton *)sender {

    sender.selected = !sender.selected;

    NSLog(@"4");
    
    
#warning map........
    
    

}





@end
