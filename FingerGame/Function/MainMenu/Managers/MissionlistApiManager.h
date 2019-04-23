//
//  MissionlistApiManager.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/11.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "ZHYAPIBaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MissionlistApiManager : ZHYAPIBaseManager <ZHYAPIManager, ZHYAPIManagerValidator, ZHYAPIManagerParamSourceDelegate>

- (instancetype)initWithUserId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
