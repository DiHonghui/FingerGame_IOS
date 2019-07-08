//
//  MissionModel.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/11.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MissionModel : NSObject

/**
关卡ID
 */
@property(strong,nonatomic) NSString *missionID;
/**
 关卡名称
 */
@property(strong,nonatomic) NSString *missionName;
/**
 关卡等级
 */
@property(strong, nonatomic) NSString *missionLevel;
/**
 关卡通关获得经验值
 */
@property(strong,nonatomic) NSString *missionExperience;
/**
 关卡难度
 */
@property(strong,nonatomic) NSString *missionDifficulty;
/**
 音乐名称
 */
@property(strong,nonatomic) NSString *musicName;
/**
 音乐路径
 */
@property(strong,nonatomic) NSString *musicPath;
/**
 音乐时间
 */
@property(strong,nonatomic) NSString *musicTime;
/**
 星星总数
 */
@property(strong,nonatomic) NSString *star;
/**
 游戏价格
 */
@property(strong,nonatomic) NSString *price;
/**
 游戏代币
 */
@property(strong,nonatomic) NSString *award;
/**
 最高得分
 */
@property(strong,nonatomic) NSString *bestScore;
/**
 收藏状态
 */
@property(strong,nonatomic) NSString *like;




@end

NS_ASSUME_NONNULL_END
