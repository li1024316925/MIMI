//
//  CCCheckInput.h
//  MiMi
//
//  Created by 张崇超 on 16/7/16.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCCheckInput : NSObject

/** 验证手机号 */
+ (BOOL)isValidateMobile:(NSString *)mobile;

/** 验证邮箱 */
+ (BOOL)isValidateEmail:(NSString *)email;

/** 验证密码 */
+ (BOOL)isValidatePassword:(NSString *)passWord;

/** 验证昵称 */
+ (BOOL)isValidataNickname:(NSString *)nickname;

@end
