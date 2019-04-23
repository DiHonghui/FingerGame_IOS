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

//指纹所属的用户id
@property (nonatomic,strong) NSString *userId;
//指纹所属的手指id
@property (nonatomic,assign) NSString *fingerId;
//指纹保存的位置
@property (nonatomic,strong) NSString *storeLocation;

@end

NS_ASSUME_NONNULL_END
