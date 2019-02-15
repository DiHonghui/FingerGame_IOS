//
//  ZHYService.m
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYService.h"

@implementation ZHYService

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(ZHYServiceProtocal)]) {
            self.child = (id<ZHYServiceProtocal>)self;
        }
    }
    return self;
}

#pragma mark - getters and setters
- (NSString *)privateKey
{
    return self.child.isOnline ? self.child.onlinePrivateKey : self.child.offlinePrivateKey;
}

- (NSString *)publicKey
{
    return self.child.isOnline ? self.child.onlinePublicKey : self.child.offlinePublicKey;
}

- (NSString *)apiBaseUrl
{
    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
}

- (NSString *)apiVersion
{
    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
}

@end
