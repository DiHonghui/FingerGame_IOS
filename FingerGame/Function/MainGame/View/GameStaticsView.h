//
//  GameStaticsView.h
//  FingerGame
//
//  Created by lisy on 2019/2/22.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameStaticsView : UIView

+ (CGFloat)heightForView;
//配置view上控件初始值
- (void)configWithGameName:(NSString *)gameName Score:(float)score;
//更新当前分数
- (void)updateScore:(float)score;

@end
