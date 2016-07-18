//
//  BaseModel.h
//  Timer
//
//  Created by LLQ on 16/5/17.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseModel : NSObject

//.h文件
//.m文件
//1.声明一个通过字典来初始化的实例方法（调用此方法，对model初始化的同时，完成对属性的赋值）
-(instancetype)initWithDic:(NSDictionary *)dic;
//声明一个实例方法，用于子类的复写，可以实现当字典中的key与model中的属性名不对应时的手动对应
-(NSDictionary *)attributesDic:(NSDictionary *)dic;

@end
