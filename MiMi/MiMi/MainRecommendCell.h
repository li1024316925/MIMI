//
//  MainRecommendCell.h
//  MiMi
//
//  Created by LLQ on 16/7/18.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainRecommendCellModel.h"

@interface MainRecommendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *praise;
@property (weak, nonatomic) IBOutlet UILabel *adress;

@property(nonatomic, strong)MainRecommendCellModel *model;

@end
