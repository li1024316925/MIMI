//
//  MainRecommendTableHeaderView.h
//  MiMi
//
//  Created by LLQ on 16/7/18.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainRecommendGroupModel.h"

@interface MainRecommendTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property(nonatomic, strong)MainRecommendGroupModel *model;

@end
