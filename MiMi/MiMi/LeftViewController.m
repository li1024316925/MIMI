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

@interface LeftViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    //地理位置
    UILabel *_locationLabel;
    
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

/** 定位服务 */
@property(nonatomic,strong)CLLocationManager *locationManager;

/** 反地理编码 */
@property(nonatomic,strong)CLGeocoder *geocoder;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //定位服务
    [self setLocationServers];
    
    //安全判断 ->登录
    [self autoLogin];
    
    //获取全局的AppDelegate
    _appDelegate = [UIApplication sharedApplication].delegate;
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
                
                [self setUserMsgWithName:user.username];
                
                //设置头像
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"imageUrl"]) {
                    
                    [_imageView sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageUrl"]];
                }
                
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
    
    label.text = userName;
    
    [loginView addSubview:label];
    
    //添加一个现实地理位置的 Label
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 10, 80, 40)];
    
    _locationLabel.textColor = [UIColor whiteColor];
    
    [loginView addSubview:_locationLabel];
    
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
            
            _locationLabel.text = pm.locality;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
