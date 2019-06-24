//
//  SettlementView.h
//  FingerGame
//
//  Created by lisy on 2019/6/17.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SettlementViewProtocol <NSObject>
@optional

- (void)clickedBackButton;
- (void)clickedRestartButton;
- (void)clickedNextGameButton;

@end

@interface SettlementView : UIView

@property (nonatomic,weak) id<SettlementViewProtocol> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
//配置view上控件初始值
- (void)configWithScore:(float)score Stars:(int)stars Beans:(float)beans Exp:(float)exp;

@end

NS_ASSUME_NONNULL_END
