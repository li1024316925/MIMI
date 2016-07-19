//
//  LeftViewController.m
//  MiMi
//
//  Created by LLQ on 16/7/15.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "LeftViewController.h"
#import "LoginOrRegisterController.h"
#import "LLQNavigationController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>

@interface LeftViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //头像
    UIImageView *_imageView;
    
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

        [self setUserMsg];
    }];
    //弹出模态试图
    [self presentViewController:loginVC animated:YES completion:nil];
}

//账号自动登录
- (void)autoLogin
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserName] && [[NSUserDefaults standardUserDefaults] objectForKey:kPassword]) {
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
        
        //自动登录
        [BmobUser loginWithUsernameInBackground:userName password:password block:^(BmobUser *user, NSError *error) {

            if (user) {
                
                [self setUserMsg];
                
                //设置头像
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"imageUrl"]) {
                    
                    [_imageView sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageUrl"]];
                }
                
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"欢迎回来%@",user.username]];
            }
        }];
    }
}

//设置用户信息
- (void)setUserMsg
{
    //添加一个新的View显示
    UIView *loginView = [[UIView alloc]initWithFrame:self.unLoginBtn.bounds];
    
    loginView.backgroundColor = [UIColor colorWithRed:41/255.0 green:42/255.0 blue:43/255.0 alpha:1.0];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    
    //裁剪
    _imageView.layer.cornerRadius = 10;
    
    _imageView.clipsToBounds = YES;
    
    //设置默认图片
    _imageView.image = [UIImage imageNamed:@"articleList_dogLogo"];
    
    _imageView.userInteractionEnabled = YES;
    
    //添加手势,从相册获取头像
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getPhotos)];
    
    [_imageView addGestureRecognizer:tap];
    
    [loginView addSubview:_imageView];
    
    //添加一个 UILabel 显示名字
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 100, 40)];
    
    label.textColor = [UIColor whiteColor];
    
    label.text = @"zmx";
    
    [loginView addSubview:label];
    
    [self.unLoginBtn addSubview:loginView];
}

//弹出系统相册
- (void)getPhotos
{
    //弹出系统相册
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc]init];
    
    //设置选择控制器来源
    pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    //设置代理
    pickerVC.delegate = self;
    
    [self presentViewController:pickerVC animated:YES completion:nil];
}

#pragma -mark UIImagePickerControllerDelegate

//点击相册某张图片时调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取选中的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];;
    
    //保存头像图片 思路:先把图片保存到沙盒路径Documents下,获取到路径,保存到服务器,下一次先从服务器获取路径,再从沙盒文件中获取图片
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/head.png"];
    
    //压缩图片
    float kCompressionQuality = 0.3;
    
    NSData *photo = UIImageJPEGRepresentation(image, kCompressionQuality);
    
    //保存至本地路径
    [photo writeToFile:path atomically:YES];
    
    //保存至服务器
    [self saveIamgeToServers];
    
    //设置头像
    _imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//保存图片到服务器
- (void)saveIamgeToServers
{
    NSString *path1 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/head.png"];
    
    BmobObject *obj = [[BmobObject alloc]initWithClassName:@"_User"];
    
    BmobFile *file = [[BmobFile alloc]initWithFilePath:path1];
    
    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            //此处相当于新建一条记录,关联至已有的记录请使用 [obj updateInBackground];
            [obj setObject:file forKey:@"headImage"];
            
            [obj saveInBackground];
            
            [SVProgressHUD showSuccessWithStatus:@"头像保存成功"];
            
            //保存至用户设置
            [[NSUserDefaults standardUserDefaults]setObject:file.url forKey:@"imageUrl"];
            
        }else {
            NSLog(@"%@",error);
        }
        
    } withProgressBlock:^(CGFloat progress) {
       
        NSLog(@"++++%f",progress);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
