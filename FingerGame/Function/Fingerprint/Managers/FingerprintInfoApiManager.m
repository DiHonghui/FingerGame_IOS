//
//  FingerprintInfoApiManager.m
//  FingerGame
//
//  Created by lisy on 2019/6/29.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "FingerprintInfoApiManager.h"

@implementation FingerprintInfoApiManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSource = self;
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
    //    if (![data[@"success"] isKindOfClass:[NSNull class]]) {
    //        if ([data[@"success"] boolValue] == true){
    //            return YES;
    //        }
    //    }
    return YES;
}

#pragma mark - ZHYAPIManagerParamSourceDelegate

- (NSDictionary *)paramsForApi:(ZHYAPIBaseManager *)manager{
    return @{};
}

@end
