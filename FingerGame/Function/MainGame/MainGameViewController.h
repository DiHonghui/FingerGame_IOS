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

@interface MainGameViewController : UIViewController

- (id)initWithGameOrderFile:(GameOrderFile *)gameOrderFile;

@end
