//
//  ZHYCache.m
//  ZHYNetworking
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYCache.h"
#import "ZHYNetworkingConfiguration.h"
#import "ZHYCacheObject.h"

@interface ZHYCache()

@property (strong, nonatomic) NSCache *cache;

@end


@implementation ZHYCache

#pragma mark - life cycle

+ (instancetype)sharedInstance{
    static ZHYCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZHYCache alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

- (void)saveCacheWithData:(NSData *)cachedData serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams outdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds{
    [self saveCacheWithData:cachedData outdateTimeSeconds:cacheOutdateTimeSeconds key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

#pragma mark - private methods

- (void)saveCacheWithData:(NSData *)cachedData outdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds key:(NSString *)key{
    ZHYCacheObject *cachedObject = [self.cache objectForKey:key];
    if (!cachedObject) {
        cachedObject = [[ZHYCacheObject alloc] initWithContent:cachedData outdateTimeSeconds:cacheOutdateTimeSeconds];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key{
    ZHYCacheObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}

- (void)deleteCacheWithKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}

- (void)clean{
    [self.cache removeAllObjects];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            methodName:(NSString *)methodName
                         requestParams:(NSDictionary *)requestParams{
    return [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [self AIF_urlParamsStringSignature:requestParams]];
}

/** 字符串前面是没有问号的，如果用于POST，那就不用加问号，如果用于GET，就要加个问号 */
- (NSString *)AIF_urlParamsStringSignature:(NSDictionary *)requestParams{
    NSArray *sortedArray = [self AIF_transformedUrlParamsArraySignature:requestParams];
    return [self AX_paramsString:sortedArray];
}

/** 转义参数 */
- (NSArray *)AIF_transformedUrlParamsArraySignature:(NSDictionary *)requestParams{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [requestParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
        if ([obj length] > 0) {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}

/** 字母排序之后形成的参数字符串 */
- (NSString *)AX_paramsString:(NSArray *)sortedArray{
    NSMutableString *paramString = [[NSMutableString alloc] init];
    
    NSArray *sortedParams = [sortedArray sortedArrayUsingSelector:@selector(compare:)];
    [sortedParams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([paramString length] == 0) {
            [paramString appendFormat:@"%@", obj];
        } else {
            [paramString appendFormat:@"&%@", obj];
        }
    }];
    
    return paramString;
}



#pragma mark - get & set

- (NSCache *)cache{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kZHYCacheCountLimit;
    }
    return _cache;
}

@end
