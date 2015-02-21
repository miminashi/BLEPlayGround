//
//  BLEViewController.h
//  BLEPlayGround
//
//  Created by Shiro Nohara on 2014/03/31.
//  Copyright (c) 2014年 OR6. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEViewController : UIViewController <CBPeripheralManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *message;

@end
