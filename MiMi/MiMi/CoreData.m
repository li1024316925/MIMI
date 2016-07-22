//
//  CoreData.m
//  MiMi
//
//  Created by LLQ on 16/7/22.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "CoreData.h"

@implementation CoreData

+ (void)loadDataFromTableWithName:(NSString *)tableName WithBlock:(WebDataBlock)block{
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    //通过表名创建查询类
    BmobQuery *query = [BmobQuery queryWithClassName:tableName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        for (BmobObject *object in array) {
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            //使用KVC取到obj的属性
            dataDic = [object valueForKey:@"dataDic"];
            [dataArr addObject:dataDic];
        }
        
        //block回调
        block(dataArr);
        
    }];
}

@end
