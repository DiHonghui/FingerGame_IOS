//
//  MissionCollectApiManager.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/13.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "ZHYAPIBaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MissionCollectApiManager : ZHYAPIBaseManager <ZHYAPIManager, ZHYAPIManagerValidator, ZHYAPIManagerParamSourceDelegate>

- (instancetype)initWithMissionId:(NSString *)missionId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
