//
//  StartAnimView.h
//  FingerGame
//
//  Created by lisy on 2019/2/21.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FinishBlock)();

@interface StartAnimView : UIView

//封装为单例
+ (instancetype)shareInstance;
//倒计时动画
- (void)showWithAnimNum:(NSInteger)num CompleteBlock:(FinishBlock)completeBlock;

@end

