//
//  UploadAvatarApiManager.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/15.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "UploadAvatarApiManager.h"

@interface UploadAvatarApiManager()

@property(strong,nonatomic,readwrite)NSString *userId;

@property(strong,nonatomic,readwrite)NSData *imageData;

@end
@implementation UploadAvatarApiManager

- (instancetype)initWithUserId:(NSString *)userId File:(NSData *)imageData{
self = [super init];
if (self) {
    self.validator = self;
    self.paramSource = self;
    self.userId = userId;
    self.imageData = imageData;
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
    if (![data[@"code"] isKindOfClass:[NSNull class]]) {
        if ([data[@"code"] intValue] == 200){
            return YES;
        }
    }
    return NO;
}

#pragma mark - ZHYAPIManagerParamSourceDelegate

- (NSDictionary *)paramsForApi:(ZHYAPIBaseManager *)manager{
    return @{@"user_id":self.userId,
             @"file":self.imageData,
             @"service" : @"App.User.Avatar"
             };
}

@end
