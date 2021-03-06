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
#import <CoreLocation/CoreLocation.h>
#import <WeiboSDK.h>
#import "CCUserView.h"

//回调网址
#define kRedirectUrl @"http://www.baidu.com"

@interface LeftViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    /** 用于判断点击图片的次数 */
    BOOL _isSelected;
    
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

/** 定位服务 */
@property(nonatomic,strong)CLLocationManager *locationManager;

/** 反地理编码 */
@property(nonatomic,strong)CLGeocoder *geocoder;

/** 展示用户信息 */
@property(nonatomic,strong)CCUserView *userView;

@end

@implementation LeftViewController

//状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //定位服务
    [self setLocationServers];
    
    //安全判断 ->登录
    [self autoLogin];
    
    //获取全局的AppDelegate
    _appDelegate = [UIApplication sharedApplication].delegate;
    
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutNotification:) name:kLoginOutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginBySine:) name:kLoginBySine object:nil];
}

/** 懒加载定位管家 */
-(CLLocationManager *)locationManager{
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc]init];
        
        _locationManager.delegate = self;
    }
    return _locationManager;
}

/** 懒加载反地理编码 */
-(CLGeocoder *)geocoder{
    
    if (!_geocoder) {
        
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

//设置定位服务
- (void)setLocationServers
{
    //安全判断
    if (![CLLocationManager locationServicesEnabled]) {
        
        [SVProgressHUD showSuccessWithStatus:@"硬件定位服务未开启"];
        
        return;
    }
    //请求用户开启定位服务
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        // 发出授权请求
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            // 授权请求需要对应不同的info设置
            [self.locationManager requestAlwaysAuthorization];
            // NSLocationAlwaysUsageDescription
        }
    }
    // 设置定位精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    // 设置定位距离，避免定位过于频繁,每隔多少米定位一次
    self.locationManager.distanceFilter = 10;
    
    // 开始定位
    [self.locationManager startUpdatingLocation];
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

//========
//第三方登录
- (IBAction)sinaAction:(UIButton *)sender {
    
    sender.enabled = YES;
    
    //=====认证
    //1.初始化一个oauth请求
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    
    //2.设置授权回调页
    request.redirectURI = kRedirectUrl;
    
    //3.设置授权范围
    request.scope = @"all";
    
    //4.用户信息
    request.userInfo = nil;
    
    //5.发送请求
    NSLog(@"%d",[WeiboSDK sendRequest:request]);
}

//设置用户名
- (void)loginBySine:(NSNotification *)note
{
    self.weiboBtn.enabled = NO;
    
    [self setUserMsgWithName:[note.userInfo objectForKey:@"userName"]];
}

//微信登录 ->无法注册成为开发者
- (IBAction)weiChatAction:(UIButton *)sender {

    [SVProgressHUD showErrorWithStatus:@">_<!"];
}
//========

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

        [self setUserMsgWithName:userName];
        
        [self getImageUrlFromServersWithName:userName];
    }];
    //弹出模态试图
    [self presentViewController:loginVC animated:YES completion:nil];
}

//退出登录
- (void)logoutNotification:(NSNotification *)note
{
    [self.userView removeFromSuperview];
}

//账号自动登录
- (void)autoLogin
{
    //微博登录的没有密码
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserName] && [[NSUserDefaults standardUserDefaults] objectForKey:kPassword]) {
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
        
        //自动登录
        [BmobUser loginWithUsernameInBackground:userName password:password block:^(BmobUser *user, NSError *error) {

            if (user) {
                
                [self setUserMsgWithName:user.username];
                
                //从服务器拿到头像
                [self getImageUrlFromServersWithName:user.username];
                
                //设置显示时间,默认是5秒
                [SVProgressHUD setMinimumDismissTimeInterval:2.0];

                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"欢迎回来%@",user.username]];
            }
        }];
    }
}

//设置用户信息
- (void)setUserMsgWithName:(NSString *)userName
{
    CCUserView *userView = [[[NSBundle mainBundle]loadNibNamed:@"CCUserView" owner:self options:nil]firstObject];
    
    userView.size = CGSizeMake(254, 70);
    
    //设置用户基本信息
    [userView.nameBtn setTitle:userName forState:UIControlStateNormal];
    
    //为头像添加点击事件,从相册获取头像
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getPhotos)];
    
    [userView.userImgV addGestureRecognizer:tap];
    
    //因为模拟器,定位服务无法执行,为了看到效果,直接调用
    userView.cityName = @"济南";
    
    self.userView = userView;
    
    [self.unLoginBtn addSubview:userView];
}

//从服务器拿到头像的URL ->并加载头像
- (void)getImageUrlFromServersWithName:(NSString *)name
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    
    //子查询
    [query whereKey:@"username" containedIn:@[name]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        [query getObjectInBackgroundWithId:[array[0] objectForKey:@"objectId"] block:^(BmobObject *object, NSError *error) {
            
            if (error) {
                
                NSLog(@"%@",error);
                
                return ;
            }
            if (object) {
                
                NSString *url = [object objectForKey:@"imageUrl"];
                
                [self.userView.userImgV sd_setImageWithURL:[NSURL URLWithString:url]];
            }
        }];

    }];
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
    self.userView.userImgV.image = image;
    
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
            
            //把图片的URL上传到服务器 imageUrl
            [self saveImageUrlWithURL:file.url WithID:obj.objectId];
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"保存失败,请重试"];
            
            NSLog(@"%@",error);
        }
        
    } withProgressBlock:^(CGFloat progress) {
       
        NSLog(@"++++%f",progress);
    }];
}

//保存头像的URL到服务器
- (void)saveImageUrlWithURL:(NSString *)url WithID:(NSString *)ID
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    
    [query getObjectInBackgroundWithId:ID block:^(BmobObject *object, NSError *error) {
       
        if (!error) {
            
            if (object) {
                
                BmobObject *obj = [BmobObject objectWithoutDataWithClassName:object.className objectId:object.objectId];
                
                [obj setObject:url forKey:@"imageUrl"];
                
                [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                   
                    if (error) {
                        
                        NSLog(@"aaa%@",error);
                    }else{
                        NSLog(@"success");
                    }
                }];
            }
        }else{
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma -mark CLLocationManagerDelegate

//位置发生变化时,就会调用这个方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = locations[0];
    
    //反地理编码
    [self changeLocationWithLatitude:location.coordinate.latitude WithLongitude:location.coordinate.longitude];
    
    // 停止定位服务
    [self.locationManager stopUpdatingLocation];
}

//经纬度转化成地址名称
- (void)changeLocationWithLatitude:(CGFloat )latitude WithLongitude:(CGFloat )longitude{
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) return;
        
        for (CLPlacemark *pm in placemarks) {
            
            //清空之前的地址信息,重新赋值
            if (self.userView.cityLabel.text.length >0) {
                
                self.userView.cityLabel.text = nil;
            }
            self.userView.cityLabel.text = pm.locality;
            
            //传递信息 ->用于获取天气信息
            self.userView.cityName = pm.locality;
        }
    }];
}

//控制器销毁时调用
- (void)dealloc
{
    //销毁通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
