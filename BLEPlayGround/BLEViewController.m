//
//  BLEViewController.m
//  BLEPlayGround
//
//  Created by Shiro Nohara on 2014/03/31.
//  Copyright (c) 2014年 OR6. All rights reserved.
//

#import "BLEViewController.h"

static NSString * const kCharacteristicUUID = @"54D194F1-4AD8-418C-BF0B-5757DF2B9E7A";
static NSString * const kServiceUUID = @"84752983-AD79-4E9B-A2A1-ECBC842B5D8A";

@interface BLEViewController ()

@property (nonatomic, strong) CBPeripheralManager *manager;
@property (nonatomic, strong) CBMutableService *service;

@end

@implementation BLEViewController

+ (NSArray *)characteristicUUIDs
{
    return @[@"0001", @"0002", @"0003", @"0004"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CBCharacteristic *)characteristicWithUUID:(NSString *)uuid value:(NSString *)valueString
{
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:uuid];
    CBCharacteristicProperties props = CBCharacteristicPropertyRead;
    NSData *value = [valueString dataUsingEncoding:NSUTF8StringEncoding];
    CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID properties:props value:value permissions:CBAttributePermissionsReadable];
    return characteristic;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
//        Byte byteValue = 0x10;
//        NSData *value = [NSData dataWithBytes:&byteValue length:1];

//        NSString *valueString = @"あ";
//        NSString *valueString = @"あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモーリオ市、郊外のぎらぎらひかる草の波。";
        NSString *valueString = @"あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモーリオ市、郊外のぎらぎらひかる草の波。またそのなかでいっしょになったたくさんのひとたち、ファゼーロとロザーロ、羊飼のミーロや、顔の赤いこどもたち、地主のテーモ、山猫博士のボーガント・デストゥパーゴなど、いまこの暗い巨きな石の建物のなかで考えていると、";
//        NSString *valueString = @"あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモーリオ市、郊外のぎらぎらひかる草の波。またそのなかでいっしょになったたくさんのひとたち、ファゼーロとロザーロ、羊飼のミーロや、顔の赤いこどもたち、地主のテーモ、山猫博士のボーガント・デストゥパーゴなど、いまこの暗い巨きな石の建物のなかで考えていると、みんなむかし風のなつかしい青い幻燈のように思われます。では、わたくしはいつかの小さなみだしをつけながら、しずかにあの年のイーハトーヴォの五月から十月までを書きつけましょう。";
        
//        CBCharacteristic *characteristic = [self characteristicWithUUID:@"0000" value:valueString];
        
        NSMutableArray *characteristics = [NSMutableArray array];
        for (NSString *uuidString in [[self class] characteristicUUIDs]) {
            CBCharacteristic *characteristic = [self characteristicWithUUID:uuidString value:valueString];
            [characteristics addObject:characteristic];
        }
        
        CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
        CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
//        service.characteristics = @[characteristic];
        service.characteristics = [characteristics copy];
        self.service = service;
        [self.manager addService:self.service];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    else {
        NSLog(@"didAddService");
        self.message.text = @"Advertising";
        
        NSDictionary *advertising = @{CBAdvertisementDataLocalNameKey: @"Hoge", CBAdvertisementDataServiceUUIDsKey: @[self.service.UUID]};
        [self.manager startAdvertising:advertising];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

@end
