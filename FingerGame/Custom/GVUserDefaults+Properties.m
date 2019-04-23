//
//  GVUserDefaults+Properties.m
//  FingerGame
//
//  Created by lisy on 2019/4/12.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "GVUserDefaults+Properties.h"

@implementation GVUserDefaults (Properties)

@dynamic userId;
@dynamic userName;
@dynamic userPwd;
//保存已录入指纹的用户ID
@dynamic fingerprintLoginUsers;
//保存已录入的指纹，每个objecte为fingerprintModel形式
@dynamic fingerprintArray;

@end
