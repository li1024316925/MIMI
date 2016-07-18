//
//  MainRecommendGroupModel.h
//  MiMi
//
//  Created by LLQ on 16/7/18.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVBaseModel.h"

@interface MainRecommendGroupModel : BVBaseModel

@property(nonatomic, copy)NSString *color;
@property(nonatomic, copy)NSString *tag_name;
@property(nonatomic, copy)NSString *section_count;
@property(nonatomic, strong)NSArray *body;

@end
