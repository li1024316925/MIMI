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
#import "LLQNavigationController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"

@interface LeftViewController ()
{
    //保存全局的AppDelegate对象
    AppDelegate *_appDelegate;
}
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
    
    //获取全局的AppDelegate
    _appDelegate = [UIApplication sharedApplication].delegate;
}

//主页按钮
- (IBAction)homeAction:(UIButton *)sender {
    
    [self chengeRootVCWithIndex:0];

}
//发现按钮
- (IBAction)foundAction:(UIButton *)sender {
    
    [self chengeRootVCWithIndex:1];
    
}
//消息按钮
- (IBAction)messgeAction:(UIButton *)sender {
    
    [self chengeRootVCWithIndex:2];
    
}
//设置按钮
- (IBAction)setingAction:(UIButton *)sender {
    
    [self chengeRootVCWithIndex:3];
    
}

//切换控制器方法
- (void)chengeRootVCWithIndex:(NSInteger)index{
    
    //通过AppDelegate取到控制器数组与抽屉控制器
    LLQNavigationController *rootVC = _appDelegate.viewControllers[index];
    MMDrawerController *mmdrawerVC = _appDelegate.drawerVC;
    
    //切换控制器
    [mmdrawerVC setCenterViewController:rootVC withCloseAnimation:YES completion:nil];
    
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
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
        
        //自动登录
        [BmobUser loginWithUsernameInBackground:userName password:password block:^(BmobUser *user, NSError *error) {

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
