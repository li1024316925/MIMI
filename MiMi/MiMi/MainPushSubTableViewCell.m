//
//  MainPushSubTableViewCell.m
//  MiMi
//
//  Created by LLQ on 16/7/22.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "MainPushSubTableViewCell.h"

@implementation MainPushSubTableViewCell

//复写set方法
- (void)setModel:(MainPushSubTableViewCellModel *)model{
    
    _model = model;
    _titleLable.text = _model.title;
    _content.text = _model.content;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
