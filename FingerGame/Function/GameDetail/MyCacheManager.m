//
//  MyCacheManager.m
//  FingerGame
//
//  Created by lisy on 2019/6/26.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "MyCacheManager.h"

static MyCacheManager *sInstance = nil;

@interface MyCacheManager()

@property (nonatomic,strong) YTKKeyValueStore *myStore;

@property (nonatomic,strong) NSString *operatingTable;

@end

@implementation MyCacheManager
#pragma mark - 单例对象
+ (MyCacheManager *)sharedInstance{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[MyCacheManager alloc] init];
    });
    NSLog(@"create MyCacheManager instance");
    return sInstance;
}

#pragma mark - Init methods
- (id)init{
    if (self = [super init]){
        _myStore = [[YTKKeyValueStore alloc] initDBWithName:@"MyCache.db"];
        _operatingTable = @"";
    }
    return self;
}

#pragma mark - class methods
+ (long)dateConversionTimeStamp:(NSDate *)date
{
    long timeSp = (long)[date timeIntervalSince1970];//时间戳timesp单位是秒
    NSLog(@"对应时间戳为 %ld",timeSp);
    return timeSp;
}

#pragma mark - object methods
- (void)setOperatingTable:(NSString *)tableName{
    _operatingTable = tableName;
    [_myStore createTableWithName:tableName];
}

- (NSString *)getCurrentTable{
    return _operatingTable;
}

- (void)storeString:(NSString *)str WithKey:(NSString *)key{
    [_myStore putString:str withId:key intoTable:_operatingTable];
}

- (void)storeObject:(id)obj WithKey:(NSString *)key{
    [_myStore putObject:obj withId:key intoTable:_operatingTable];
}

- (NSString *)getStringWithKey:(NSString *)key{
    NSString *result = [_myStore getStringById:key fromTable:_operatingTable];
    return result;
}

- (id)getObjectWithKey:(NSString *)key{
    id result = [_myStore getObjectById:key fromTable:_operatingTable];
    return result;
}

- (NSDate *)getCreatedTimeForKey:(NSString *)key{
    YTKKeyValueItem *resultItem = [_myStore getYTKKeyValueItemById:key fromTable:_operatingTable];
    if (resultItem){
        NSDate *cTime = resultItem.createdTime;
        NSLog(@"记录创建时间 %@",cTime);
        return cTime;
    }else
        return [NSDate new];
}

- (void)removeAllCacheForTable:(NSString *)tableName{
    [_myStore clearTable:tableName];
}

@end
