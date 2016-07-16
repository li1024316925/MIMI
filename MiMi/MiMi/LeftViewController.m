//
//  LeftViewController.m
//  MiMi
//
//  Created by LLQ on 16/7/15.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "LeftViewController.h"
#import "LoginOrRegisterController.h"

@interface LeftViewController ()
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *foundBtn;
@property (weak, nonatomic) IBOutlet UIButton *unLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *messgeBtn;
@property (weak, nonatomic) IBOutlet UIButton *setingBtn;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)homeAction:(UIButton *)sender {
}
- (IBAction)foundAction:(UIButton *)sender {
}
- (IBAction)messgeAction:(UIButton *)sender {
}
- (IBAction)setingAction:(UIButton *)sender {
}

//注册登录
- (IBAction)loginOrRegister:(UIButton *)sender {
    
    LoginOrRegisterController *loginVC = [[LoginOrRegisterController alloc]init];
    
    //5.
    [loginVC setSendMessgae:^(NSString *userName) {
        
        self.unLoginBtn.backgroundColor = [UIColor clearColor];
        
        [self.unLoginBtn setTitle:userName forState:UIControlStateNormal];
    }];
    
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
