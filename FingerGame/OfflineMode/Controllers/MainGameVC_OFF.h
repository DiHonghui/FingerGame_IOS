//
//  MainGameVC_OFF.h
//  FingerGame
//
//  Created by lisy on 2019/7/9.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderModel.h"
#import "GameOrderFile.h"
#import "MissionModel.h"
#import "MyBTManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainGameVC_OFF : UIViewController

- (id)initWithGameOrderFile:(GameOrderFile *)gameOrderFile AndMissionModel:(MissionModel *)missionModel;

@end

NS_ASSUME_NONNULL_END
