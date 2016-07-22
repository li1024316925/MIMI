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
/**
 纬度
 */
@property(nonatomic, copy)NSString *latitude;
/**
 经度
 */
@property(nonatomic, copy)NSString *longitude;

@property(nonatomic, copy)NSString *TEL;
@property(nonatomic, copy)NSString *openTime;
@property(nonatomic, copy)NSString *averageSpend;

@end
