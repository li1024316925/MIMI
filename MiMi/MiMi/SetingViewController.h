//
//  ViewController.m
//  ASasas
//
//  Created by BEVER on 16/7/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^coverDidRomove)();
@interface SetingViewController : UIViewController

//** 遮盖按钮 */
@property (nonatomic, strong) UIButton *coverBtn;

@property (nonatomic, strong) coverDidRomove coverDidRomove;

@property (nonatomic, assign) BOOL isScale;

- (void)coverClick;

@end
