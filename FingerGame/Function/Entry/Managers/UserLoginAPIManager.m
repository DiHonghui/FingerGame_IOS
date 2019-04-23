//
//  UserLoginAPIManager.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/11.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "UserLoginAPIManager.h"
#import "NSObject+YYModel.h"

@interface UserLoginAPIManager()

@property(strong,nonatomic,readwrite)NSString *userName;

@property(strong,nonatomic,readwrite)NSString *userPassword;

@end

@implementation UserLoginAPIManager

//-(instancetype)init{
//    self = [super init];
//    if (self) {
//        self.validator = self;
//        self.paramSource = self;
//    }
//    return self;
//}

- (instancetype)initWithUserNameAndPassword:(NSString *)userName password:(NSString *)userPassword{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSource = self;
        self.userName = userName;
        self.userPassword = userPassword;
    }
    return self;
}

#pragma mark - ZHYAPIManager
//api名称，之后应该要改
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
    return @{@"username":self.userName,
             @"password":self.userPassword,
             @"service" : @"App.User.Login"
             };
}



@end
