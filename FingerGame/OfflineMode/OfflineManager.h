//
//  OfflineManager.h
//  FingerGame
//
//  Created by lisy on 2019/7/9.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKKeyValueStore.h"

#import "MissionModel.h"
#import "GameOrderFile.h"
#import "OrderModel.h"
#import "FpInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OfflineManager : NSObject
//单例
+ (OfflineManager *)sharedInstance;
//类方法
+ (long)dateConversionTimeStamp:(NSDate *)date;
//对象方法（接口）
- (void)initMyOfflineData;

- (void)setOperatingTable:(NSString *)tableName;

- (NSString *)getCurrentTable;

- (void)storeString:(NSString *)str WithKey:(NSString *)key;

- (void)storeObject:(id)obj WithKey:(NSString *)key;

- (NSString *)getStringWithKey:(NSString *)key;

- (id)getObjectWithKey:(NSString *)key;
-(void)UpdateForLikeObjectWithKey:(NSString *)key;

- (NSDate *)getCreatedTimeForKey:(NSString *)key;

- (NSArray *)getAllObjectsFromTable:(NSString *)tableName;

- (void)removeAllCacheForTable:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
