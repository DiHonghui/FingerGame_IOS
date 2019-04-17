//
//  GameSceneView.h
//  FingerGame
//
//  Created by lisy on 2019/2/19.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CompleteType){
    CompleteTypeDefault = 0,
    CompleteTypeSuccess,
    CompleteTypeFailure,
    CompleteTypeMissed,
    CompleteTypeTouched
};

@interface GameSceneView : UIView

//方块完成类型
@property (nonatomic,assign) CompleteType completeType;
//恢复初始状态
- (void)reSet;

@end

