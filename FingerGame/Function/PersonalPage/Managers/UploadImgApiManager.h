//
//  UploadImgApiManager.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/28.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^callBack)(BOOL state);

@interface UploadImgApiManager : NSObject

- (void)uploadCallBack:(callBack)callBack;

@end

NS_ASSUME_NONNULL_END
