//
//  MainCellPushController.m
//  MiMi
//
//  Created by LLQ on 16/7/20.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "MainCellPushController.h"
#import "SegmentView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <MapKit/MapKit.h>
#import "MainPushSubTableViewCellModel.h"
#import "MainPushSubTableViewCell.h"

typedef void(^ModelDataBlock)(NSString *str);

@interface MainCellPushController ()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate>
{
    UIView *_navigationView;
    UITableView *_backTableView;
    UITableView *_subTableView;
    NSMutableArray *_subDataArray;
}
@end

@implementation MainCellPushController

//还原所有视图形变
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self btnsViewAction:0];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //最底层tableView
    [self loadBackTableView];
    
    //子表视图
    [self createSubTableView];
    
    //加载子表视图数据
    [self loadSubTableViewData];
    
}

//将model的数据存入数组
- (void)loadSubTableViewData{
    
    _subDataArray = [[NSMutableArray alloc] init];
    
    //反地理编码
    [self reverseGeocodeLocationWithBlock:^(NSString *str) {
       
        //将model的数据存入数组
        MainPushSubTableViewCellModel *model = [[MainPushSubTableViewCellModel alloc] initWithDic:@{@"title":_model.poi_name,@"content":str}];
        [_subDataArray addObject:model];
        [_subDataArray addObject:[[MainPushSubTableViewCellModel alloc] initWithDic:@{@"title":@"电话",@"content":_model.TEL}]];
        [_subDataArray addObject:[[MainPushSubTableViewCellModel alloc] initWithDic:@{@"title":@"营业时间",@"content":_model.openTime}]];
        [_subDataArray addObject:[[MainPushSubTableViewCellModel alloc] initWithDic:@{@"title":@"人均消费",@"content":_model.averageSpend}]];
        
        //刷新表视图
        [_subTableView reloadData];
        
    }];
    
    
}

//反地理编码
- (void)reverseGeocodeLocationWithBlock:(ModelDataBlock)block{
    
    //地理编码器
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //位置
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[_model.latitude floatValue] longitude:[_model.longitude floatValue]];
    //地理编码
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        CLPlacemark *placemark = placemarks[0];
        //回调block
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:placemark.addressDictionary];
        NSString *address = [dic objectForKey:@"Name"];
        block(address);
    }];
    
}

//主表视图
- (void)loadBackTableView{
    
    //创建表视图
    _backTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight+20) style:UITableViewStyleGrouped];
    _backTableView.dataSource = self;
    _backTableView.delegate = self;
    //表视图的头视图
    [self createTableHeaderView];
    
    //将表视图添加在假头视图之下
    [self.view insertSubview:_backTableView belowSubview:self.headerView];
}

//创建子表视图
- (void)createSubTableView{
    
    _subTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, -20, kScreenWidth, kScreenHeight+20) style:UITableViewStyleGrouped];
    _subTableView.delegate = self;
    _subTableView.dataSource = self;
//    _subTableView.rowHeight = 90;
    self.subTableView = _subTableView;
    //头视图
    [self createSubTableHeaderView];
    
    //注册单元格
    [_subTableView registerNib:[UINib nibWithNibName:@"MainPushSubTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"pushSubTableViewCell"];
    
    //添加到假头视图之下
    [self.view insertSubview:_subTableView belowSubview:self.headerView];
    
}

//子表视图的头视图
- (void)createSubTableHeaderView{
    
    //头视图
    UIView *subHeaderview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 280+280)];
    
    //创建地图
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 280, kScreenWidth, 280)];
    [subHeaderview addSubview:mapView];
    mapView.delegate = self;
    
    //添加大头针视图
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = [self.model.latitude floatValue];
    coor.longitude = [self.model.longitude floatValue];
    annotation.coordinate = coor;
    annotation.title = self.model.poi_name;
    [mapView addAnnotation:annotation];
    //设置地图显示区域
    mapView.zoomLevel = 20;
    [mapView setCenterCoordinate:coor animated:YES];
    
    _subTableView.tableHeaderView = subHeaderview;
    
}

//创建表头视图
- (void)createTableHeaderView{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
    self.headerView = headerView;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
    
    //按钮组
    self.btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 220, kScreenWidth, 60)];
    self.btnsHeight = 60;
    self.btnsView.backgroundColor = [UIColor whiteColor];
    //添加阴影效果
    [self viewAddShadow:self.btnsView];
    [headerView addSubview:self.btnsView];
    //创建分页按钮
    SegmentView *segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth-100, 60) WithImageArray:@[[UIImage imageNamed:@"groom"],[UIImage imageNamed:@"info"]] titleArray:@[@"推荐",@"信息"]];
    segmentView.selectImageName = @"discoverList_selectButton";
    
    //按钮点击事件
    [segmentView setSegmentBlock:^(NSInteger index) {
        [self btnsViewAction:index];
    }];
    
    [self.btnsView addSubview:segmentView];
    
    //图片视图
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerView.bounds.size.width, 220)];
    headerImageView.tag = 101;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageURL]];
    [headerView addSubview:headerImageView];
    
    _backTableView.tableHeaderView = tableHeaderView;
    //将假头视图添加在假导航视图之下
    [self.view insertSubview:self.headerView belowSubview:self.navigationView];
    
}

//按钮点击事件
- (void)btnsViewAction:(NSInteger)index{
    
    if (index == 0) {
        //还原
        [UIView animateWithDuration:0.3 animations:^{
            _subTableView.transform = CGAffineTransformIdentity;
            _backTableView.transform = CGAffineTransformIdentity;
        }];
    }else if (index == 1){
        //偏移
        [UIView animateWithDuration:0.3 animations:^{
            _subTableView.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
            _backTableView.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
        }];
    }
    
}

//给视图添加阴影效果
- (void)viewAddShadow:(UIView *)view{
    
    //设置阴影颜色与颜色透明度
    view.layer.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0.8].CGColor;
    //阴影偏移
    view.layer.shadowOffset = CGSizeMake(3, 3);
    //阴影透明度
    view.layer.shadowOpacity = 0.5;
    //阴影圆角
    view.layer.shadowRadius = 3;
    
}


#pragma mark ------ UITableViewDataSource 和 UITableViewDelegate

//返回每组单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _subTableView) {
        
        return _subDataArray.count;
        
    }else if (tableView == _backTableView){
        
        return 25;
        
    }
    
    return 0;
    
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _subTableView) {
        
        //复用单元格
        MainPushSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushSubTableViewCell"];
//        if (cell == nil) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"MainPushSubTableViewCell" owner:self options:nil] lastObject];
//        }
        //配置单元格
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
        
    }else if (tableView == _backTableView){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"backCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"backCell"];
        }
        
        return cell;
        
    }
    
    return nil;
    
}

//配置单元格
- (void)configureCell:(MainPushSubTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.pushBtn.hidden = NO;
    }else{
        cell.pushBtn.hidden = YES;
    }
    cell.model = _subDataArray[indexPath.row];
}

#pragma mark ------ UITableViewDelegate

//返回单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _subTableView) {
        
        //高度自适应
        return [tableView fd_heightForCellWithIdentifier:@"pushSubTableViewCell" configuration:^(id cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
        
    }else if (tableView == _backTableView){
        
        return 20;
        
    }
    
    return 0;
    
}

#pragma mark ------ BMKMapViewDelegate

//返回标注视图
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        //创建标注视图
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
        //标注视图颜色
        annotationView.pinColor = BMKPinAnnotationColorPurple;
        //动画效果
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    
    return nil;
}

@end
