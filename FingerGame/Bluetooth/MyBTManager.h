//
//  MyBTManager.h
//  SZC
//
//  Created by lisy on 2019/2/28.
//  Copyright © 2019 易用联友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^CompleteBlock)(BOOL state);
typedef void(^ReadValueReturnBlock)(NSString *data);

//协议
@protocol MyBTManagerProtocol <NSObject>
@optional
//获取蓝牙连接状态
- (void)receiveBLELinkState:(BOOL)state;
//收到蓝牙设备传回的数据
- (void)receiveDataFromBLE:(NSString *)sdata;

@end

@interface MyBTManager : NSObject
//代理
@property (nonatomic, weak) id<MyBTManagerProtocol> delegate;
//单例
+ (MyBTManager *)sharedInstance;
//获得搜索到的周围设备
- (NSMutableArray *)getSurroundedBLEDevices;
//连接外设
- (void)connectPeripheral:(CBPeripheral *)peripheral finish:(CompleteBlock)completeblock;
//读取外设传回的值
- (void)readValueWithBlock:(ReadValueReturnBlock)readValueReturnBlock;
//写入数据
- (void)writeToPeripheral:(NSString *)string;

@end
