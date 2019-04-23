//
//  UserRegistAPIManager.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/4/23.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "UserRegistAPIManager.h"

@interface UserRegistAPIManager()

@property(strong,nonatomic,readwrite)NSString *userName;

@property(strong,nonatomic,readwrite)NSString *userPassword;

@property(strong,nonatomic,readwrite)NSString *userPhoneNumber;

@end

@implementation UserRegistAPIManager

- (instancetype)initWithUserInfo:(NSString *)userName password:(NSString *)password userPhoneNumber:(NSString *)phonerNumber{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSource = self;
        self.userName = userName;
        self.userPassword = password;
        self.userPhoneNumber = phonerNumber;
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
             @"phoneNum":self.userPhoneNumber,
             @"service" : @"App.User.Register"
             };
}

@end
