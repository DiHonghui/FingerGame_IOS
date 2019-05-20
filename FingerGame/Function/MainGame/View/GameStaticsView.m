//
//  GameStaticsView.m
//  FingerGame
//
//  Created by lisy on 2019/2/22.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "GameStaticsView.h"
#import "Masonry.h"

@interface GameStaticsView()
//显示当前游戏名称
@property (nonatomic,strong) UILabel *gameNameLabel;
//显示当前得分
@property (nonatomic,strong) UILabel *currentScoreLabel;
//退出游戏按钮
@property (nonatomic,strong) UIImageView *backImageView;

@end

@implementation GameStaticsView

- (void)configWithGameName:(NSString *)gameName Score:(float)score{
    self.backgroundColor = [UIColor grayColor];
    
    self.gameNameLabel.text = [NSString stringWithFormat:@"游戏名：%@",gameName];
    self.gameNameLabel.textColor = [UIColor whiteColor];
    self.currentScoreLabel.text = [NSString stringWithFormat:@"当前得分：%.f",score];
    self.currentScoreLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.gameNameLabel];
    [self addSubview:self.currentScoreLabel];
    [self addSubview:self.backImageView];
    
    [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(30);
        make.height.equalTo(@(ScreenHeightLandscape/10));
        make.width.equalTo(@(ScreenWidthLandscape/3));
    }];
    [self.currentScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameNameLabel.mas_top);
        make.left.equalTo(self.gameNameLabel.mas_right).offset(30);
        make.height.equalTo(@(ScreenHeightLandscape/10));
        make.width.equalTo(@(ScreenWidthLandscape/3));
    }];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
}

- (void)updateScore:(float)score{
    self.currentScoreLabel.text = [NSString stringWithFormat:@"当前得分：%.f",score];
}

+ (CGFloat)heightForView{
    return ScreenHeightLandscape/10;
}

#pragma mark - event
- (void)clickBackButton{
    if ([self.delegate respondsToSelector:@selector(clickedBackButton)])
        [self.delegate clickedBackButton];
}

#pragma mark - set&get
- (UILabel *)gameNameLabel{
    if(!_gameNameLabel)
        _gameNameLabel = [[UILabel alloc] init];
    return _gameNameLabel;
}

- (UILabel *)currentScoreLabel{
    if(!_currentScoreLabel)
        _currentScoreLabel = [[UILabel alloc] init];
    return _currentScoreLabel;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exitIcon"]];
        _backImageView.backgroundColor = [UIColor clearColor];
        _backImageView.userInteractionEnabled = YES;
        [_backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackButton)]];
    }
    return _backImageView;
}

@end
