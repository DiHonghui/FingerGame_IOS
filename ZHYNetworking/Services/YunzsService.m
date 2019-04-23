//
//  YunzsService.m
//  BMZY-YS
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "YunzsService.h"
#import "ZHYNetworkingConfiguration.h"

@implementation YunzsService


#pragma mark - ZHYServiceProtocal
- (BOOL)isOnline{
    return KIsOnline;
}

- (NSString *)onlineApiBaseUrl{
    return @"http://wx.yunzs.com.cn/apiv2/";
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
    return @"http://test.yunzs.com.cn/apiv2/";
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
