//
//  GameFileApiManager.m
//  FingerGame
//
//  Created by lisy on 2019/3/4.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "GameFileApiManager.h"

@interface GameFileApiManager()

@property (nonatomic,strong) NSString *gameId;

@end

@implementation GameFileApiManager

- (instancetype)initWithGameId:(NSString *)gameId{
    self = [super init];
    if (self){
        self.validator = self;
        self.paramSource = self;
        self.gameId = gameId;
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
    return YES;
}

#pragma mark - ZHYAPIManagerParamSourceDelegate

- (NSDictionary *)paramsForApi:(ZHYAPIBaseManager *)manager{
    return @{
             @"id":self.gameId,
             @"service":@"App.Game.FindByID"
             };
}

@end
