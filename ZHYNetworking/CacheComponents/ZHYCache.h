//
//  ZHYCache.h
//  ZHYNetworking
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHYCache : NSObject

+ (instancetype)sharedInstance;

- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                      methodName:(NSString *)methodName
                                   requestParams:(NSDictionary *)requestParams;

- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams
       outdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds;

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams;



- (NSData *)fetchCachedDataWithKey:(NSString *)key;
- (void)saveCacheWithData:(NSData *)cachedData outdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds key:(NSString *)key;
- (void)deleteCacheWithKey:(NSString *)key;

- (void)clean;

@end
