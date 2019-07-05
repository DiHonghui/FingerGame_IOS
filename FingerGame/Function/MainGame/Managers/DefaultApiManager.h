//
//  DefaultApiManager.h
//  FingerGame
//
//  Created by lisy on 2019/7/3.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "ZHYAPIBaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DefaultApiManager : ZHYAPIBaseManager <ZHYAPIManager, ZHYAPIManagerValidator, ZHYAPIManagerParamSourceDelegate>

@end

NS_ASSUME_NONNULL_END
