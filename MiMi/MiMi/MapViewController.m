//
//  MapViewController.m
//  MiMi
//
//  Created by LLQ on 16/7/23.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface MapViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locationService;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //定位
    [self locationService];
    
    //地图
    [self loadMapView];
    
    //加载返回按钮
    [self loadButtons];
    
}

//定位
- (void)locationService{
    
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    
    //启动定位
    [_locationService startUserLocationService];
    
}

//加载所有按钮
- (void)loadButtons{
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50,kScreenHeight - 50, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"discoverList_articleCountIcon_6P"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    [self.view bringSubviewToFront:backBtn];
    
    
    //定位用户位置按钮
    UIButton *userLocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, kScreenHeight - 100, 30, 30)];
    [userLocationBtn setImage:[UIImage imageNamed:@"articleList_readIcon_6P"] forState:UIControlStateNormal];
    [userLocationBtn addTarget:self action:@selector(userLocationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:userLocationBtn];
    [self.view bringSubviewToFront:userLocationBtn];
    
}


#pragma mark ------ ButtonsAction

//返回按钮方法
- (void)backBtnAction:(UIButton *)btn{
    
    //模态消失
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //回调block
    _indexBlock == nil ? : _indexBlock();
    
}

//定位用户位置按钮
- (void)userLocationBtnAction:(UIButton *)btn{
    
    //开启定位
    [_locationService startUserLocationService];
    
}

//加载地图
- (void)loadMapView{
    
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    //代理
    _mapView.delegate = self;
    
    //支持旋转
    _mapView.rotateEnabled = YES;
    //比例尺
    _mapView.showMapScaleBar = YES;
    //用户位置
    _mapView.showsUserLocation = YES;
    //地图层级
    _mapView.zoomLevel = 18;
    
    //商店大头针
    [self loadStoreAnnotationView];
    
    [self.view addSubview:_mapView];
    
}

//添加商店大头针
- (void)loadStoreAnnotationView{
    
    BMKPointAnnotation *storeAnnotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = [_model.latitude floatValue];
    coor.longitude = [_model.longitude floatValue];
    storeAnnotation.coordinate = coor;
    storeAnnotation.title = _model.poi_name;
    
    [_mapView addAnnotation:storeAnnotation];
}


#pragma mark ------ BMKLocationServiceDelegate

//位置更新时调用
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    //关闭定位
    [_locationService stopUserLocationService];
    
}


#pragma mark ------ BMKMapViewDelegate

//返回地图标记
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"storeAnnotationView"];
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    return nil;
}

@end
