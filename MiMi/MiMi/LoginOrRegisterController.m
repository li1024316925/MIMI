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

#define kUserName @"userName"
#define kPassword @"password"

@interface LoginOrRegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginOrRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserMsg];
}

//判断是否已保存用户
- (void)getUserMsg
{
    NSLog(@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserName],[[NSUserDefaults standardUserDefaults] objectForKey:kPassword]);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserName] && [[NSUserDefaults standardUserDefaults] objectForKey:kPassword]) {
        
        self.email.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        
        self.password.text = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    }
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
            
            //保存用户信息,到本地化字典
            [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:kUserName];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:kPassword];
            
            NSLog(@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserName],[[NSUserDefaults standardUserDefaults] objectForKey:kPassword]);

            [self dismissViewControllerAnimated:YES completion:nil];
            
            //4.
            if (_sendMessgae) {
                
                _sendMessgae(user.username);
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
