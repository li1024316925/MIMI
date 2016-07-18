//
//  MainRecommendCellModel.h
//  MiMi
//
//  Created by LLQ on 16/7/18.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "BVBaseModel.h"

@interface MainRecommendCellModel : BVBaseModel

@property(nonatomic, copy)NSString *section_title;
@property(nonatomic, copy)NSString *imageURL;
@property(nonatomic, copy)NSString *fav_count;
@property(nonatomic, copy)NSString *poi_name;

@end
