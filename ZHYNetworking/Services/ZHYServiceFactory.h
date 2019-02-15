//
//  ZHYServiceFactory.h
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHYService.h"


@interface ZHYServiceFactory : NSObject


+ (instancetype)sharedInstance;

/**
 *  工厂方法根据 identifier 构造不同的service
 *  @param identifier  service 的唯一标识符  在AIFNetworkingConfiguration中定义成全局常量
 *  @return
 */
- (ZHYService <ZHYServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier;


@end
