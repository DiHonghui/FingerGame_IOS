//
//  GameSet.h
//  FingerGame
//
//  Created by lisy on 2019/2/19.
//  Copyright © 2019 lisy. All rights reserved.
//

#ifndef GameSet_h
#define GameSet_h

#define WeakSelf __weak typeof(self) weakSelf = self

// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width

#define DefaultFont(o) [UIFont fontWithName:@"FZMWJW--GB1-0" size:o]

#define GameSpeed 2

#endif /* GameSet_h */
