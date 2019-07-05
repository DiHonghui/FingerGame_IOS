//
//  FpInfoModel.h
//  FingerGame
//
//  Created by lisy on 2019/7/1.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FpInfoModel : NSObject

//指纹所属的手指id
@property (nonatomic,strong) NSString *fingerId;
//指纹所属的手指名称
@property (nonatomic,strong) NSString *fingerName;
//指纹保存的位置
@property (nonatomic,strong) NSString *storeLocation;

@end

NS_ASSUME_NONNULL_END
