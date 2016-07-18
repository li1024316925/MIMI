//
//  PushFoundCell.m
//  MiMi
//
//  Created by 张崇超 on 16/7/18.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "PushFoundCell.h"
#import <UIImageView+WebCache.h>

@interface PushFoundCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *loveCount;

@property (weak, nonatomic) IBOutlet UILabel *address;

@end

@implementation PushFoundCell

- (void)awakeFromNib {
}

//获取数据
- (void)setModel:(PushFoundModel *)model
{
    _model = model;
    
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
    
    self.title.text = _model.section_title;
    
    self.loveCount.text = _model.fav_count;
    
    self.address.text = _model.poi_name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
