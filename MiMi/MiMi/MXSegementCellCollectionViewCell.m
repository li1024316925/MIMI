//
//  MXSegementCellCollectionViewCell.m
//  MiMi
//
//  Created by imac on 16/7/21.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "MXSegementCellCollectionViewCell.h"

@implementation MXSegementCellCollectionViewCell



-(void)setModel:(FoundModel *)model{

    _model = model;
    
    _imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.icon]];
    
    _title.text = _model.title;

    _title.textColor = [UIColor whiteColor];
}



@end
