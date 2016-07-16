//
//  LoginOrRegisterController.m
//  MiMi
//
//  Created by 张崇超 on 16/7/16.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "LoginOrRegisterController.h"
#import "CCCheckInput.h"
#import <BmobSDK/Bmob.h>
#import <SVProgressHUD.h>

@interface LoginOrRegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginOrRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//取消按钮
- (IBAction)cancleAction:(UIBarButtonItem *)sender {
    
    //关闭页面
    [self dismissViewControllerAnimated:YES completion:nil];
}

//注册按钮
- (IBAction)registerAction:(UIButton *)sender {
    
    //判断是否合格
    if ([CCCheckInput isValidateEmail:self.email.text]) {
        
        BmobUser *bUser = [[BmobUser alloc] init];

        [bUser setUsername:self.email.text];
        
        [bUser setEmail:self.email.text];
        
        [bUser setPassword:self.password.text];
        
        [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
            
            if (isSuccessful){
                
                [SVProgressHUD showSuccessWithStatus:@"注册成功,用户名即邮箱名,请激活邮箱"];
                
                //保存至本地缓存
                [BmobUser loginInbackgroundWithAccount:self.email.text andPassword:self.password.text block:^(BmobUser *user, NSError *error) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
            } else {
                
                if ([error.userInfo objectForKey:NSLocalizedDescriptionKey]) {
                    
                    [SVProgressHUD showErrorWithStatus:@"邮箱已注册,请登录"];

                }else{
                    
                    [SVProgressHUD showErrorWithStatus:@"注册失败,请重试"];
                }
            }
        }];
    }
}

//登录按钮
- (IBAction)loginAction:(UIButton *)sender {
    
    [BmobUser loginWithUsernameInBackground:self.email.text password:self.password.text block:^(BmobUser *user, NSError *error) {
       
        if (user) {
           
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"登陆成功,欢迎%@",user.username]];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
