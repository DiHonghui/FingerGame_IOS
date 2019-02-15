//
//  BLEInfo.h
//  SZC
//
//  Created by lisy on 2018/8/19.
//  Copyright © 2018年 易用联友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEInfo : NSObject

@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (nonatomic, strong) NSNumber *rssi;

@end
