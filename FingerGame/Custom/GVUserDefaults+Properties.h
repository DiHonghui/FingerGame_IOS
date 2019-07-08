//
//  GVUserDefaults+Properties.h
//  FingerGame
//
//  Created by lisy on 2019/4/12.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <GVUserDefaults/GVUserDefaults.h>

NS_ASSUME_NONNULL_BEGIN

@interface GVUserDefaults (Properties)

@property (nonatomic,weak) NSString *userId;
@property (nonatomic,weak) NSString *userName;
@property (nonatomic,weak) NSString *userPwd;
@property (nonatomic,weak) NSString *phoneNumber;
@property (nonatomic,weak) NSString *diamond;
@property (nonatomic,weak) NSString *healthyBeans;
@property (nonatomic,weak) NSString *energy;
@property (nonatomic,weak) NSString *level;
@property (nonatomic,weak) NSString *avatar;
@property (nonatomic,weak) NSString *experience;

@end

NS_ASSUME_NONNULL_END
