//
//  MissionSimpleForList.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/4/23.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MissionSimpleForList : NSObject

/**
 关卡ID
 */
@property(strong,nonatomic) NSString *gameId;
/**
 最高分数
 */
@property(strong,nonatomic) NSString *bestScore;
/**
 完成度
 */
@property(strong,nonatomic) NSString *completionDegree;
/**
 更新时间
 */
@property(strong,nonatomic) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
