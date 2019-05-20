//
//  RechargeDiomondApiManager.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/20.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "RechargeDiomondApiManager.h"

@interface RechargeDiomondApiManager()

@property (nonatomic,strong) NSString *amount;
@property(nonatomic,strong)NSString *userId;

@end

@implementation RechargeDiomondApiManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSource = self;
    }
    return self;
}

-(instancetype)initWithId:(NSString *)userId :(NSString *)Amount{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSource = self;
        self.amount = Amount;
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
             @"amount":self.amount,
             @"user_id":self.userId,
             @"service":@"App.User.Recharge"
             };
}

@end
