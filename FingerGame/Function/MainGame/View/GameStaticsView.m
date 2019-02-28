//
//  GameStaticsView.m
//  FingerGame
//
//  Created by lisy on 2019/2/22.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "GameStaticsView.h"
#import "GameSet.h"
#import "Masonry.h"

@interface GameStaticsView()
//显示当前游戏名称
@property (nonatomic,strong) UILabel *gameNameLabel;
//显示当前得分
@property (nonatomic,strong) UILabel *currentScoreLabel;

@end

@implementation GameStaticsView

- (void)configWithGameName:(NSString *)gameName Score:(float)score{
    self.backgroundColor = [UIColor blackColor];
    
    self.gameNameLabel.text = [NSString stringWithFormat:@"游戏名：%@",gameName];
    self.gameNameLabel.textColor = [UIColor whiteColor];
    self.currentScoreLabel.text = [NSString stringWithFormat:@"当前得分：%.f",score];
    self.currentScoreLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.gameNameLabel];
    [self addSubview:self.currentScoreLabel];
    
    [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT/25);
        make.left.equalTo(self.mas_left).offset(100);
        make.height.equalTo(@(SCREEN_HEIGHT/25));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    [self.currentScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameNameLabel.mas_bottom).offset(SCREEN_HEIGHT/25);
        make.left.equalTo(self.mas_left).offset(100);
        make.height.equalTo(@(SCREEN_HEIGHT/25));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
}

- (void)updateScore:(float)score{
    self.currentScoreLabel.text = [NSString stringWithFormat:@"当前得分：%.f",score];
}

+ (CGFloat)heightForView{
    return SCREEN_HEIGHT/5;
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
@end
