//
//  MXSegementCellCollectionViewCell.h
//  MiMi
//
//  Created by imac on 16/7/21.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoundModel.h"
@interface MXSegementCellCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (nonatomic,strong)FoundModel *model;

@end
