//
//  SegmentView.m
//  Timer
//
//  Created by LLQ on 16/5/18.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "SegmentView.h"

@implementation SegmentView
{
    //全局变量，按钮的选中图片
    UIImageView *_selectImageView;
    
}

//复写init方法
- (instancetype)initWithFrame:(CGRect)frame WithImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.imageArray = imageArray;
        self.titleArray = titleArray;
    }
    
    return self;
    
}

//3.titleArray赋值时才知道要创建几个按钮，所以在这时创建按钮
-(void)setTitleArray:(NSArray *)titleArray{
    
    _titleArray = titleArray;
    NSInteger titleCount = _titleArray.count;
    for (int i = 0; i<titleArray.count; i++) {
        //添加按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*self.bounds.size.width/titleCount, 0, self.bounds.size.width/titleCount, self.bounds.size.height);
        //标题
//        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        //按钮图片
        [btn setImage:_imageArray[i] forState:UIControlStateNormal];
        //标题颜色
        [btn setTitleColor:[UIColor colorWithRed:56/255.0 green:191/255.0 blue:168/255.0 alpha:1] forState:UIControlStateNormal];
        //标题字体
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        
        //点击事件
        [btn addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        //将第一个按钮设置为选中状态
        if (i == 0) {
            btn.selected = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:25];
        }
        btn.tag = 100+i;
        
        [self addSubview:btn];
        
    }
    
}


//5.按钮点击事件
-(void)buttonSelect:(UIButton *)btn{
    
    //遍历所有的按钮，全部更改为非选中状态
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)view;
            button.selected = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:20];
            
        }
    }
    //当前点击按钮设置为选中状态
    btn.selected = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:25];
    
    //设置选中图片的位置
    NSInteger index = btn.tag-100;
    CGFloat width = self.frame.size.width/self.titleArray.count;
    
    //调用block
    if (_segmentBlock) {
        _segmentBlock(index);
    }
    //添加动画
    [UIView animateWithDuration:0.3 animations:^{
        _selectImageView.frame = CGRectMake(index * width, _selectImageView.frame.origin.y, _selectImageView.frame.size.width, _selectImageView.frame.size.height);
    }];
    
}

//当选中图片赋值时，设值选中图片的view
-(void)setSelectImageName:(NSString *)selectImageName{
    //创建图片视图
    _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-5, self.bounds.size.width/_titleArray.count, 5)];
    //拉伸图片
    UIImage *image = [[UIImage imageNamed:selectImageName] stretchableImageWithLeftCapWidth:200 topCapHeight:0];
//    image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    _selectImageView.image = image;
//    _selectImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:_selectImageView];
    
}

@end
