//
//  CoreData.h
//  MiMi
//
//  Created by LLQ on 16/7/22.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WebDataBlock)(NSArray *array);

@interface CoreData : NSObject

/**
 请求一个表的数据
 */
+ (void)loadDataFromTableWithName:(NSString *)tableName WithBlock:(WebDataBlock)block;


@end
