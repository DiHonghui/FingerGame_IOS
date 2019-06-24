//
//  SettlementView.m
//  FingerGame
//
//  Created by lisy on 2019/6/17.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "SettlementView.h"
#import "Masonry.h"
#import "AppMacro.h"

@interface SettlementView()

@property (nonatomic,strong) UIView *tipView;

@property (nonatomic,strong) UILabel *fixedLabel;
@property (nonatomic,strong) UILabel *scoreLabel;
@property (nonatomic,strong) UIImageView *iv1;
@property (nonatomic,strong) UIImageView *iv2;
@property (nonatomic,strong) UIImageView *iv3;
@property (nonatomic,strong) UIImageView *beansIv;
@property (nonatomic,strong) UILabel *beansLb;
@property (nonatomic,strong) UIImageView *expIv;
@property (nonatomic,strong) UILabel *expLb;

@property (nonatomic,strong) UIView *nextView;
@property (nonatomic,strong) UILabel *nextLabel;
@property (nonatomic,strong) UIView *endView;
@property (nonatomic,strong) UILabel *endLabel;
@property (nonatomic,strong) UIView *restartView;
@property (nonatomic,strong) UILabel *restartLabel;

@property (nonatomic,assign) float score;
@property (nonatomic,assign) int stars;
@property (nonatomic,assign) float beans;
@property (nonatomic,assign) float exp;

@end

@implementation SettlementView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        NSLog(@"settlement c");
        [self setAlpha:0.85];
    }
    return self;
}

- (void)configWithScore:(float)score Stars:(int)stars Beans:(float)beans Exp:(float)exp {
    _score = score;
    _stars = stars;
    _beans = beans;
    _exp = exp;
    [self layoutMySubviews];
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
        _fixedLabel.text = @"得分";
        _fixedLabel.textColor = [UIColor blackColor];
        _fixedLabel.font = [UIFont systemFontOfSize:30];
        _fixedLabel.textAlignment = NSTextAlignmentCenter;
        
        {
            _iv1 = [[UIImageView alloc] init];
            _iv1.backgroundColor = [UIColor whiteColor];
            _iv1.image = [UIImage imageNamed:@"Star_Default"];
            _iv2 = [[UIImageView alloc] init];
            _iv2.backgroundColor = [UIColor whiteColor];
            _iv2.image = [UIImage imageNamed:@"Star_Default"];
            _iv3 = [[UIImageView alloc] init];
            _iv3.backgroundColor = [UIColor whiteColor];
            _iv3.image = [UIImage imageNamed:@"Star_Default"];
        }
        
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.backgroundColor = [UIColor whiteColor];
        _scoreLabel.text = [NSString stringWithFormat:@"%.f分",_score];
        _scoreLabel.textColor = UIColorFromRGB(0xffb200);
        _scoreLabel.font = [UIFont fontWithName:@"微软雅黑" size:40];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        
        _beansIv = [[UIImageView alloc] init];
        _beansIv.backgroundColor = [UIColor whiteColor];
        _beansIv.layer.cornerRadius = 20;
        _beansIv.image = [UIImage imageNamed:@"Beans"];
        
        _beansLb = [[UILabel alloc] init];
        _beansLb.backgroundColor = [UIColor whiteColor];
        _beansLb.text = [NSString stringWithFormat:@"+  %.f",_beans];
        _beansLb.textColor = UIColorFromRGB(0x424242);
        _beansLb.font = [UIFont fontWithName:@"微软雅黑" size:36];
        _beansLb.textAlignment = NSTextAlignmentCenter;
        
        _expIv = [[UIImageView alloc] init];
        _expIv.backgroundColor = [UIColor whiteColor];
        _expIv.layer.cornerRadius = 20;
        _expIv.image = [UIImage imageNamed:@"Exp"];
        
        _expLb = [[UILabel alloc] init];
        _expLb.backgroundColor = [UIColor whiteColor];
        _expLb.text = [NSString stringWithFormat:@"+  %.f",_exp];
        _expLb.textColor = UIColorFromRGB(0x424242);
        _expLb.font = [UIFont fontWithName:@"微软雅黑" size:36];
        _expLb.textAlignment = NSTextAlignmentCenter;
        
        _nextView = [[UIView alloc] init];
        _nextView.backgroundColor = UIColorFromRGB(0xffb200);
        _nextView.layer.cornerRadius = 15;
        _nextView.layer.borderWidth = 0.1;
        _nextView.layer.borderColor = [UIColorFromRGB(0xffffff) CGColor];
        _nextView.userInteractionEnabled = YES;
        [_nextView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNext:)]];
        
        _nextLabel = [[UILabel alloc] init];
        _nextLabel.backgroundColor = [UIColor clearColor];
        _nextLabel.text = @"开始下一关";
        _nextLabel.textColor = UIColorFromRGB(0xffffff);
        _nextLabel.font = [UIFont fontWithName:@"微软雅黑" size:30];
        _nextLabel.textAlignment = NSTextAlignmentCenter;
        
        _endView = [[UIView alloc] init];
        _endView.backgroundColor = UIColorFromRGB(0x63b55b);
        _endView.layer.cornerRadius = 15;
        _endView.layer.borderWidth = 0.1;
        _endView.layer.borderColor = [UIColorFromRGB(0xffffff) CGColor];
        _endView.userInteractionEnabled = YES;
        [_endView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack:)]];
        
        _endLabel = [[UILabel alloc] init];
        _endLabel.backgroundColor = [UIColor clearColor];
        _endLabel.text = @"返回首页";
        _endLabel.textColor = UIColorFromRGB(0xffffff);
        _endLabel.font = [UIFont fontWithName:@"微软雅黑" size:30];
        _endLabel.textAlignment = NSTextAlignmentCenter;
        
        _restartView = [[UIView alloc] init];
        _restartView.backgroundColor = UIColorFromRGB(0x63b55b);
        _restartView.layer.cornerRadius = 15;
        _restartView.layer.borderWidth = 0.1;
        _restartView.layer.borderColor = [UIColorFromRGB(0xffffff) CGColor];
        _restartView.userInteractionEnabled = YES;
        [_restartView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRestart:)]];
        
        _restartLabel = [[UILabel alloc] init];
        _restartLabel.backgroundColor = [UIColor clearColor];
        _restartLabel.text = @"重玩本关";
        _restartLabel.textColor = UIColorFromRGB(0xffffff);
        _restartLabel.font = [UIFont fontWithName:@"微软雅黑" size:30];
        _restartLabel.textAlignment = NSTextAlignmentCenter;
    }
    //
    switch (_stars) {
        case 0:
            break;
        case 1:
            _iv1.image = [UIImage imageNamed:@"Star_Get"];
            break;
        case 2:
            _iv1.image = [UIImage imageNamed:@"Star_Get"];
            _iv2.image = [UIImage imageNamed:@"Star_Get"];
            break;
        case 3:
            _iv1.image = [UIImage imageNamed:@"Star_Get"];
            _iv2.image = [UIImage imageNamed:@"Star_Get"];
            _iv3.image = [UIImage imageNamed:@"Star_Get"];
        default:
            break;
    }
    //
    
    [self addSubview:_tipView];
    [self addSubview:_fixedLabel];
    [self addSubview:_iv1];
    [self addSubview:_iv2];
    [self addSubview:_iv3];
    [self addSubview:_scoreLabel];
    [self addSubview:_beansIv];
    [self addSubview:_beansLb];
    [self addSubview:_expIv];
    [self addSubview:_expLb];
    
    [self addSubview:_nextView];
    [_nextView addSubview:_nextLabel];
    [self addSubview:_endView];
    [_endView addSubview:_endLabel];
    [self addSubview:_restartView];
    [_restartView addSubview:_restartLabel];
    
    __block CGFloat width = self.frame.size.width;
    __block CGFloat height = self.frame.size.height;
    [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(width/4);
        make.top.equalTo(self.mas_top).offset(height/9);
        make.width.equalTo(@(width/2));
        make.height.equalTo(@(height/4*3));
    }];
    [_fixedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView.mas_centerX);
        make.top.equalTo(self.tipView.mas_top).offset(2);
        make.width.equalTo(self.tipView.mas_width).multipliedBy(0.5);
        make.height.equalTo(@35);
    }];
    [_iv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView.mas_centerX).offset(-30);
        make.top.equalTo(self.fixedLabel.mas_bottom).offset(2);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [_iv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView.mas_centerX);
        make.top.equalTo(self.fixedLabel.mas_bottom).offset(2);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [_iv3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView.mas_centerX).offset(30);
        make.top.equalTo(self.fixedLabel.mas_bottom).offset(2);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView.mas_centerX);
        make.top.equalTo(self.iv1.mas_bottom).offset(1);
        make.width.equalTo(self.tipView.mas_width).multipliedBy(0.5);
        make.height.equalTo(@40);
    }];
    [_beansIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView.mas_centerX).offset(-80);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(1);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [_beansLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beansIv.mas_centerX).offset(25);
        make.centerY.equalTo(self.beansIv.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(@40);
    }];
    [_expIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView.mas_centerX).offset(25);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(1);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [_expLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.expIv.mas_centerX).offset(25);
        make.centerY.equalTo(self.expIv.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(@40);
    }];
    
    [_restartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipView.mas_left).offset(2);
        make.bottom.equalTo(self.tipView.mas_bottom).offset(-2);
        make.right.equalTo(self.tipView.mas_centerX);
        make.height.equalTo(@40);
    }];
    [_restartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.restartView.mas_centerX);
        make.top.equalTo(self.restartView.mas_top).offset(5);
        make.width.equalTo(self.restartView.mas_width);
        make.height.equalTo(@30);
    }];
    [_endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.restartView.mas_right);
        make.bottom.equalTo(self.restartView.mas_bottom);
        make.width.equalTo(self.restartView.mas_width);
        make.height.equalTo(@40);
    }];
    [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.endView.mas_centerX);
        make.top.equalTo(self.endView.mas_top).offset(5);
        make.width.equalTo(self.endView.mas_width);
        make.height.equalTo(@30);
    }];
    [_nextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipView.mas_left).offset(2);
        make.bottom.equalTo(self.restartView.mas_top);
        make.right.equalTo(self.tipView.mas_right).offset(-2);
        make.height.equalTo(@40);
    }];
    [_nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.nextView.mas_centerX);
        make.top.equalTo(self.nextView.mas_top).offset(5);
        make.width.equalTo(self.nextView.mas_width);
        make.height.equalTo(@30);
    }];

}

#pragma mark - event
- (void)tapBack:(UIGestureRecognizer *)gr{
    if (self.delegate)
        if ([self.delegate respondsToSelector:@selector(clickedBackButton)])
            [self.delegate clickedBackButton];
}

- (void)tapRestart:(UIGestureRecognizer *)gr{
    if (self.delegate)
        if ([self.delegate respondsToSelector:@selector(clickedRestartButton)])
            [self.delegate clickedRestartButton];
}

- (void)tapNext:(UIGestureRecognizer *)gr{
}

@end
