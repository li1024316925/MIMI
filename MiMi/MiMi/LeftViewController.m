//
//  LeftViewController.m
//  MiMi
//
//  Created by LLQ on 16/7/15.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "LeftViewController.h"
#import "LoginOrRegisterController.h"
#import <BmobSDK/Bmob.h>
#import "WNXMessageViewController.h"
#import "WNXSetingViewController.h"

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
    
    //安全判断 ->登录
    [self autoLogin];

}

- (IBAction)homeAction:(UIButton *)sender {
}
- (IBAction)foundAction:(UIButton *)sender {
}
- (IBAction)messgeAction:(UIButton *)sender {
    
    [self presentViewController:[[WNXMessageViewController alloc]init] animated:YES completion:nil];
}
- (IBAction)setingAction:(UIButton *)sender {
    
    [self presentViewController:[[WNXSetingViewController alloc]init] animated:YES completion:nil];
}

//注册登录
- (IBAction)loginOrRegister:(UIButton *)sender {
    
    LoginOrRegisterController *loginVC = [[LoginOrRegisterController alloc]init];
    
    //5.
    [loginVC setSendMessgae:^(NSString *userName) {
        
        [self.unLoginBtn setTitle:userName forState:UIControlStateNormal];
    }];
    
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)autoLogin
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserName] && [[NSUserDefaults standardUserDefaults] objectForKey:kPassword]) {
        
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
        
        //自动登录
        [BmobUser loginWithUsernameInBackground:email password:password block:^(BmobUser *user, NSError *error) {

            if (user) {
                
                [self.unLoginBtn setTitle:user.username forState:UIControlStateNormal];

                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"欢迎回来%@",user.username]];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
