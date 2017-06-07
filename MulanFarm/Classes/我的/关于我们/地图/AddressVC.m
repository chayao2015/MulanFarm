//
//  AddressVC.m
//  MulanFarm
//
//  Created by zhanbing han on 2017/5/23.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "AddressVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationManager.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CommonUtility.h"

#import "GPSNaviVC.h"

@interface AddressVC ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>
{
    //高德地图
    MAMapView *_mapView; //高德地图
    AMapLocationManager *_locationManager; //定位管理者
    CLLocation *_userLocation; //用户当前的位置
    MAPointAnnotation *_anno;
    AMapSearchAPI *_search; //搜索
    
    CLLocationCoordinate2D _startCoordinate; /* 起始点经纬度. */
    CLLocationCoordinate2D _destinationCoordinate; /* 终点经纬度. */
}

@end

@implementation AddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地图详情";
    _destinationCoordinate = CLLocationCoordinate2DMake(29.96,121.72);
    
    [self initMapView]; //高德地图
    [self initCompanyView];
}

//高德地图
- (void)initMapView {
    
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    _mapView.delegate = self;
    _mapView.showsCompass = NO; //隐藏指南针
    _mapView.showsScale = NO; //隐藏比例尺
    _mapView.rotateEnabled= NO; //禁止地图旋转
    _mapView.rotateCameraEnabled= NO; //禁止地图倾斜
    [self.view addSubview:_mapView];
    
    //开启定位
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    
    //创建定位管理者
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    [self setLocationManagerForAccuracyBest]; //十米精确度
    //开始定位
    [_locationManager startUpdatingLocation];
    
    //搜索
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}

- (void)initCompanyView {
    
    UIButton *naviBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-60, 70, 50, 30)];
    naviBtn.layer.cornerRadius = 5;
    [naviBtn.layer setMasksToBounds:YES];
    naviBtn.backgroundColor = AppThemeColor;
    naviBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [naviBtn setTitle:@"导航" forState:UIControlStateNormal];
    [naviBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [naviBtn addTarget:self action:@selector(gpsNavAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:naviBtn];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-75, WIDTH, 75)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, WIDTH-10, 40)];
    addressLab.numberOfLines = 0;
    addressLab.text = @"地址：河北省承德市围场满族蒙古族自治县大头山乡";
    addressLab.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:addressLab];
    
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(5, addressLab.maxY+5, 45, 20)];
    phoneLab.text = @"电话：";
    phoneLab.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:phoneLab];
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, addressLab.maxY+5, 100, 20)];
    [phoneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [phoneBtn setTitle:@"0314-7820003" forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
    phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bottomView addSubview:phoneBtn];
}

//打电话
- (void)phoneClick {
    [Utils call:@"0314-7820003"];
}

#pragma mark - 导航

- (void)gpsNavAction {
    
    GPSNaviVC *naviVC = [[GPSNaviVC alloc] init];
    naviVC.startCoordinate = _startCoordinate;
    naviVC.destinationCoordinate = _destinationCoordinate;
    [self.navigationController pushViewController:naviVC animated:YES];
}

#pragma mark - mapView 代理方法

//定位结果回调
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    // 定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    //更新用户位置
    _userLocation = location;
    //设置地图中心点
    [_mapView setCenterCoordinate:_userLocation.coordinate animated:YES];
    
    _startCoordinate = _userLocation.coordinate;
    
    //反地理编码出地理位置
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude];
    regeo.requireExtension =YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch:regeo];
    
    // 停止定位
    [_locationManager stopUpdatingLocation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mapView setZoomLevel:17 animated:YES];
    });
    
    [self getData]; //获取数据
}

//当位置(经纬度/方向)更新时，会进行定位回调
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        //更新用户位置
        _userLocation = userLocation.location;
        
        _startCoordinate = userLocation.coordinate;
    }
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
    if (response.regeocode !=nil ) {
        
        NSLog(@"反向地理编码回调:%@",response.regeocode.addressComponent.city);
    }
}

//地图缩放开始
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    
    _mapView.showsScale = YES; //显示比例尺
}

//地图缩放结束
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    
    _mapView.showsScale = NO; //隐藏比例尺
}

//设置标注图
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    return nil;
}

//选中标注触发方法
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    
}

//取消选中标注触发方法
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    
}

//设置十米精确度
-(void)setLocationManagerForAccuracyBest{
    
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //2定位超时时间，最低2s，此处设置为10s
    _locationManager.locationTimeout =10;
    
    //3.逆地理请求超时时间，最低2s，此处设置为10s
    _locationManager.reGeocodeTimeout = 10;
}

- (void)viewWillAppear:(BOOL)animated {
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    _mapView.showsUserLocation = NO;
    _mapView.delegate = nil;
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
