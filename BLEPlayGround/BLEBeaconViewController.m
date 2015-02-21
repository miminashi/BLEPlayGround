//
//  BLEBeaconViewController.m
//  BLEPlayGround
//
//  Created by Shiro Nohara on 2015/02/22.
//  Copyright (c) 2015年 OR6. All rights reserved.
//

#import "BLEBeaconViewController.h"

@interface BLEBeaconViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

@end

@implementation BLEBeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        NSLog(@"isMonitoringAvailableForClass");
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6E"];
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.otoshimono.mamorio"];
        
        [self.locationManager requestAlwaysAuthorization];
        
//        [self.locationManager startMonitoringForRegion:self.beaconRegion];
//        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus");
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"位置情報の使用を許可していない");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            [self.locationManager startMonitoringForRegion:self.beaconRegion];
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"didStartMonitoringForRegion: %@", region.identifier);
    [self.locationManager requestStateForRegion:region];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"didDetermineState");
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"didEnterRegion");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"didExitRegion");
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"didRangeBeacons");
    for (CLBeacon *beacon in beacons) {
        NSLog(@"UUID: %@, major: %@, minor: %@", beacon.proximityUUID, beacon.major, beacon.minor);
    }
}

@end
