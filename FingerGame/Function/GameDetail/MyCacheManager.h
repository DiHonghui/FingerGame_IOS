//
//  MyCacheManager.h
//  FingerGame
//
//  Created by lisy on 2019/6/26.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YTKKeyValueStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCacheManager : NSObject
//single instance
+ (MyCacheManager *)sharedInstance;
//将NSDate类型转为时间戳
+ (long)dateConversionTimeStamp:(NSDate *)date;
//
- (void)setOperatingTable:(NSString *)tableName;
- (NSString *)getCurrentTable;

- (void)storeString:(NSString *)str WithKey:(NSString *)key;
- (void)storeObject:(id)obj WithKey:(NSString *)key;
- (NSString *)getStringWithKey:(NSString *)key;
- (id)getObjectWithKey:(NSString *)key;

- (NSDate *)getCreatedTimeForKey:(NSString *)key;

- (void)removeAllCacheForTable:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
