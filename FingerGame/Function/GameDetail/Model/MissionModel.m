//
//  MissionModel.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/11.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "MissionModel.h"

@implementation MissionModel

+(NSDictionary *)modelCustomPropertyMapper{
    return @{@"missionID" : @[@"id"],
             @"missionName" : @[@"name"],
             @"missionLevel" : @[@"level"],
             @"missionExperience" : @[@"experience"],
             @"missionDifficulty" : @[@"diffculty"],
             @"musicName" : @[@"music_name"],
             @"musicPath" : @[@"path"],
             @"musictime" : @[@"time"],
             @"bestScore" : @"playRecord.bestScore",
             @"star"      : @"playRecord.star",
             @"like"      : @"playRecord.like",
             @"missionSmallLevel":@[@"small_level"]
             };
}

@end
