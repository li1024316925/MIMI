//
//  CCUserView.h
//  MiMi
//
//  Created by zcc on 16/7/21.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCUserView : UIView

/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;

/** 昵称 */
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

/** 所在城市 */
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

/** 城市名字 */
@property(nonatomic,copy)NSString *cityName;

/** 天气 */
@property (weak, nonatomic) IBOutlet UIImageView *weatherImgV;

//刷新天气
- (void)getWeatherMsgWithAreaid:(NSString *)areaid With:(NSString *)cityName;

@end
