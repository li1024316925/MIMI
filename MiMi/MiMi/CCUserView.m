//
//  CCUserView.m
//  MiMi
//
//  Created by zcc on 16/7/21.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "CCUserView.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

#define kAppID @"22244"
#define kAppKey @"a8d4ca25a8b140ffa589176c63375cbf"

@interface CCUserView ()

/** 网络管家 */
@property(nonatomic,strong)AFHTTPSessionManager *manager;

@end

@implementation CCUserView

/** 懒加载网络管家 */
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        
        _manager = [AFHTTPSessionManager manager];
        
        //设置请求格式
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];//默认格式
        
        //设置返回参数格式
        _manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    }
    return _manager;
}

//获取城市信息,根据城市名字,获取当前天气情况
- (void)setCityName:(NSString *)cityName
{
    _cityName = cityName;
    
    [self getWeatherMsgWithAreaid:@"101120101" With:cityName];
}

//请求数据
- (void)getWeatherMsgWithAreaid:(NSString *)areaid With:(NSString *)cityName
{
    NSString *url = @"http://route.showapi.com/9-2";
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObject:kAppID forKey:@"showapi_appid"];
    
    [parameter setObject:kAppKey forKey:@"showapi_sign"];
    
    [parameter setObject:areaid forKey:@"areaid"];
    
    [parameter setObject:cityName forKey:@"area"];
    
    [self.manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dayDic = [responseObject objectForKey:@"showapi_res_body"];
        
        NSDictionary *dic = [dayDic objectForKey:@"now"];
        
        [self.weatherImgV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"weather_pic"]]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败！"];
        
        NSLog(@"error:%@",error);
    }];
}

@end
