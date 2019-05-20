//
//  RechargeDiomondApiManager.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/20.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "ZHYAPIBaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface RechargeDiomondApiManager : ZHYAPIBaseManager <ZHYAPIManager, ZHYAPIManagerValidator, ZHYAPIManagerParamSourceDelegate>

-(instancetype)initWithId:(NSString *)userId:(NSString *)Amount;

@end

NS_ASSUME_NONNULL_END
