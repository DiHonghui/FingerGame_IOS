//
//  MissionCollectApiManager.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/13.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "MissionCollectApiManager.h"

@interface MissionCollectApiManager()

@property (nonatomic,strong) NSString *missionId;
@property(nonatomic,strong)NSString *userId;

@end

@implementation MissionCollectApiManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSource = self;
    }
    return self;
}

-(instancetype)initWithMissionId:(NSString *)missionId :(NSString*)userId{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSource = self;
        self.missionId = missionId;
        self.userId = userId;
    }
    return self;
}

- (NSString *)methodName{
    return @"";
}

- (ZHYAPIManagerRequestType)requestType{
    return ZHYAPIManagerRequestTypeGet;
}

#pragma mark - ZHYAPIManagerValidator

- (BOOL)manager:(ZHYAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data{
    return YES;
}

- (BOOL)manager:(ZHYAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data{
    if (![data[@"success"] isKindOfClass:[NSNull class]]) {
        if ([data[@"success"] boolValue] == true){
            return YES;
        }
        if ([data[@"success"] boolValue] == false){
            return NO;
        }
    }
    return NO;
}

#pragma mark - ZHYAPIManagerParamSourceDelegate

- (NSDictionary *)paramsForApi:(ZHYAPIBaseManager *)manager{
    return @{
             @"game_id":self.missionId,
             @"user_id":self.userId,
             @"service":@"App.User.Like"
             
             };
}

@end
