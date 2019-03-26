//
//  UserModel.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/9.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "UserModel.h"

@interface UserModel()

@end

@implementation UserModel


+(NSDictionary *)modelCustomPropertyMapper{
    return @{@"userId" : @[@"id"],
             @"userName" : @[@"name"],
             @"userPhoneNumber" : @[@"phoneNum"],
             @"userPassword" : @[@"password"],
             @"userLevel" :@ [@"level"],
             @"userEnergy" : @[@"energy"],
             @"userHealthyBeans" : @[@"healthyBeans"],
             @"userExperience" : @[@"experience"],
             @"userDiamond" : @[@"diamond"],
             };
}

@end
