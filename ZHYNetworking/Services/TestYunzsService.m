//
//  TestYunzsService.m
//  BMZY-YS
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "TestYunzsService.h"
#import "ZHYNetworkingConfiguration.h"

@implementation TestYunzsService
#pragma mark - ZHYServiceProtocal
- (BOOL)isOnline{
    return KIsOnline;
}

- (NSString *)onlineApiBaseUrl{
    return @"http://test.yunzs.com.cn/apiv2/";
}

- (NSString *)onlineApiVersion{
    return @"";
}

- (NSString *)onlinePrivateKey{
    return @"";
}

- (NSString *)onlinePublicKey{
    return @"";
}

- (NSString *)offlineApiBaseUrl{
    return KOfflineApiBaseUrl;
}

- (NSString *)offlineApiVersion{
    return self.onlineApiVersion;
}

- (NSString *)offlinePrivateKey{
    return self.onlinePrivateKey;
}

- (NSString *)offlinePublicKey{
    return self.onlinePublicKey;
}

@end
