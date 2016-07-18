//
//  MainRecommendCell.m
//  MiMi
//
//  Created by LLQ on 16/7/18.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "MainRecommendCell.h"
#import <UIImageView+WebCache.h>

@implementation MainRecommendCell

//复写model的set方法
- (void)setModel:(MainRecommendCellModel *)model{
    
    _model = model;
    
    [_backImageView  sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
    _nameLable.text = _model.section_title;
    _praise.text = _model.fav_count;
    _adress.text = _model.poi_name;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
