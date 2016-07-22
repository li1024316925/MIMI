//
//  MainPushSubTableViewCell.h
//  MiMi
//
//  Created by LLQ on 16/7/22.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPushSubTableViewCellModel.h"

@interface MainPushSubTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *pushBtn;

@property (nonatomic, strong)MainPushSubTableViewCellModel *model;

@end
