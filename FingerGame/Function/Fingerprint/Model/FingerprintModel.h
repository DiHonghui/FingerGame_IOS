//
//  FingerprintModel.h
//  FingerGame
//
//  Created by lisy on 2019/4/12.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FingerprintModel : NSObject <NSCoding>

//一个指纹Account拥有很多指纹，对应10手指
//指纹所属的Account
@property (nonatomic,strong) NSString *fpAccountId;
//指纹所属的手指id
@property (nonatomic,assign) NSString *fingerId;
//指纹保存的位置
@property (nonatomic,strong) NSString *storeLocation;

@end

NS_ASSUME_NONNULL_END
