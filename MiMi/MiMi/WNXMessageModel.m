//
//  ViewController.m
//  ASasas
//
//  Created by BEVER on 16/7/16.
//  Copyright © 2016年 mac. All rights reserved.
//
//  消息的模型

#import "WNXMessageModel.h"
#import <MJExtension.h>

@implementation WNXMessageModel

+ (instancetype)messageWithDict:(NSDictionary *)dict
{
    WNXMessageModel *model = [[self alloc] init];
    [model mj_setKeyValues:dict];
    
    return model;
}

@end
