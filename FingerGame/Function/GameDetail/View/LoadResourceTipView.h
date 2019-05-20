//
//  LoadResourceTipView.h
//  FingerGame
//
//  Created by lisy on 2019/5/17.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadResourceTipView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
