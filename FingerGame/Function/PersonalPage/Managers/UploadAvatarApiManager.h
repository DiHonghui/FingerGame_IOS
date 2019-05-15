//
//  UploadAvatarApiManager.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/15.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "ZHYAPIBaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadAvatarApiManager : ZHYAPIBaseManager <ZHYAPIManager, ZHYAPIManagerValidator, ZHYAPIManagerParamSourceDelegate>

- (instancetype)initWithUserId:(NSString *)userId File:(NSData *)imageData;
@end

NS_ASSUME_NONNULL_END
