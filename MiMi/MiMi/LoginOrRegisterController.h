//
//  LoginOrRegisterController.h
//  MiMi
//
//  Created by 张崇超 on 16/7/16.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>

//1.定义
typedef void(^MyBlock)(NSString *);

@interface LoginOrRegisterController : UIViewController

//2
@property(nonatomic,copy)MyBlock sendMessgae;

//3
- (void)setSendMessgae:(MyBlock)sendMessgae;

@end
