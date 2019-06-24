//
//  GameStaticsView.h
//  FingerGame
//
//  Created by lisy on 2019/2/22.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameStaticsViewProtocol <NSObject>
@optional

- (void)clickedStartButton;

@end

@interface GameStaticsView : UIView

@property (nonatomic,weak) id<GameStaticsViewProtocol> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
//配置view上控件初始值
- (void)configWithBestscore:(float)bestScore;
//更新当前分数
- (void)updateScore:(float)score;

@end

