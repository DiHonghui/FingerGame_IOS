//
//  MissionSimpleForList.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/4/23.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "MissionSimpleForList.h"

@implementation MissionSimpleForList

+(NSDictionary *)modelCustomPropertyMapper{
    return @{@"gameId" : @[@"gameId"],
             @"bestScore" : @[@"bestScore"],
             @"completionDegree" : @[@"completionDegree"],
             @"updateTime" : @[@"updateTime"],
             };
}

@end
