//
//  GameStaticsView.m
//  FingerGame
//
//  Created by lisy on 2019/2/22.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "GameStaticsView.h"
#import "Masonry.h"
#import "AppMacro.h"

@interface GameStaticsView()

@property (nonatomic,strong) UIView *tipView;

@property (nonatomic,strong) UILabel *fixedLabel;
//显示最高得分
@property (nonatomic,strong) UIView *bestScoreView;
@property (nonatomic,strong) UILabel *bestScoreLabel;
//开始游戏
@property (nonatomic,strong) UIView *startView;
@property (nonatomic,strong) UILabel *startLabel;

@property (nonatomic,assign) float bestScore;

@end

@implementation GameStaticsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.85;
    }
    return self;
}

- (void)configWithBestscore:(float)bestScore{
    _bestScore = bestScore;
    [self layoutMySubviews];
}

- (void)updateScore:(float)score{
    _bestScoreLabel.text = [NSString stringWithFormat:@"%.f分",score];
}

- (void)layoutMySubviews{
    {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = [UIColor whiteColor];
        _tipView.layer.borderWidth = 2;
        _tipView.layer.borderColor = [UIColorFromRGB(0xf9b130) CGColor];
        _tipView.layer.cornerRadius = 5;
    
        _fixedLabel = [[UILabel alloc] init];
        _fixedLabel.backgroundColor = [UIColor whiteColor];
        _fixedLabel.text = @"历史最高分";
        _fixedLabel.textColor = [UIColor blackColor];
        _fixedLabel.font = [UIFont systemFontOfSize:25];
        _fixedLabel.textAlignment = NSTextAlignmentCenter;
        
        _bestScoreView = [[UIView alloc] init];
        _bestScoreView.backgroundColor = UIColorFromRGB(0xf9b130);
        _bestScoreView.layer.cornerRadius = 15;
        
        _bestScoreLabel = [[UILabel alloc] init];
        _bestScoreLabel.backgroundColor = [UIColor clearColor];
        _bestScoreLabel.text = [NSString stringWithFormat:@"%.f分",_bestScore];
        _bestScoreLabel.textColor = UIColorFromRGB(0xffffff);
        _bestScoreLabel.font = [UIFont fontWithName:@"微软雅黑" size:30];
        _bestScoreLabel.textAlignment = NSTextAlignmentCenter;
        
        _startView = [[UIView alloc] init];
        _startView.backgroundColor = UIColorFromRGB(0x03b5f5);
        _startView.layer.cornerRadius = 15;
        _startView.userInteractionEnabled = YES;
        [_startView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStart:)]];
        
        _startLabel = [[UILabel alloc] init];
        _startLabel.backgroundColor = [UIColor clearColor];
        _startLabel.text = @"开始游戏";
        _startLabel.textColor = UIColorFromRGB(0xffffff);
        _startLabel.font = [UIFont fontWithName:@"微软雅黑" size:30];
        _startLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    [self addSubview:_tipView];
    [self addSubview:_fixedLabel];
    [self addSubview:_bestScoreView];
    [_bestScoreView addSubview:_bestScoreLabel];
    [self addSubview:_startView];
    [_startView addSubview:_startLabel];
    __block CGFloat width = self.frame.size.width;
    __block CGFloat height = self.frame.size.height;
    [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(width/4);
        make.top.equalTo(self.mas_top).offset(height/5);
        make.width.equalTo(@(width/2));
        make.height.equalTo(@(height/12*7));
    }];
    [_fixedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView.mas_centerX);
        make.top.equalTo(self.tipView.mas_top).offset(5);
        make.width.equalTo(self.tipView.mas_width).multipliedBy(0.5);
        make.height.equalTo(@50);
    }];
    [_bestScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fixedLabel.mas_centerX);
        make.top.equalTo(self.fixedLabel.mas_bottom).offset(15);
        make.width.equalTo(self.fixedLabel.mas_width);
        make.height.equalTo(@40);
    }];
    [_bestScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fixedLabel.mas_centerX);
        make.top.equalTo(self.bestScoreView.mas_top).offset(5);
        make.width.equalTo(self.bestScoreView.mas_width);
        make.height.equalTo(@30);
    }];
    [_startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fixedLabel.mas_centerX);
        make.top.equalTo(self.bestScoreView.mas_bottom).offset(15);
        make.width.equalTo(self.fixedLabel.mas_width);
        make.height.equalTo(@40);
    }];
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fixedLabel.mas_centerX);
        make.top.equalTo(self.startView.mas_top).offset(5);
        make.width.equalTo(self.startView.mas_width);
        make.height.equalTo(@30);
    }];
}

#pragma mark - event

- (void)tapStart:(UIGestureRecognizer *)gr{
    if (self.delegate){
        if ([self.delegate respondsToSelector:@selector(clickedStartButton)])
            [self.delegate clickedStartButton];
    }
}

#pragma mark - set&get

@end
