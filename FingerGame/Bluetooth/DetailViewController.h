//
//  DetailViewController.h
//  SZC
//
//  Created by lisy on 2018/8/19.
//  Copyright © 2018年 易用联友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DetailViewController : UIViewController<
CBPeripheralManagerDelegate,
CBCentralManagerDelegate,
CBPeripheralDelegate
>

@property (nonatomic, strong) CBCentralManager *centralMgr;
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic* writeCharacteristic;
@property (strong,nonatomic) CBCharacteristic* readNowC;

@end
