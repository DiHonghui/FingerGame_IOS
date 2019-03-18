//
//  UserModel.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/9.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

/**
用户ID
 */
@property(strong,nonatomic) NSString *userId;
/**
 用户名
 */
@property(strong,nonatomic) NSString *userName;
/**
 用户手机号
 */
@property(strong,nonatomic) NSString *userPhoneNumber;
/**
 用户密码
 */
@property(strong,nonatomic) NSString *userPassword;
/**
 用户现等级
 */
@property(strong,nonatomic) NSString *userLevel;
/**
 用户当前体力值
 */
@property(strong,nonatomic) NSString *userEnergy;
/**
 用户经验值
 */
@property(strong,nonatomic) NSString *userExperience;
/**
 用户健康豆数量
 */
@property(strong,nonatomic) NSString *userHealthyBeans;
/**
 用户钻石数量
 */
@property(strong,nonatomic) NSString *userDiamond;


@end

NS_ASSUME_NONNULL_END
