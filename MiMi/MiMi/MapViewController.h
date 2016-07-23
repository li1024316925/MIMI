//
//  MapViewController.h
//  MiMi
//
//  Created by LLQ on 16/7/23.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainRecommendCellModel.h"

typedef void(^IndexBlock)(void);

@interface MapViewController : UIViewController

@property(nonatomic, strong)MainRecommendCellModel *model;

@property(nonatomic, copy)IndexBlock indexBlock;

- (void)setIndexBlock:(IndexBlock)indexBlock;

@end
