//
//  FoundCell.m
//  MiMi
//
//  Created by 张崇超 on 16/7/16.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "FoundCell.h"
#import <UIImageView+WebCache.h>

@interface FoundCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation FoundCell

- (void)awakeFromNib {
}

//获取数据
- (void)setModel:(FoundModel *)model
{
    _model = model;
    
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.icon]];
    
    self.label1.text = model.title;
    
    self.label2.text = [NSString stringWithFormat:@"%ld",[model.subTitle integerValue]];
}

@end
