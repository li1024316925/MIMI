//
//  BaseModel.m
//  Timer
//
//  Created by LLQ on 16/5/17.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

//实现自定义的初始化方法
//初始化时给字点赋值
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setAttribut:dic];
    }
    return self;
}

//5.实现在初始化方法中调用的方法
//通过字典给model本身的属性赋值
-(void)setAttribut:(NSDictionary *)dic{
    //遍历新的 key--属性 的关系字典（调用生成对应关系的方法）
    NSDictionary *attributesDic = [self attributesDic:dic];
    for (NSString *key in attributesDic) {
        //取出属性名
        NSString *attribut = [attributesDic objectForKey:key];
        //调用生成set方法的方法
        SEL select = [self returnSetSelect:attribut];
        //判断能否响应该方法
        if ([self respondsToSelector:select]) {
            //取出要赋给属性的值
            id value = [dic objectForKey:key];
            //判断是否为空
            if ([value isKindOfClass:[NSNull class]]) {
                value = @"";
            }
            //调用属性的set方法
            [self performSelector:select withObject:value];
        }
    }
    
}

//4.通过字符串生成set方法（用model的属性名创建set方法）
-(SEL)returnSetSelect:(NSString *)str{
    
    //截取第一个字符为一个字符串，并转换为大写
    NSString *heade = [[str substringToIndex:1] uppercaseString];
    //截取剩余字符串
    NSString *foot = [str substringFromIndex:1];
    NSString *selectName = [NSString stringWithFormat:@"set%@%@:",heade,foot];
    
    SEL select = NSSelectorFromString(selectName);
    
    return select;
    
}

//3.实现重新给 key--属性 设置对应关系的实例方法
//如果需要，则在子类中复写此方法
-(NSDictionary *)attributesDic:(NSDictionary *)dic{
    
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
    
    for (id key in dic) {
        
        [newDic setObject:key forKey:key];//可以用任意类型作为key
        
    }
    
    return newDic;
    
}





@end
