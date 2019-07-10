//
//  OfflineManager.m
//  FingerGame
//
//  Created by lisy on 2019/7/9.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "OfflineManager.h"

static OfflineManager *sInstance = nil;

@interface OfflineManager()

@property (nonatomic,strong) YTKKeyValueStore *myStore;

@property (nonatomic,strong) NSString *operatingTable;

@end

@implementation OfflineManager
#pragma mark - 单例对象
+ (OfflineManager *)sharedInstance{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[OfflineManager alloc] init];
        NSLog(@"create OfflineManager instance");
    });
    NSLog(@"use OfflineManager instance");
    return sInstance;
}

#pragma mark - Init methods
- (id)init{
    if (self = [super init]){
        _myStore = [[YTKKeyValueStore alloc] initDBWithName:@"MyOfflineDatabase.db"];
        _operatingTable = @"";
    }
    return self;
}

- (void)initMyOfflineData{
    [self setupUserTable];
    [self setupGameInfoTable];
    [self setupFingerPrintTable];
    [self setupGameOrdersTable];
}

- (void)setupUserTable{
    [self setOperatingTable:@"user_table"];
    NSLog(@"%@",[self getCurrentTable]);
    [self storeString:@"1" WithKey:@"userId"];
    [self storeString:@"离线用户" WithKey:@"userName"];
    [self storeString:@"123456" WithKey:@"userPwd"];
    [self storeString:@"10010001000" WithKey:@"phoneNumber"];
    [self storeString:@"50" WithKey:@"diamond"];
    [self storeString:@"500" WithKey:@"healthyBeans"];
    [self storeString:@"100" WithKey:@"energy"];
    [self storeString:@"1" WithKey:@"level"];
    [self storeString:@"" WithKey:@"avatar"];
    [self storeString:@"50" WithKey:@"experience"];
}

- (void)setupGameInfoTable{
    [self setOperatingTable:@"gameInfo_table"];
    NSLog(@"%@",[self getCurrentTable]);

    NSDictionary *dic1 = @{@"missionID":@"1",
                           @"missionName":@"新手入门",
                           @"missionLevel":@"1",
                           @"missionExperience":@"100",
                           @"missionDifficulty":@"1",
                           @"musicName":@"小星星",
                           @"musicPath":@"",
                           @"musicTime":@"0",
                           @"star":@"2",
                           @"price":@"",
                           @"award":@"100",
                           @"bestScore":@"5",
                           @"like":@"1",
                           @"missionSmallLevel":@"1"};
    [self storeObject:dic1 WithKey:@"1"];
    NSDictionary *dic2 = @{@"missionID":@"2",
                           @"missionName":@"逐步提高",
                           @"missionLevel":@"2",
                           @"missionExperience":@"100",
                           @"missionDifficulty":@"2",
                           @"musicName":@"难忘的经",
                           @"musicPath":@"",
                           @"musicTime":@"0",
                           @"star":@"1",
                           @"price":@"",
                           @"award":@"100",
                           @"bestScore":@"0",
                           @"like":@"0",
                           @"missionSmallLevel":@"1"};
    [self storeObject:dic2 WithKey:@"2"];
    NSDictionary *dic3 = @{@"missionID":@"3",
                           @"missionName":@"中级挑战",
                           @"missionLevel":@"3",
                           @"missionExperience":@"100",
                           @"missionDifficulty":@"3",
                           @"musicName":@"DragonSong",
                           @"musicPath":@"",
                           @"musicTime":@"0",
                           @"star":@"0",
                           @"price":@"",
                           @"award":@"100",
                           @"bestScore":@"0",
                           @"like":@"0",
                           @"missionSmallLevel":@"1"};
    [self storeObject:dic3 WithKey:@"3"];
    NSDictionary *dic4 = @{@"missionID":@"4",
                            @"missionName":@"终极考验",
                            @"missionLevel":@"4",
                            @"missionExperience":@"100",
                            @"missionDifficulty":@"4",
                            @"musicName":@"HeavenSward",
                            @"musicPath":@"",
                            @"musicTime":@"0",
                            @"star":@"0",
                            @"price":@"",
                            @"award":@"100",
                            @"bestScore":@"0",
                            @"like":@"0",
                            @"missionSmallLevel":@"1"};
    [self storeObject:dic4 WithKey:@"4"];
}

- (void)setupGameOrdersTable{
    [self setOperatingTable:@"gameOrders_table"];
    NSLog(@"%@",[self getCurrentTable]);
    NSMutableArray *a1 = [NSMutableArray array];
    [a1 addObjectsFromArray:@[@"aa0700000200000200ff",
                              @"aa0709000200000200ff",
                              @"aa0701000600000200ff",
                              @"aa0708000600000200ff",
                              @"aa0702001000000200ff",
                              @"aa0707001000000200ff",
                              @"aa0703001400000200ff",
                              @"aa0706001400000200ff",
                              @"aa0704001800000200ff",
                              @"aa0705001800000200ff",
                              @"aa0704002200000200ff",
                              @"aa0705002200000200ff",
                              @"aa0703002600000200ff",
                              @"aa0706002600000200ff",
                              @"aa0702003000000200ff",
                              @"aa0707003000000200ff",
                              @"aa0701003400000200ff",
                              @"aa0708003400000200ff",
                              @"aa0700003800000200ff",
                              @"aa0709003800000200ff",
                              @"aa0704004200000200ff",
                              @"aa0705004200000200ff",
                              @"aa0704004600000200ff",
                              @"aa0706004600000200ff",
                              @"aa0704005000000200ff",
                              @"aa0707005000000200ff",
                              @"aa0704005400000200ff",
                              @"aa0708005400000200ff"] ];
    
    [self storeObject:a1 WithKey:@"1"];
    NSMutableArray *a2 = [NSMutableArray array];
    [a2 addObjectsFromArray:@[@"aa0702000200000200ff",
                              @"aa0705000200000200ff",
                              @"aa0702000600000200ff",
                              @"aa0706000600000200ff",
                              @"aa0702001000000200ff",
                              @"aa0707001000000200ff",
                              @"aa0702001400000200ff",
                              @"aa0708001400000200ff",
                              @"aa0702001800000200ff",
                              @"aa0709001800000200ff",
                              @"aa0704002200000200ff",
                              @"aa0707002200000200ff",
                              @"aa0703002600000200ff",
                              @"aa0707002600000200ff",
                              @"aa0702003000000200ff",
                              @"aa0707003000000200ff",
                              @"aa0701003400000200ff",
                              @"aa0707003400000200ff",
                              @"aa0700003800000200ff",
                              @"aa0707003800000200ff",
                              @"aa0701004200000200ff",
                              @"aa0705004200000200ff",
                              @"aa0701004600000200ff",
                              @"aa0706004600000200ff",
                              @"aa0701005000000200ff",
                              @"aa0707005000000200ff",
                              @"aa0701005400000200ff",
                              @"aa0708005400000200ff",
                              @"aa0701005800000200ff",
                              @"aa0709005800000200ff",
                              @"aa0704010200000200ff",
                              @"aa0708010200000200ff",
                              @"aa0703010600000200ff",
                              @"aa0708010600000200ff",
                              @"aa0702011000000200ff",
                              @"aa0708011000000200ff",
                              @"aa0701011400000200ff",
                              @"aa0708011400000200ff",
                              @"aa0700011800000200ff"] ];
    [self storeObject:a2 WithKey:@"2"];
    NSMutableArray *a3 = [NSMutableArray array];
    [a3 addObjectsFromArray:@[@"aa0700000000000400ff",
                                         @"aa0701000100000400ff",
                                         @"aa0702000200000400ff",
                                         @"aa0703000300000400ff",
                                         @"aa0704000400000400ff",
                                         @"aa0705000500000200ff",
                                         @"aa0709001000000400ff",
                                         @"aa0709001500000100ff",
                                         @"aa0709001700000100ff",
                                         @"aa0709001900000200ff",
                                         @"aa0709002200000200ff",
                                         @"aa0709002500000200ff",
                                         @"aa0709002800000200ff",
                                         @"aa0709003100000200ff",
                                         @"aa0709003400000200ff",
                                         @"aa0709003700000200ff",
                                         @"aa0709004000000200ff",
                                         @"aa0709004300000200ff",
                                         @"aa0709004600000200ff",
                                         @"aa0709004900000200ff",
                                         @"aa0709005200000200ff",
                                         @"aa0709005500000200ff",
                                         @"aa0709005800000200ff"] ];
    [self storeObject:a3 WithKey:@"3"];
    NSMutableArray *a4 = [NSMutableArray array];
    [a4 addObjectsFromArray:@[@"aa0700000200000200ff",
                              @"aa0705000200000200ff",
                              @"aa0701000600000200ff",
                              @"aa0706000600000200ff",
                              @"aa0702001000000200ff",
                              @"aa0707001000000200ff",
                              @"aa0703001400000200ff",
                              @"aa0708001400000200ff",
                              @"aa0704001800000200ff",
                              @"aa0709001800000200ff",
                              @"aa0709002200000200ff",
                              @"aa0704002200000200ff",
                              @"aa0708002600000200ff",
                              @"aa0703002600000200ff",
                              @"aa0707003000000200ff",
                              @"aa0702003000000200ff",
                              @"aa0706003400000200ff",
                              @"aa0701003400000200ff",
                              @"aa0705003800000200ff",
                              @"aa0700003800000200ff",
                              @"aa0704004200000200ff",
                              @"aa0705004200000200ff",
                              @"aa0704004600000200ff",
                              @"aa0706004600000200ff",
                              @"aa0704005000000200ff",
                              @"aa0707005000000200ff",
                              @"aa0704005400000200ff",
                              @"aa0708005400000200ff"] ];
    [self storeObject:a4 WithKey:@"4"];
}

- (void)setupFingerPrintTable{
    [self setOperatingTable:@"fingerprint_table"];
    NSLog(@"%@",[self getCurrentTable]);
    NSDictionary *dic0 = @{@"fingerId":@"0",@"fingerName":@"小拇指",@"storeLocation":@"-1"};
    NSDictionary *dic1 = @{@"fingerId":@"1",@"fingerName":@"无名指",@"storeLocation":@"-1"};
    NSDictionary *dic2 = @{@"fingerId":@"2",@"fingerName":@"中指",@"storeLocation":@"-1"};
    NSDictionary *dic3 = @{@"fingerId":@"3",@"fingerName":@"食指",@"storeLocation":@"-1"};
    NSDictionary *dic4 = @{@"fingerId":@"4",@"fingerName":@"大拇指",@"storeLocation":@"-1"};
    NSDictionary *dic5 = @{@"fingerId":@"5",@"fingerName":@"大拇指",@"storeLocation":@"-1"};
    NSDictionary *dic6 = @{@"fingerId":@"6",@"fingerName":@"食指",@"storeLocation":@"-1"};
    NSDictionary *dic7 = @{@"fingerId":@"7",@"fingerName":@"中指",@"storeLocation":@"-1"};
    NSDictionary *dic8 = @{@"fingerId":@"8",@"fingerName":@"无名指",@"storeLocation":@"-1"};
    NSDictionary *dic9 = @{@"fingerId":@"9",@"fingerName":@"小拇指",@"storeLocation":@"-1"};
    [self storeObject:dic0 WithKey:@"0"];
    [self storeObject:dic1 WithKey:@"1"];
    [self storeObject:dic2 WithKey:@"2"];
    [self storeObject:dic3 WithKey:@"3"];
    [self storeObject:dic4 WithKey:@"4"];
    [self storeObject:dic5 WithKey:@"5"];
    [self storeObject:dic6 WithKey:@"6"];
    [self storeObject:dic7 WithKey:@"7"];
    [self storeObject:dic8 WithKey:@"8"];
    [self storeObject:dic9 WithKey:@"9"];
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

- (NSArray *)getAllObjectsFromTable:(NSString *)tableName{
    return [_myStore getAllItemsFromTable:tableName];
}

-(void)UpdateForLikeObjectWithKey:(NSString *)key{
    id result = [_myStore getObjectById:key fromTable:_operatingTable];
    NSArray *keys = [result allKeys];
    NSMutableArray *tempDic = [[ NSMutableDictionary alloc] init];
    for (NSString *temp in keys) {
        if (![temp isEqualToString:@"like"]) {
            [tempDic setValue:[result objectForKey:temp] forKey:temp];
        }else if ([result[@"like"] isEqualToString:@"1"]){
            [tempDic setValue:@"0" forKey:@"like"];
        }else{
            [tempDic setValue:@"1" forKey:@"like"];
        }
        
    }
   
        [_myStore deleteObjectById:key fromTable:_operatingTable];
        [_myStore putObject:tempDic withId:key intoTable:_operatingTable];
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
