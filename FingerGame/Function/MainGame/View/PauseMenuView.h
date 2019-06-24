//
//  PauseMenuView.h
//  FingerGame
//
//  Created by lisy on 2019/6/24.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PauseMenuViewProtocol <NSObject>
@optional

- (void)clickedContinueButton;
- (void)clickedRedoButton;
- (void)clickedEndButton;

@end

@interface PauseMenuView : UIView

@property (nonatomic,weak) id<PauseMenuViewProtocol> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
