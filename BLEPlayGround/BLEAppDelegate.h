//
//  BLEAppDelegate.h
//  BLEPlayGround
//
//  Created by Shiro Nohara on 2014/03/31.
//  Copyright (c) 2014年 OR6. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@interface BLEAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;

@end
