//
//  ZHYDefaultService.m
//  ZHYFramework
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYDefaultService.h"
#import "ZHYNetworkingConfiguration.h"

@implementation ZHYDefaultService

#pragma mark - ZHYServiceProtocal
- (BOOL)isOnline{
    return KIsOnline;
}

- (NSString *)onlineApiBaseUrl{
    return KOnlineApiBaseUrl;
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
