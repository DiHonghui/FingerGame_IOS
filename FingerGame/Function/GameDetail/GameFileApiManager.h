//
//  GameFileApiManager.h
//  FingerGame
//
//  Created by lisy on 2019/3/4.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "ZHYAPIBaseManager.h"

@interface GameFileApiManager : ZHYAPIBaseManager<ZHYAPIManager, ZHYAPIManagerValidator, ZHYAPIManagerParamSourceDelegate>

- (instancetype)initWithGameId:(NSString *)gameId;

@end
