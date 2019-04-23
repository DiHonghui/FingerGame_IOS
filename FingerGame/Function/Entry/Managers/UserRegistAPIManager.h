//
//  UserRegistAPIManager.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/4/23.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "ZHYAPIBaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserRegistAPIManager : ZHYAPIBaseManager<ZHYAPIManager,ZHYAPIManagerValidator,ZHYAPIManagerParamSourceDelegate>


@property(strong,nonatomic,readonly)NSString *userName;

@property(strong,nonatomic,readonly)NSString *userPassword;

@property(strong,nonatomic,readonly)NSString *userPhoneNumber;

-(instancetype)initWithUserInfo:(NSString *) userName password:(NSString *)password userPhoneNumber:(NSString*) phonerNumber;
@end

NS_ASSUME_NONNULL_END
