//
//  MyBTManager.m
//  SZC
//
//  Created by lisy on 2019/2/28.
//  Copyright © 2019 易用联友. All rights reserved.
//

#import "MyBTManager.h"
#import "BLEInfo.h"

@interface MyBTManager()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) CBUUID *serviceUUID;
@property (nonatomic, strong) CBUUID *readUUID;
@property (nonatomic, strong) CBUUID *writeUUID;

@property (nonatomic, strong) CBCharacteristic *characteristic;

@property (nonatomic, strong) NSMutableArray *deviceArray;

@property (nonatomic,copy) CompleteBlock completeBlock;

@end

//单例静态对象
static MyBTManager *sInstance = nil;

@implementation MyBTManager

#pragma mark - 单例对象
+ (MyBTManager *)sharedInstance{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[MyBTManager alloc] init];
    });
    NSLog(@"create Bluetooth instance");
    return sInstance;
}

#pragma mark - 初始化
- (id)init {
    self = [super init];
    if (self) {
        //中央管理
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
        //
        _deviceArray = [[NSMutableArray alloc] init];
        //
    }
    return self;
}
#pragma mark - Object Methods
- (NSMutableArray *)getSurroundedBLEDevices{
    [self.centralManager stopScan];
    NSLog(@"停止搜索");
    NSLog(@"发现设备数量：%d",[_deviceArray count]);
    return _deviceArray;
}

- (void)connectPeripheral:(CBPeripheral *)peripheral finish:(CompleteBlock)completeblock{
    if (peripheral){
        [self.centralManager setDelegate:self];
        self.peripheral = peripheral;
        self.completeBlock = completeblock;
        NSLog(@"开始连接蓝牙：%@",self.peripheral.name);
        [self.centralManager connectPeripheral:self.peripheral options:nil];
    }
    else
        NSLog(@"未找到该设备");
}

- (void)readValue{
    if (self.peripheral && self.characteristic){
        [self.peripheral setNotifyValue:YES forCharacteristic:self.characteristic];
        [self.peripheral readValueForCharacteristic:self.characteristic];
    }
    else
        NSLog(@"蓝牙不存在，请检查");
}

- (void)writeToPeripheral:(NSString *)string{
    if(!self.characteristic){
        NSLog(@"未找到可写入的特征！");
        return;
    }
    NSData* value = [self stringToByte:string];
    NSLog(@"开始写入数据:%@",value);
    //有回调的写数据
    [self.peripheral writeValue:value forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    //写完数据马上接收蓝牙端的回复数据
    [self.peripheral setNotifyValue:YES forCharacteristic:self.characteristic];
    [self.peripheral readValueForCharacteristic:self.characteristic];
}

#pragma mark - Private Methods
//保存设备信息
- (BOOL)saveBLE:(BLEInfo *)discoveredBLEInfo
{
    for (BLEInfo *info in _deviceArray)
    {
        if ([info.discoveredPeripheral.identifier.UUIDString isEqualToString:discoveredBLEInfo.discoveredPeripheral.identifier.UUIDString])
        {
            return NO;
        }
    }
    NSLog(@"发现新BLE设备!\n");
    NSLog(@"设备信息:\n UUID：%@  RSSI:%@\n\n",discoveredBLEInfo.discoveredPeripheral.identifier.UUIDString,discoveredBLEInfo.rssi);
    [_deviceArray addObject:discoveredBLEInfo];
    return YES;
}
//NSData类型转换成NSString
- (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}
//NSString类型转换成字节
-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-'0')*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <= 'F')
            int_ch1 = (hex_char1-'A'+10)*16; //// A 的Ascll - 65
        else if(hex_char1 >= 'a' && hex_char1 <= 'f')
            int_ch1 = (hex_char1-'a'+10)*16;
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = hex_char2-'0'; //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-'A'+10; //// A 的Ascll - 65
        else if(hex_char2 >= 'a' && hex_char2 <= 'f')
            int_ch2 = hex_char2-'a'+10;
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
        }
            break;
        case CBCentralManagerStateResetting:
        {
        }
            break;
        case CBCentralManagerStateUnsupported:
        {
        }
            break;
        case CBCentralManagerStateUnauthorized:
        {
        }
            break;
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"手机未打开蓝牙");
        }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            [_deviceArray removeAllObjects];
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
            NSLog(@"开始搜索蓝牙设备");
        }
            break;
        default:
            break;
    }
}
/**
 * 发现外围设备
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (peripheral.name.length > 0){
        BLEInfo *discoveredBLEInfo = [[BLEInfo alloc] init];
        discoveredBLEInfo.discoveredPeripheral = peripheral;
        discoveredBLEInfo.rssi = RSSI;
        // add to BLEarray
        [self saveBLE:discoveredBLEInfo];
    }
}
/**
 * 已连接
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接蓝牙%@成功",peripheral.name);
    [self.peripheral setDelegate:self];
    //查找服务
    [self.peripheral discoverServices:nil];
}
/**
 * 连接失败
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"连接蓝牙%@失败，失败原因：%@",peripheral.name,error.localizedDescription);
}
/**
 * 已断开
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"断开与蓝牙%@的连接",peripheral.name);
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    if (error == nil) {
        for (CBService *service in peripheral.services)
        {
            NSLog(@"服务UUID found with UUID : %@",service.UUID);
            //查找特征字节
            [self.peripheral discoverCharacteristics:nil forService:service];
        }
    }else {
        //清除连接
        return;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    if (error == nil) {
        for (CBCharacteristic *c in service.characteristics)
        {
            NSLog(@"特征UUID FOUND(in 服务UUID:%@): %@",service.UUID.description,c.UUID);
            if([c.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]){
                self.characteristic = c;
                self.writeUUID = c.UUID;
                self.readUUID = c.UUID;
                NSLog(@"已经发现可读写的特征%@",c.UUID);
                self.completeBlock(YES);
            }
        }
    }else {
        //清除连接
        return;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error)
    {
        NSLog(@"didUpdateValueForCharacteristic error : %@", error.localizedDescription);
        return;
    }
    NSLog(@"收到了数据(特征UUID:%@):%@ ",characteristic.UUID,characteristic.value);
    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]){
        NSData *dataValue = characteristic.value;
        NSString *dataValues = [self hexadecimalString:dataValue];
        NSLog(@"数据字符串形式为:%@",dataValues);
        //
        if (self.delegate){
            if ([self.delegate respondsToSelector:@selector(receiveDataFromBLE:)]){
                [self.delegate receiveDataFromBLE:dataValues];
            }
        }
        //
//        Byte *bytes = (Byte*)[dataValue bytes];
//        //下面是Byte转换为16进制。
//        NSString *hexStr=@"";
//        for(int i=0;i<[dataValue length];i++)
//        {
//            NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
//            if([newHexStr length]==1)
//                hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
//            else
//                hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
//        }
//        NSLog(@"16进制数为:%@",hexStr);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (!error)
        NSLog(@"为特征%@设置订阅",characteristic.UUID);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (!error){
        NSLog(@"向特征：%@写入数据成功",characteristic.UUID);
    }
    else
        NSLog(@"写入数据失败");
}

@end
