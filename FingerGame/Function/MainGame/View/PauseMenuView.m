//
//  PauseMenuView.m
//  FingerGame
//
//  Created by lisy on 2019/6/24.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "PauseMenuView.h"
#import "Masonry.h"
#import "AppMacro.h"

@interface PauseMenuView()

@property (nonatomic,strong) UIView *tipView;
@property (nonatomic,strong) UIView *continueView;
@property (nonatomic,strong) UILabel *continueLabel;
@property (nonatomic,strong) UIView *restartView;
@property (nonatomic,strong) UILabel *restartLabel;
@property (nonatomic,strong) UIView *endView;
@property (nonatomic,strong) UILabel *endLabel;


@end

@implementation PauseMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        NSLog(@"PauseMenuView c");
        [self layoutMySubviews];
    }
    return self;
}

- (void)layoutMySubviews{
    {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = [UIColor blackColor];
        _tipView.layer.borderWidth = 2;
        _tipView.layer.borderColor = [UIColorFromRGB(0xf9b130) CGColor];
        _tipView.layer.cornerRadius = 5;
        _tipView.alpha = 0.35;
        
        _continueView = [[UIView alloc] init];
        _continueView.backgroundColor = UIColorFromRGB(0x03b5f5);
        _continueView.layer.cornerRadius = 15;
        _continueView.layer.borderWidth = 1;
        _continueView.layer.borderColor = [UIColorFromRGB(0xffffff) CGColor];
        _continueView.userInteractionEnabled = YES;
        [_continueView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContinue:)]];
        
        _continueLabel = [[UILabel alloc] init];
        _continueLabel.backgroundColor = [UIColor clearColor];
        _continueLabel.text = @"继续游戏";
        _continueLabel.textColor = UIColorFromRGB(0xffffff);
        _continueLabel.font = [UIFont fontWithName:@"微软雅黑" size:30];
        _continueLabel.textAlignment = NSTextAlignmentCenter;
        
        _restartView = [[UIView alloc] init];
        _restartView.backgroundColor = UIColorFromRGB(0x03b5f5);
        _restartView.layer.cornerRadius = 15;
        _restartView.layer.borderWidth = 1;
        _restartView.layer.borderColor = [UIColorFromRGB(0xffffff) CGColor];
        _restartView.userInteractionEnabled = YES;
        [_restartView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRestart:)]];
        
        _restartLabel = [[UILabel alloc] init];
        _restartLabel.backgroundColor = [UIColor clearColor];
        _restartLabel.text = @"重玩本关";
        _restartLabel.textColor = UIColorFromRGB(0xffffff);
        _restartLabel.font = [UIFont fontWithName:@"微软雅黑" size:30];
        _restartLabel.textAlignment = NSTextAlignmentCenter;
        
        _endView = [[UIView alloc] init];
        _endView.backgroundColor = UIColorFromRGB(0x03b5f5);
        _endView.layer.cornerRadius = 15;
        _endView.layer.borderWidth = 1;
        _endView.layer.borderColor = [UIColorFromRGB(0xffffff) CGColor];
        _endView.userInteractionEnabled = YES;
        [_endView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEnd:)]];
        
        _endLabel = [[UILabel alloc] init];
        _endLabel.backgroundColor = [UIColor clearColor];
        _endLabel.text = @"返回首页";
        _endLabel.textColor = UIColorFromRGB(0xffffff);
        _endLabel.font = [UIFont fontWithName:@"微软雅黑" size:30];
        _endLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    [self addSubview:_tipView];
    
    [self addSubview:_continueView];
    [_continueView addSubview:_continueLabel];
    [self addSubview:_restartView];
    [_restartView addSubview:_restartLabel];
    [self addSubview:_endView];
    [_endView addSubview:_endLabel];
    
    __block CGFloat width = self.frame.size.width;
    __block CGFloat height = self.frame.size.height;
    [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(width/4);
        make.top.equalTo(self.mas_top).offset(height/5);
        make.width.equalTo(@(width/2));
        make.height.equalTo(@(height/3*2));
    }];
    
    [_continueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView.mas_centerX);
        make.centerY.equalTo(self.tipView.mas_centerY).offset(-height*1/6);
        make.height.equalTo(self.tipView.mas_height).multipliedBy(0.17);
        make.width.equalTo(self.tipView.mas_width).multipliedBy(0.5);
    }];
    [_continueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.continueView.mas_centerX);
        make.centerY.equalTo(self.continueView.mas_centerY);
        make.width.equalTo(self.continueView.mas_width);
        make.height.equalTo(@30);
    }];
    [_restartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView.mas_centerX);
        make.centerY.equalTo(self.tipView.mas_centerY);
        make.height.equalTo(self.tipView.mas_height).multipliedBy(0.17);
        make.width.equalTo(self.tipView.mas_width).multipliedBy(0.5);
    }];
    [_restartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.restartView.mas_centerX);
        make.centerY.equalTo(self.restartView.mas_centerY);
        make.width.equalTo(self.restartView.mas_width);
        make.height.equalTo(@30);
    }];
    [_endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView.mas_centerX);
        make.centerY.equalTo(self.tipView.mas_centerY).offset(height*1/6);
        make.height.equalTo(self.tipView.mas_height).multipliedBy(0.17);
        make.width.equalTo(self.tipView.mas_width).multipliedBy(0.5);
    }];
    [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.endView.mas_centerX);
        make.centerY.equalTo(self.endView.mas_centerY);
        make.width.equalTo(self.endView.mas_width);
        make.height.equalTo(@30);
    }];
    
}

#pragma mark - event
- (void)tapContinue:(UIGestureRecognizer *)gr{
    if (self.delegate)
        if ([self.delegate respondsToSelector:@selector(clickedContinueButton)])
            [self.delegate clickedContinueButton];
}

- (void)tapRestart:(UIGestureRecognizer *)gr{
    if (self.delegate)
        if ([self.delegate respondsToSelector:@selector(clickedRedoButton)])
            [self.delegate clickedRedoButton];
}

- (void)tapEnd:(UIGestureRecognizer *)gr{
    if (self.delegate)
        if ([self.delegate respondsToSelector:@selector(clickedEndButton)])
            [self.delegate clickedEndButton];
}

@end
