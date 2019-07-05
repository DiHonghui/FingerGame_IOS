//
//  MainGameViewController.h
//  FingerGame
//
//  Created by lisy on 2019/2/19.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderModel.h"
#import "GameOrderFile.h"
#import "MissionModel.h"

#import "MyBTManager.h"

@interface MainGameViewController : UIViewController

- (id)initWithGameOrderFile:(GameOrderFile *)gameOrderFile AndMissionModel:(MissionModel *)missionModel;

@end
