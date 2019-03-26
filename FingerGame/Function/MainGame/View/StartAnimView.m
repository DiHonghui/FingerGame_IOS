//
//  StartAnimView.m
//  FingerGame
//
//  Created by lisy on 2019/2/21.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "StartAnimView.h"

#import "GameSet.h"

@interface StartAnimView()

@property (nonatomic,strong) UILabel *animLabel;

@property (nonatomic,assign) NSInteger animIndex;

@property (nonatomic,copy) FinishBlock completeBlock;

@end

static StartAnimView *instance;

@implementation StartAnimView

+ (instancetype)shareInstance {
    @synchronized(instance) {
        if (!instance) {
            instance = [[StartAnimView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            instance.backgroundColor = [UIColor blackColor];
            instance.alpha = 0.7;
            instance.animLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100/2, SCREEN_HEIGHT/2 - 25, 100, 50)];
            instance.animLabel.textAlignment = NSTextAlignmentCenter;
            instance.animLabel.backgroundColor = [UIColor clearColor];
            instance.animLabel.textColor = [UIColor whiteColor];
            instance.animLabel.font = DefaultFont(50);
            [instance addSubview:instance.animLabel];
            NSLog(@"create instance");
        }
    }
    return instance;
}

//返回一个 动画group
- (CAAnimationGroup *)animationGroup {
    CABasicAnimation *animation1 = [CABasicAnimation animation];
    [animation1 setKeyPath:@"transform.scale"];
    [animation1 setFromValue:@1.0];
    [animation1 setToValue:@4.0];
    [animation1 setDuration:1.0];
    
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    [animation2 setKeyPath:@"alpha"];
    [animation2 setFromValue:@1.0];
    [animation2 setToValue:@0.3];
    [animation2 setDuration:1.0];
    
    
    CAAnimationGroup *animGroup = [[CAAnimationGroup alloc] init];
    animGroup.animations = [NSArray arrayWithObjects:animation1,animation2, nil];
    [animGroup setDuration:1.0];
    [animGroup setDelegate:self];
    return animGroup;
}

//开始动画
- (void)startAnimationWithMax:(NSInteger)num {
    _animLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    _animIndex = num;
    [_animLabel.layer addAnimation:[self animationGroup] forKey:nil];
}

- (void)showWithAnimNum:(NSInteger)num CompleteBlock:(FinishBlock)completeBlock{
    NSLog(@"enter showAnim");
//    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
//    [keyWindow addSubview:[StartAnimView shareInstance]];
    [StartAnimView shareInstance].completeBlock = completeBlock;
    [[StartAnimView shareInstance] startAnimationWithMax:num];
}

#pragma mark - Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ( flag && _animIndex > 0) {
        _animIndex--;
        _animLabel.text = [NSString stringWithFormat:@"%ld",(long)_animIndex];
        [_animLabel.layer addAnimation:[self animationGroup] forKey:nil];
    }
    //动画执行完毕后 执行的操作
    if (_animIndex == 0) {
        if (_completeBlock != nil) {
            self.hidden = true;
            WeakSelf;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"ready to enter the completeBlock");
                self.completeBlock();
                self.completeBlock = nil;
                [weakSelf.animLabel.layer removeAllAnimations];
                weakSelf.hidden = false;
                [weakSelf removeFromSuperview];
            });
        }
    }
}

@end
