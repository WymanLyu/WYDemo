//
//  WYLocationManager.m
//  WYCoreLocationDemo
//
//  Created by sialice on 16/5/29.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYLocationManager.h"

#define isIOS(version) ([[UIDevice currentDevice].systemVersion floatValue] > (version))

@interface WYLocationManager ()<CLLocationManagerDelegate>

/** 位置管理者 */
@property (nonatomic, strong) CLLocationManager *manager;

/** 地理编码器 */
@property (nonatomic, strong) CLGeocoder *geoCoder;

/** 定位结果回调block */
@property (nonatomic, copy) LocationResultBlock locationResultBlock;

/** 区域监听回调block */
@property (nonatomic, copy) RegionMonitorBlock regionMonitorBlock;

@end

@implementation WYLocationManager

#pragma mark - 单例
static WYLocationManager *_instance;
+ (instancetype)shareManager {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance= [[WYLocationManager alloc] init];
        });
    }
    return _instance;
}

#pragma mark - 懒加载
- (CLLocationManager *)manager {
    if (!_manager) {
        // 1.创建管理者
        _manager = [[CLLocationManager alloc] init];
        
        // 2.设置代理
        _manager.delegate = self;
        
        // 3.请求定位（iOS8.0以上）
        
/// ********************   根据info的配置设置对应的定位请求        *******************///
        
        // 3.1.获取info字典
        NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
        // 3.2.获取所有后台模式
        NSArray *backgroundModes = infoDict[@"UIBackgroundModes"];
        
        if (isIOS(8.0)) {
            // 1.获取定位类型
            NSString *whenInUseMode = infoDict[@"NSLocationWhenInUseUsageDescription"];
            NSString *alwaysMode = infoDict[@"NSLocationAlwaysUsageDescription"];
            
            if (alwaysMode.length > 0) { // 申请定位模式为：总是允许 (即便申请两种都结果是总是)
                // 申请该模式授权
                [_manager requestAlwaysAuthorization];
            }else if (whenInUseMode.length > 0) { // 申请定位模式为：仅当使用
                // 默认无后台，则检测是否开启后台，并提示
                if (![backgroundModes containsObject:@"location"]) { // 没有配置允许后台定位
                    NSLog(@"iOS8.0系统以上，请求whenInUse模式的定位默认无后台定位，如需后台定位请配置后台支持定位，但在后台定位时会有蓝边现象");
                }else { // 允许后台
                    // 适配iOS9.0
                    if (isIOS(9.0)) { // 9.0在该模式下请求后台需要代码再确定
                        _manager.allowsBackgroundLocationUpdates = YES;
                    }
                }
                // 申请该模式授权
                [_manager requestWhenInUseAuthorization];
            }else { // 没有配置key
                NSLog(@"iOS8.0以上定位需要主动请求，该请求要在info中配置对应模式的key：NSLocationWhenInUseUsageDescription（默认只在前台）或者NSLocationAlwaysUsageDescription（总是允许）");
            }
            
        }else {
            if (![backgroundModes containsObject:@"location"]) {
                NSLog(@"在iOS8.0之前,如果想要在后台进行定位,必须开启后台模式 location updates");
            }
        }
        
    }
    return _manager;
}

- (CLGeocoder *)geoCoder {
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

#pragma mark - 获取位置
- (void)getCurrentLocation:(LocationResultBlock)resultBlock {
    // 1.记录回调block
    self.locationResultBlock = resultBlock;
    
    // 2.请求定位
//    extern const CLLocationAccuracy kCLLocationAccuracyBest;
//    extern const CLLocationAccuracy kCLLocationAccuracyNearestTenMeters;
//    extern const CLLocationAccuracy kCLLocationAccuracyHundredMeters;
//    extern const CLLocationAccuracy kCLLocationAccuracyKilometer;
//    extern const CLLocationAccuracy kCLLocationAccuracyThreeKilometers;
    self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 百米
    [self.manager startUpdatingLocation];
}

#pragma mark - 区域监听
- (void)monitorRegionPlace:(NSString *)placeName InRadius:(CGFloat)radius callBackBlock:(RegionMonitorBlock)resultBlock {
    // 1.记录回调block
    self.regionMonitorBlock = resultBlock;
    
    // 2.请求区域监听
    // 2.1.检测半径有无越界
    if (radius > [self.manager maximumRegionMonitoringDistance]) {
        radius = [self.manager maximumRegionMonitoringDistance];
    }
    
    // 2.2.反地理编码
    [self.geoCoder geocodeAddressString:placeName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 1.获取相关度最大的地标
        CLPlacemark *placeMark = [placemarks firstObject];
        
        // 2.获取经纬度
        CLLocation *location = placeMark.location;
        CLLocationCoordinate2D coordinate2D = location.coordinate;
        
        // 3.根据经纬度和半径创建区域
        CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:coordinate2D radius:radius identifier:@"region"];
        
        // 4.开始监听
//        [self.manager startMonitoringForRegion:region]; // 回调两个
        [self.manager requestStateForRegion:region];
    }];
}

#pragma mark - CLLocationManagerDelegate
/** 授权状态改变 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: // 未决定
        {
            NSLog(@"用户还未决定");
            break;
        }
        case kCLAuthorizationStatusRestricted: // 设备受限制
        {
            NSLog(@"设备受限制");
            break;
        }
        case kCLAuthorizationStatusDenied: // 用户拒绝
        {
            
            if ([CLLocationManager locationServicesEnabled]) { // 服务开启
                    if (isIOS(8.0)) { // 跳转到设置界面
                        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        }
                    } else {
                        NSLog(@"用户拒绝了，iOS8.0以下，无法主动跳转至设置界面");
                    }
                    
                } else { // 服务关闭
                    NSLog(@"定位服务关闭");
                }
                break;
        }
            
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"前后台定位授权");
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"前台定位授权");
            break;
            
        default:
            break;
    }
}


/** 获取到位置 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 1.获取最后位置
    CLLocation *location = [locations lastObject];
    
    // 2.获取地标
    if (location.horizontalAccuracy > 0) { // 判断所获取地址是或否合理
        // 获取地标(反地理编码)
        [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                // 获取最相关（第一个）的地标
                CLPlacemark *placeMark = [placemarks firstObject];
                
                // 返回
                self.locationResultBlock(location, placeMark, nil);
                
            }else { // 反地标编码错误
                self.locationResultBlock(location, nil, @"反地理编码错误，无法获取地标");
            }
        }];
    }else {
        // 回调错误
        self.locationResultBlock(nil, nil, @"位置不可用");
    }
    
    // 3.停止监听
    [self.manager stopUpdatingLocation];
}

/**  当定位失败的时候会调用该方法 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

/** 区域改变 */
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {

    switch (state) {
        case CLRegionStateUnknown: // 未知
        {
            self.regionMonitorBlock(NO, @"位置状态");
            break;
        }
        case CLRegionStateInside: // 进入
        {
            self.regionMonitorBlock(YES, nil);
            break;
        }
     case CLRegionStateOutside: // 离开
        {
            self.regionMonitorBlock(NO, nil);
            break;
        }
    }
}

/** 区域过多 */
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    // 移除最远的区域
    
    // 1.获取当前位置
    [self getCurrentLocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
        if (error) return ;
        CLCircularRegion *maxRegion = nil;
        CLLocationDistance maxDistance = 0.0;
        
        // 1.获取距离
        for (CLCircularRegion *region in self.manager.monitoredRegions) {
            // 1.区域位置
            CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
            
            // 2.计算距离
            CLLocationDistance distance = [location distanceFromLocation:centerLocation];
            
            // 3.比较距离
            if (maxDistance < distance) { // 比上次大则记录
                maxDistance = distance;
                maxRegion = region;
            }
        }
        
        // 2.移除最大区域的监听
        [self.manager stopMonitoringForRegion:maxRegion];
    }];
   
}

@end
