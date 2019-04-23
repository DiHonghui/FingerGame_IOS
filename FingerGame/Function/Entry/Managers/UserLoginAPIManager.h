//
//  UserLoginAPIManager.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/11.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "ZHYAPIBaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserLoginAPIManager : ZHYAPIBaseManager<ZHYAPIManager,ZHYAPIManagerValidator,ZHYAPIManagerParamSourceDelegate>

@property(strong,nonatomic,readonly)NSString *userName;

@property(strong,nonatomic,readonly)NSString *userPassword;

-(instancetype)initWithUserNameAndPassword:(NSString *) userName password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
