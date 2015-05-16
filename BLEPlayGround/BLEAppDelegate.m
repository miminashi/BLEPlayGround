//
//  BLEAppDelegate.m
//  BLEPlayGround
//
//  Created by Shiro Nohara on 2014/03/31.
//  Copyright (c) 2014年 OR6. All rights reserved.
//

#import "BLEAppDelegate.h"

#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#import <LumberjackConsole/PTEDashboard.h>

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

static const NSInteger RangingLimit = 5;

@interface BLEAppDelegate ()

@property (nonatomic) NSInteger rangingCount;

@end

@implementation BLEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[PTEDashboard sharedDashboard] show];
    DDLogInfo(@"Hello.");
    
    // Override point for customization after application launch.
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerForRemoteNotifications];
    [application registerUserNotificationSettings:settings];

    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        NSLog(@"isMonitoringAvailableForClass");
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.activityType = CLActivityTypeFitness;
        self.locationManager.distanceFilter = 100.0;
        
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6E"];  // Mamorio
//        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"00000000-7062-1001-B000-001C4D8AA76C"];  // Aplix
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.otoshimono.mamorio"];
        
        [self.locationManager requestAlwaysAuthorization];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
//    [application setKeepAliveTimeout:600 handler:^{
//        [self sendNotification:@"setKeepAliveTimeout"];
//        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
//    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)sendNotification:(NSString *)message
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = [NSDate new];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = message;
    notification.alertAction = @"Open";
//    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.soundName = nil;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus");
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"位置情報の使用を許可していない");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            [self.locationManager startUpdatingLocation];
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    [self notificationAndLog:@"didRangeBeacons"];

    for (CLBeacon *beacon in beacons) {
        NSString *message = [NSString stringWithFormat:@"UUID: %@, major: %@, minor: %@", beacon.proximityUUID, beacon.major, beacon.minor];
        [self notificationAndLog:message];
    }
    self.rangingCount += 1;

    if (self.rangingCount >= RangingLimit) {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSString *message = @"didUpdateLocations";
    [self notificationAndLog:message];
    self.rangingCount = 0;
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)notificationAndLog:(NSString *)message
{
    [self sendNotification:message];
    NSLog(@"%@", message);
    DDLogInfo(message);
}

@end
