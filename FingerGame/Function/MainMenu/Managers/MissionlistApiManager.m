//
//  MissionlistApiManager.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/11.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "MissionlistApiManager.h"

@interface MissionlistApiManager()

@property (nonatomic,strong) NSString *userId;

@end

@implementation MissionlistApiManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSource = self;
    }
    return self;
}

-(instancetype)initWithUserId:(NSString *)userId{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSource = self;
        self.userId = userId;
    }
    return self;
}

#pragma mark - ZHYAPIManager

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
             @"id":self.userId,
             @"service":@"App.Game.GameList"
             
             };
}


@end
