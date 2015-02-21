//
//  BLECentralViewController.m
//  BLEPlayGround
//
//  Created by Shiro Nohara on 2015/02/21.
//  Copyright (c) 2015年 OR6. All rights reserved.
//

#import "BLECentralViewController.h"

@interface BLECentralViewController ()

@property (strong, nonatomic) CBCentralManager *manager;

@end

@implementation BLECentralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
//    [self.manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
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

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState");
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"CBCentralManagerStatePoweredOn");
        [self.manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @NO}];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"didDiscoverPeripheral");
    NSLog(@"peripheral: %@", peripheral.identifier);
    NSLog(@"advertisementData: %@", advertisementData);
}

@end
