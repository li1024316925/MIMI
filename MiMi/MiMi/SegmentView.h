//
//  SegmentView.h
//  Timer
//
//  Created by LLQ on 16/5/18.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>

//2.添加一个block属性，参数为按钮的下标，用于按钮的单击事件
//创建block类型
typedef void(^SegmentBlock)(NSInteger index);
@interface SegmentView : UIView

//1.添加按钮名数组属性，图片名属性，用于外部使用时的赋值
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imageArray;

@property(nonatomic,copy)NSString *selectImageName;

//声明
@property(nonatomic,copy)SegmentBlock segmentBlock;

//block赋值方法
-(void)setSegmentBlock:(SegmentBlock)segmentBlock;

- (instancetype)initWithFrame:(CGRect)frame WithImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray;

@end
