//
//  LoginOrRegisterController.m
//  MiMi
//
//  Created by 张崇超 on 16/7/16.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "LoginOrRegisterController.h"
#import "CCCheckInput.h"
#import <BmobSDK/BmobUser.h>

@interface LoginOrRegisterController ()
{
    //监听用户是否点击了注册按钮
    BOOL _isSelected;
}
/** 注册框 */
@property (weak, nonatomic) IBOutlet UIView *registerView;

/** 登录框 */
@property (weak, nonatomic) IBOutlet UIView *loginView;

/** 约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerX;

/** 手机号 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

/** 验证码 */
@property (weak, nonatomic) IBOutlet UITextField *smsCode;

/** 发送按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

//=====

/** 用户名 */
@property (weak, nonatomic) IBOutlet UITextField *userName;

/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginOrRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //检查至本地化字典中的数据
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kUserName]&&[[NSUserDefaults standardUserDefaults]objectForKey:kPassword]) {
        
        self.userName.text = [[NSUserDefaults standardUserDefaults]objectForKey:kUserName];
        
        self.password.text = [[NSUserDefaults standardUserDefaults]objectForKey:kPassword];
    }
}

//取消按钮
- (IBAction)cancleAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发送验证码
- (IBAction)sendAction:(UIButton *)sender {
    
    [self getSmsCodeFromPhone];
}

//验证验证码
- (IBAction)SuccessOrFailed:(UIButton *)sender {
    
    [self isOk];
}

//登录按钮
- (IBAction)loginAction:(UIButton *)sender {
    
    [self loginMsg];
}

//登录相关
- (void)loginMsg
{
    BmobUser *bUser = [[BmobUser alloc] init];
    
    [bUser setUsername:self.userName.text];
    
    [bUser setPassword:self.password.text];

    [bUser setMobilePhoneNumber:self.phoneNumber.text];
    
    //如果已有账号,直接登录
    if (!_isSelected) {
        
        [BmobUser loginWithUsernameInBackground:self.userName.text password:self.password.text block:^(BmobUser *user, NSError *error) {
            
            if (user) {
                
                //保存至本地化字典
                //4.
                if (_sendMessgae) {
                    
                    _sendMessgae(user.username);
                }
                //保存到本地化字典中
                [[NSUserDefaults standardUserDefaults]setObject:self.userName.text forKey:kUserName];
                
                [[NSUserDefaults standardUserDefaults]setObject:self.password.text forKey:kPassword];
                
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"欢迎回来%@",user.username]];
            } else{
                
                [SVProgressHUD showErrorWithStatus:@"用户名不存在,请完成注册"];
                
                //注册用户
                [self registerUseMsgWithUser:bUser];
            }
            
            if (error) {
                
                [SVProgressHUD showErrorWithStatus:@"用户名或密码错误,请重试"];
            }
        }];
    }
}

//注册用户
- (void)registerUseMsgWithUser:(BmobUser *)bUser
{
    //使用手机号进行注册
    [bUser signUpOrLoginInbackgroundWithSMSCode:self.smsCode.text block:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful){
            
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            
            //4.
            if (_sendMessgae) {
                
                _sendMessgae(self.userName.text);
            }
            //保存到本地化字典中
            [[NSUserDefaults standardUserDefaults]setObject:self.userName.text forKey:kUserName];
            
            [[NSUserDefaults standardUserDefaults]setObject:self.password.text forKey:kPassword];
            
            //以后可以使用这个账号进行登录
            [BmobUser loginInbackgroundWithAccount:self.phoneNumber.text andPassword:self.password.text block:nil];//手机号登录
            
            [BmobUser loginWithUsernameInBackground:self.userName.text password:self.password.text];
            
        } else {
            
            NSLog(@"注册:%@",error);
            
            [SVProgressHUD showErrorWithStatus:@"注册失败,请重试"];
        }
    }];
}

//请求验证码
- (void)getSmsCodeFromPhone
{
    if ([CCCheckInput isValidateMobile:self.phoneNumber.text]) {
        
        self.sendBtn.selected = YES;
        
        //请求验证码
        [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNumber.text    andTemplate:@"test1" resultBlock:^(int number, NSError *error) {
            
            if (error) {
                
                [SVProgressHUD showErrorWithStatus:@"发送失败,请重试"];
                
                NSLog(@"发送失败:%@",error);
            } else {
                //获得smsID
                NSLog(@"sms ID：%d",number);
                
                [SVProgressHUD showSuccessWithStatus:@"已发送,请稍后"];
            }
        }];
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
    }
}

//验证验证码
- (void)isOk
{
    //验证
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.phoneNumber.text andSMSCode:self.smsCode.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            [SVProgressHUD showSuccessWithStatus:@"验证成功"];
            
            //滑出登录页面
            [self moveRegisterViewWithDistance:-kScreenWidth+80];
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"请确认验证码是否正确"];
        }
    }];
}

//已有账号
- (IBAction)haveNumber:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    _isSelected = !sender.selected;
    
    sender.selected?[self moveRegisterViewWithDistance:-kScreenWidth+80]:[self moveRegisterViewWithDistance:0];
}

//移动注册框和登录框
- (void)moveRegisterViewWithDistance:(CGFloat )distance
{
    self.centerX.constant = distance;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

//点击控制器调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
