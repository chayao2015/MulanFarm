//
//  MapDetailVC.m
//  MulanFarm
//
//  Created by zhanbing han on 2017/5/24.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "MapDetailVC.h"
#import "ErrorInfoUtility.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "GPSNaviVC.h"
#import <AMapLocationKit/AMapLocationManager.h>

static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface MapDetailVC ()<MAMapViewDelegate, AMapLocationManagerDelegate,AMapSearchDelegate>
/* 路径规划类型 */
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapLocationManager *locationManager; //定位管理者

@property (nonatomic, strong) AMapRoute *route;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;

@end

@implementation MapDetailVC

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"地图详情";
    
//    self.startCoordinate        = CLLocationCoordinate2DMake(39.910267, 116.370888);
    self.destinationCoordinate  = CLLocationCoordinate2DMake(41.890090, 117.276375);
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-75)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    //开启定位
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    
    //创建定位管理者
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //2定位超时时间，最低2s，此处设置为10s
    _locationManager.locationTimeout =10;
    //3.逆地理请求超时时间，最低2s，此处设置为10s
    _locationManager.reGeocodeTimeout = 10;
    //开始定位
    [_locationManager startUpdatingLocation];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    [self initCompanyView];
}

- (void)initCompanyView {
    
    UIButton *naviBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-75, 70, 65, 30)];
    naviBtn.layer.cornerRadius = 5;
    [naviBtn.layer setMasksToBounds:YES];
    naviBtn.backgroundColor = AppThemeColor;
    naviBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [naviBtn setTitle:@"导航" forState:UIControlStateNormal];
    [naviBtn setImage:[UIImage imageNamed:@"Navi"] forState:UIControlStateNormal];
    [naviBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [naviBtn addTarget:self action:@selector(gpsNavAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:naviBtn];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-75, WIDTH, 75)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, WIDTH-10, 40)];
    addressLab.numberOfLines = 0;
    addressLab.text = @"地址：河北省承德市围场满族蒙古族自治县大头山乡月中";
    addressLab.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:addressLab];
    
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(5, addressLab.maxY+5, 45, 20)];
    phoneLab.text = @"电话：";
    phoneLab.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:phoneLab];
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, addressLab.maxY+5, 100, 20)];
    [phoneBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [phoneBtn setTitle:@"15737936517" forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
    phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bottomView addSubview:phoneBtn];
}

//TODO:客服电话
-(void)phoneClick
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"拨打 %@ 电话",@"15737936517"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10086;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==10086&&buttonIndex!=alertView.cancelButtonIndex){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"15737936517"]]];
    }
}

#pragma mark - 导航

- (void)gpsNavAction {
    
    GPSNaviVC *naviVC = [[GPSNaviVC alloc] init];
    naviVC.startCoordinate = _startCoordinate;
    naviVC.destinationCoordinate = _destinationCoordinate;
    [self.navigationController pushViewController:naviVC animated:YES];
}

#pragma mark - do search
- (void)searchRoutePlanningDrive
{
    self.startAnnotation.coordinate = self.startCoordinate;
    self.destinationAnnotation.coordinate = self.destinationCoordinate;
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapDrivingRouteSearch:navi];
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 5;
        polylineRenderer.lineDash = YES;
        polylineRenderer.strokeColor = AppThemeColor;
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 5;
        
//        if (naviPolyline.type == MANaviAnnotationTypeWalking)
//        {
//            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
//        }
//        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
//        {
//            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
//        }
//        else
//        {
//            polylineRenderer.strokeColor = self.naviRoute.routeColor;
            polylineRenderer.strokeColor = AppThemeColor;
//        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 6;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    poiAnnotationView.image = [UIImage imageNamed:@"railway_station"];
                    break;
                    
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;

    self.currentCourse = 0;
    
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}

#pragma mark - mapView 代理方法

//定位结果回调
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    // 定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    //设置地图中心点
    [_mapView setCenterCoordinate:location.coordinate animated:YES];
    
    _startCoordinate = location.coordinate;
    
    [self addDefaultAnnotations];
    
    [self searchRoutePlanningDrive];
    
    // 停止定位
    [_locationManager stopUpdatingLocation];
}

//当位置(经纬度/方向)更新时，会进行定位回调
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        _startCoordinate = userLocation.coordinate;
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

- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    self.destinationAnnotation = destinationAnnotation;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
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

@end
