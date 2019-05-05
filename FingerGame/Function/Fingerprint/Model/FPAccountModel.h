//
//  FPAccountModel.h
//  FingerGame
//
//  Created by lisy on 2019/5/5.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPAccountModel : NSObject <NSCoding>

//一个user可以有至多8个指纹Account
//指纹Account对应的userId
@property (nonatomic,strong) NSString *userId;
//指纹Account的id（0-7）
@property (nonatomic,strong) NSString *fpAccountId;
//指纹Account的名称
@property (nonatomic,strong) NSString *fpAccountName;

@end

NS_ASSUME_NONNULL_END
