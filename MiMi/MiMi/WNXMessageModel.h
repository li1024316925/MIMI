//
//  ViewController.m
//  ASasas
//
//  Created by BEVER on 16/7/16.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WNXMessageModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *message;

/* cell的高度 */
@property (nonatomic, assign) NSInteger cellHeight;

+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end
